#!/usr/bin/env bash

# Author: Ted Ralphs (ted@lehigh.edu)
# Copyright 2016-2018, Ted Ralphs
# Released Under the Eclipse Public License 
#
# TODO
# - fix dependency-tracking or remove it from configure
# - consider using pushd/popd instead of cd somewhere/cd ..
# - look at TODO and FIXME below

# script debugging
#set -x
#PS4='${LINENO}:${PWD}: '

function help {
    echo "Usage: get.dependencies.sh <command> --option1 --option2"
    echo
    echo "Commands:"
    echo
    echo "  fetch: Checkout source code for all dependencies"
    echo "    options: --svn (checkout from SVN)"
    echo "             --git (checkout from git)"
    echo "             --skip='proj1 proj2' skip listed projects"
    echo "             --no-third-party don't download third party source (getter-scripts)"
    echo
    echo "  build: Configure, build, test (optional), and pre-install all projects"
    echo "    options: --xxx=yyy (will be passed through to configure)"
    echo "             --parallel-jobs=n build in parallel with maximum 'n' jobs"
    echo "             --build-dir=\dir\to\build\in do a VPATH build (default: $PWD/build)"
    echo "             --test run unit test of main project before install"
    echo "             --test-all run unit tests of all projects before install"
    echo "             --verbosity=i set verbosity level (1-4)"
    echo "             --reconfigure re-run configure"
    echo
    echo "  install: Install all projects in location specified by prefix"
    echo "    options: --prefix=\dir\to\install (where to install, default: $PWD/build)"
    echo
    echo "  uninstall: Uninstall all projects"
    echo
    echo "General options:"
    echo "  --debug: Turn on debugging output"
    echo "  --no-prompt: Turn on non-interactive mode"
    echo 
}

function print_action {
    echo
    echo "##################################################"
    echo "### $1 "
    echo "##################################################"
    echo
}

function get_cached_options {
    echo "Reading cached options:"
    # read options from file, one option per line, and store into array copts
    readarray -t copts < "$build_dir/.config"
    # move options from copts[0], copts[1], ... into
    # configure_options, where they are stored as the keys
    # skip options that are empty (happens when reading empty .config file)
    for c in ${!copts[*]} ; do
        [ -z "${copts[$c]}" ] && continue
        configure_options["${copts[$c]}"]=""
    done
    # print configuration options, one per line
    # (TODO might need verbosity level check)
    printf "%s\n" "${!configure_options[@]}"
}

function invoke_make {
    if [ $1 = 1 ]; then
        $MAKE -j $jobs $2 >& /dev/null
    elif [ $1 = 2 ]; then
        $MAKE -j $jobs $2 > /dev/null
    else
        $MAKE -j $jobs $2
    fi
}

function get_project {
    TMP_IFS=$IFS
    unset IFS
    for i in $coin_skip_projects
    do
        if [ $1 = $i ]; then
            IFS=$TMP_IFS
            return 1
        fi
    done
    IFS=$TMP_IFS
    return 0
}

# Parse arguments
function parse_args {
    echo "Script run with the following arguments:"
    for arg in "$@"
    do
        echo $arg
        option=
        option_arg=
        case $arg in
            *=*)
                option=`expr "x$arg" : 'x\(.*\)=[^=]*'`
                option_arg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
                # with bash, one could also do it in the following way:
                # option=${arg%%=*}    # remove longest suffix matching =*
                # option_arg=${arg#*=} # remove shortest prefix matching *=
                case $option in
                    --prefix)
                        if [ "x$option_arg" != x ]; then
                            case $option_arg in
                                [\\/$]* | ?:[\\/]* | NONE | '' )
                                    prefix=$option_arg
                                    ;;
                                *)  
                                    echo "Prefix path must be absolute."
                                    exit 3
                                    ;;
                            esac
                        else
                            echo "No path provided for --prefix"
                            exit 3
                        fi
                        ;;
                    --build-dir)
                        if [ "x$option_arg" != x ]; then
                            case $option_arg in
                                [\\/$]* | ?:[\\/]* | NONE | '' )
                                    build_dir=$option_arg
                                    ;;
                                *)
                                    build_dir=$PWD/$option_arg
                                    ;;
                            esac
                        else
                            echo "No path provided for --build-dir"
                            exit 3
                        fi
                        ;;
                    --parallel-jobs)
                        if [ "x$option_arg" != x ]; then
                            jobs=$option_arg
                        else
                            echo "No number specified for --parallel-jobs"
                            exit 3
                        fi
                        ;;
                    --threads)
                        echo "The 'threads' argument has been re-named 'parallel-jobs'."
                        echo "Please re-run with correct argument name"
                        exit 3
                        ;;
                    --verbosity)
                        if [ "x$option_arg" != x ]; then
                            verbosity=$option_arg
                        else
                            echo "No verbosity specified for --verbosity"
                            exit 3
                        fi
                        ;;
                    --main-proj)
                        if [ "x$option_arg" != x ]; then
                            main_proj=$option_arg
                        else
                            echo "No main project specified"
                            exit 3
                        fi
                        ;;
                    --main-proj-version)
                        if [ "x$option_arg" != x ]; then
                            main_proj_version=$option_arg
                        else
                            echo "No main project specified"
                            exit 3
                        fi
                        ;;
                    DESTDIR)
                        echo "DESTDIR installation not supported"
                        exit 3
                        ;;
                    --skip)
                        if [ "x$option_arg" != x ]; then
                            coin_skip_projects=$option_arg
                        fi
                        ;;
                    *)
                        configure_options["$arg"]=""
                        ;;            
                esac
                ;;
            --help)
                help
                exit 0
                ;;
            --sparse)
                sparse=true
                ;;
            --svn)
                VCS=svn
                ;;
            --git)
                VCS=git
                ;;
            --debug)
                set -x
                ;;
            --reconfigure)
                reconfigure=true
                ;;
            --test)
                run_test=true
                ;;
            --test-all)
                run_all_tests=true
                ;;
            --no-third-party)
                get_third_party=false
                ;;
            --no-prompt)
                no_prompt=true
                ;;
            --*)
                configure_options["$arg"]=""
                ;;
            fetch)
                num_actions+=1
                fetch=true
                ;;
            build)
                num_actions+=1
                build=true
                ;;
            install)
                num_actions+=1
                install=true
                ;;
            uninstall)
                num_actions+=1
                uninstall=true
                ;;
            *)
                echo "Unrecognized command...exiting"
                exit 3
                ;;
        esac
    done
    echo
}

function user_prompts {

    # Help
    if [ $num_actions = 0 ]; then
        if [ $no_prompt = "false" ]; then
            echo "Please choose an action by typing 1-3."
            echo " 1. Fetch source code of a project and its dependencies."
            echo " 2. Build a project and its dependencies."
            echo " 3. Install a project and its dependencies."
            echo " 4. Help"
            continue=false
            while [ $continue = "false" ]; do
                echo -n "=> "
                read choice
                case $choice in
                    1)
                        fetch=true
                        ;;
                    2)
                        build=true
                        echo "Please specify a build directory (can be relative or absolute)."
                        echo -n "=> "
                        read user_build_dir
                        case $user_build_dir in
                            [\\/$]* | ?:[\\/]* | NONE | '' )
                                build_dir=$user_build_dir
                                ;;
                            *)
                                build_dir=$PWD/$user_build_dir
                                ;;
                        esac
                        ;;
                    3) 
                        install=true
                        echo "Please specify an install directory (can be relative or absolute)."
                        echo -n "=> "
                        read prefix
                        ;;
                    4)
                        help
                        exit 0
                        ;;
                    done) continue=true;;
                esac
                echo "Choose another action or type 'done'"
            done
        else
            help
            exit 0
        fi
    fi

    if [ x"$prefix" != x ] && [ install = "false" ]; then
        echo "Prefix should only be specified at install"
        exit 3
    fi
    if [ x"$prefix" = x ]; then
        prefix=$build_dir
    fi
    
    if [ x$main_proj = x ] && [ $no_prompt = false ]; then
        echo
        echo "Please choose a main project to fetch/build by typing 1-18"
        echo "or simply type the repository name of another project not" 
        echo "listed here (it must be a project with a 'Dependencies' file)."
        echo " 1. Osi"
        echo " 2. Clp"
        echo " 3. Cbc"
        echo " 4. DyLP"
        echo " 5. FlopC++"
        echo " 6. Vol"
        echo " 7. SYMPHONY"
        echo " 8. Smi"
        echo " 9. CoinMP"
        echo " 10. Bcp"
        echo " 11. Ipopt"
        echo " 12. Alps"
        echo " 13. Blis"
        echo " 14. Dip"
        echo " 15. Bonmin"
        echo " 16. Couenne"
        echo " 17. Optimization Services"
        echo " 18. All"
        echo " 19. Let me enter another project"
        echo -n "=> "
        read choice
        echo
        case $choice in
            1)  main_proj=Osi;;
            2)  main_proj=Clp;;
            3)  main_proj=Cbc;;
            4)  main_proj=DyLP;;
            5)  main_proj=FlopC++;;
            6)  main_proj=Vol;;
            7)  main_proj=SYMPHONY;;
            8)  main_proj=Smi;;
            9)  main_proj=CoinMP;;
            10)  main_proj=Bcp;;
            11)  main_proj=Ipopt;;
            12)  main_proj=Alps;;
            13)  main_proj=Blis;;
            14)  main_proj=Dip;;
            15)  main_proj=Bonmin;;
            16)  main_proj=Couenne;;
            17)  main_proj=OS;;
            18)  ;;
            19)
                echo "Enter the name of the project"
                echo -n "=> "
                read choice2
                main_proj=$choice2
                ;;
            *)  main_proj=$choice;;
        esac
    fi

    if [ x$main_proj != x ]; then
        if [ -d $main_proj ]; then
            if [ -d $main_proj/.git ]; then
                VCS=git
            else
                VCS=svn
            fi
            if [ $fetch = "false" ]; then
                cd $main_proj
                if [ $VCS = "git" ]; then
                    current_version=`git branch | grep \* | cut -d ' ' -f 2`
                    if [ $current_version = "(HEAD" ]; then
                        current_version=`git branch | grep \* | cut -d ' ' -f 5`
                    fi
                else
                    if [ `svn info | fgrep "URL" | cut -d '/' -f 6` = trunk ]; then
                        current_version=trunk
                    else
                        current_version=`echo $url | cut -d '/' -f 6-7`
                    fi
                fi
                cd $root_dir
                echo "################################################"
                echo "### Building/installing version $current_version"
                echo "### with existing versions of dependnecies."
                echo "### Run 'fetch' first to switch versions" 
                echo "### or to ensure correct dependencies"
                echo "################################################"
                echo 
                if [ $no_prompt = false ]; then
                    echo "Fetch now? y/n"
                    got_choice=false
                    while [ $got_choice = "false" ]; do
                        echo -n "=> "
                        read choice
                        case $choice in
                            y|n) got_choice=true;;
                            *) ;;
                        esac
                    done
                    case $choice in
                        y)
                            fetch="true"
                            ;;
                        n)
                            ;;
                    esac
                fi
            fi
        elif [ $fetch = "false" ]; then
            echo "It appears that project has not been fetched yet."
            if [ $no_prompt = "false" ]; then
                echo "Fetch now? y/n"
                got_choice=false
                while [ $got_choice = "false" ]; do
                    echo -n "=> "
                    read choice
                    case $choice in
                        y|n) got_choice=true;;
                        *) ;;
                    esac
                done
                case $choice in
                    y)
                        fetch="true"
                        ;;
                    n)
                        ;;
                esac
            fi
            if [ $fetch = "false" ]; then
                echo "Exiting..."
                exit 10
            fi
        fi
    fi
    
    if [ x$main_proj != x ] && [ x$main_proj_version = x ] && [ $fetch = true ] &&
           [ $no_prompt = false ]; then
        echo
        echo "It appears that the last 10 releases of $main_proj are"
        git ls-remote --tags https://github.com/coin-or/$main_proj | fgrep releases | cut -d '/' -f 4 | sort -nr -t. -k1,1 -k2,2 -k3,3 | head -10
        echo "Do you want to work with the latest release? (y/n)"
        got_choice=false
        while [ $got_choice = "false" ]; do
            echo -n "=> "
            read choice
            case $choice in
                y|n) got_choice=true;;
                *) ;;
            esac
        done
        case $choice in
            y) main_proj_version=releases/`git ls-remote --tags https://github.com/coin-or/$main_proj | fgrep releases | cut -d '/' -f 4 | sort -nr -t. -k1,1 -k2,2 -k3,3 | head -1`
               ;;
            n) echo "Please enter another version name in the form of"
               if [ $VCS = "svn" ]; then
                   echo 'trunk', 'releases/x.y.z', or 'stable/x.y'
               else
                   echo 'master', 'releases/x.y.z', or 'stable/x.y'
               fi
               echo -n "=> "
               read choice
               main_proj_version=$choice
               ;;
        esac
        echo
    fi
    
    if [ -e $build_dir/.config ] && [ $build = "true" ] && 
           [ $reconfigure = false ]; then
        echo "###"
        echo "### Cached configuration options from previous build found."
        echo "###"
        if [ x"${#configure_options[*]}" != x0 ]; then
            echo
            echo "You are trying to run the build again and have specified"
            echo "configuration options on the command line."
            echo
            if [ $no_prompt = false ]; then
                echo "Please choose one of the following options."
                echo " The indicated action will be performed for you AUTOMATICALLY"
                echo "1. Run the build again with the previously specified options."
                echo "   This can also be accomplished invoking the build"
                echo "   command without any arguments."
                echo "2. Configure in a new build directory (whose name you will be"
                echo "   prmpted to specify) with new options."
                echo "3. Re-configure in the same build directory with the new"
                echo "   options. This option is not recommended unless you know"
                echo "   what you're doing!."
                echo "4. Quit"
                echo
                got_choice=false
                while [ $got_choice = "false" ]; do
                    echo "Please type 1, 2, 3, or 4"
                    echo -n "=> "
                    read choice
                    case $choice in
                        1|2|3|4) got_choice=true;;
                        *) ;;
                    esac
                done
                case $choice in
                    1)  ;;
                    2)
                        echo "Please enter a new build directory:"
                        echo -n "=> "
                        read dir
                        if [ x"$dir" != x ]; then
                            case $dir in
                                [\\/$]* | ?:[\\/]* | NONE | '' )
                                    build_dir=$dir
                                    ;;
                                *)
                                    build_dir=$PWD/$dir
                                    ;;
                            esac
                        fi
                        ;;
                    3)
                        rm $build_dir/.config
                        reconfigure=true
                        ;;
                    4)
                        exit 0
                esac
            else
                echo "Please re-run the build and force reconfiguration with --reconfigure."
                echo "Exiting..."
                exit 10
            fi
        fi
    fi
    
    if [ x"${#configure_options[*]}" != x0 ] && [ $build = "false" ]; then
        echo "Configuration options should be specified only with build command"
        exit 3
    fi
    
    if [ $build = "true" ]; then
        if [ ! -e $build_dir/.config ] || [ $reconfigure = "true" ]; then
            echo "Caching configuration options..."
            mkdir -p $build_dir
            printf "%s\n" "${!configure_options[@]}" > $build_dir/.config
        else
            get_cached_options
        fi
        echo "Options to be passed to configure: ${!configure_options[@]}"
    fi
    echo
}


function fetch_proj {
    current_rev=
    if [ $1 = "svn" ]; then
        if [ -d $dir ]; then
            cd $dir
            # Get current version and revision
            current_url=`svn info | fgrep "URL: https" | cut -d " " -f 2`
            current_rev=`svn info | fgrep "Revision:" | cut -d " " -f 2`
            if [ $proj = "BuildTools" ] &&
                   [ `echo $url | cut -d '/' -f 6` = 'ThirdParty' ]; then
                if [ `echo $current_url | cut -d '/' -f 8` = trunk ]; then
                    current_version=trunk
                else
                    current_version=`echo $url | cut -d '/' -f 8-9`
                fi
            elif [ $proj = "CHiPPS" ]; then
                if [ `echo $current_url | cut -d '/' -f 7` = trunk ]; then
                    current_version=trunk
                else
                    current_version=`echo $url | cut -d '/' -f 7-8`
                fi
            elif [ $proj = "Data" ]; then
                if [ `echo $current_url | cut -d '/' -f 7` = trunk ]; then
                    current_version=trunk
                else
                    current_version=`echo $url | cut -d '/' -f 7-8`
                fi
            else
                if [ `echo $current_url | cut -d '/' -f 6` = trunk ]; then
                    current_version=trunk
                else
                    current_version=`echo $url | cut -d '/' -f 6-7`
                fi
            fi
            if [ $current_version != $version ]; then
                print_action "Switching $dir to $version"
                svn --non-interactive --trust-server-cert switch $url
                new_rev=`svn info | fgrep "Revision:" | cut -d " " -f 2`
            else
                print_action "Updating $dir"
                svn --non-interactive --trust-server-cert update
                new_rev=`svn info | fgrep "Revision:" | cut -d " " -f 2`
            fi
            cd $root_dir
        else
            print_action "Fetching $dir $version"
            svn co --non-interactive --trust-server-cert $url $dir
            cd $dir
            new_rev=`svn info | fgrep "Revision:" | cut -d " " -f 2`
            cd $root_dir
        fi
    else
        if [ $version = "trunk" ] ; then
            version=master
        fi
        if [ -d $dir ]; then
            cd $dir
            current_version=`git branch | grep \* | cut -d ' ' -f 2`
            current_rev=`git rev-parse HEAD`
            if [ $current_version != $version ]; then
                print_action "Switching $dir to $version"
                git checkout $version
                if [ `echo $current_version | cut -d " " -f 1` != "(HEAD" ]; then
                    git pull
                fi
                new_rev=`git rev-parse HEAD`
            else
                print_action "Updating $dir"
                git pull
                new_rev=`git rev-parse HEAD`
            fi
            cd $root_dir
        else
            print_action "Fetching $dir $version"
            if [ $sparse = "true" ]; then
                mkdir $dir
                cd $dir
                git init
                git remote add origin $url
                git config core.sparsecheckout true
                echo $proj/ >> .git/info/sparse-checkout
                git fetch
                git checkout $version
                new_rev=`git rev-parse HEAD`
                cd root_dir
            else
                git clone --branch=$version $url $dir
                cd $dir
                new_rev=`git rev-parse HEAD`
                cd $root_dir                
            fi     
        fi
    fi

    # If this is a third party project, fetch the source if desired
    if [ $get_third_party = "true" ] &&
           ([ x$current_rev != x$new_rev ] ||
                [ $current_version != $version ]) &&
           [ `echo $dir | cut -d '/' -f 1` = ThirdParty ]; then
        tp_proj=`echo $dir | cut -d '/' -f 2`
        if [ -e $dir/get.$tp_proj ]; then
            cd $dir
            ./get.$tp_proj
            touch .build
            cd -
        else
            echo "Not downloading source for $tp_proj..."
        fi
    fi  
}
        
function build_proj {
    if [ `echo $dir | cut -d '/' -f 1` = ThirdParty ] &&
           [ ! -e $dir/.build ]; then
        echo
        echo "Skipping build of $dir"
        echo
    else
        mkdir -p $build_dir/$dir
        echo -n $dir" " >> $build_dir/coin_subdirs.txt
        cd $build_dir/$dir
        if [ ! -e config.status ] || [ $reconfigure = "true" ]; then
            if [ $reconfigure = "true" ]; then
                print_action "Reconfiguring $dir"
            else
                print_action "Configuring $dir"
            fi
            if [ -e $root_dir/$dir/$dir/configure ]; then
                config_script="$root_dir/$dir/$dir/configure"
            else
                config_script="$root_dir/$dir/configure"
            fi
            if [ $verbosity -ge 3 ]; then
                "$config_script" --disable-dependency-tracking --prefix=$1 "${!configure_options[@]}"
            else
                "$config_script" --disable-dependency-tracking --prefix=$1 "${!configure_options[@]}" > /dev/null
            fi
        fi
        print_action "Building $dir"
        if [ $verbosity -ge 3 ]; then
            invoke_make $(($verbosity-1)) ""
        else
            invoke_make 1 ""
        fi
        if [ $run_all_tests = "true" ]; then
            print_action "Running $proj unit test"
            invoke_make "false" test
        elif [ $run_test = "true" ] && [ x$main_proj != x ]; then
            if [ $main_proj = $dir ]; then
                print_action "Running $proj unit test"
                invoke_make "false" test
            fi
        fi
        if [ $1 = $build_dir ]; then
            print_action "Pre-installing $dir"
        else
            print_action "Installing $dir"
        fi
        if [ $verbosity -ge 3 ]; then
            invoke_make $(($verbosity-1)) install
        else
            invoke_make 1 install
        fi
        cd $root_dir
    fi
}

function install_proj {
    if [ $prefix != $build_dir ]; then
        print_action "Reconfiguring projects and doing final install"
        reconfigure=true
        build_proj $prefix
    else
        echo
        echo "Please specify a prefix to install with --prefix"
        echo
    fi
}

function uninstall {
    # We have to uninstall in reverse order
    # subdirs must be defined for this to work
    for ((dir=${#subdirs[@]}-1; i>=0; i--))
    do
        if [ $build_dir != $PWD ]; then
            proj_dir=`echo $dir | cut -d '/' -f 1`
            if [ $proj_dir = "Data" ] || [ $proj_dir = "ThirdParty" ]; then
                proj_dir=$dir
            fi
            cd $build_dir/$proj_dir
        else
            cd $dir
        fi
        print_action "Uninstalling $proj_dir"
        invoke_make $verbosity uninstall
        cd $root_dir
    done
    if [ -e $main_proj ]; then
        if [ $build_dir != $PWD ]; then
            mkdir -p $build_dir/$main_proj
            cd $build_dir/$main_proj
        else
            cd $main_proj
        fi
    fi
    print_action "Uninstalling $main_proj"
    invoke_make $verbosity uninstall
    cd $root_dir
}
    
# Exit when command fails
set -e
#Attempt to use undefined variable outputs error message, and forces an exit
set -u
#Causes a pipeline to return the exit status of the last command in the pipe
#that returned a non-zero return value.
set -o pipefail

# Set defaults
root_dir=$PWD
declare -i num_actions
num_actions=0
sparse=false
prefix=
coin_skip_projects=
svn=true
fetch=false
build=false
install=false
uninstall=false
run_test=false
run_all_tests=false
declare -A configure_options
configure_options=()
jobs=1
build_dir=$PWD/build
reconfigure=false
get_third_party=true
verbosity=4
main_proj=
main_proj_version=
main_proj_dir=
MAKE=make
VCS=git
no_prompt=false

echo "Welcome to the COIN-OR fetch and build utility"
echo 
echo "For help, run script with --help."
echo 

parse_args "$@"

user_prompts

# Fetch main project first
if [ x$main_proj != x ]; then
    if [ $VCS = "git" ]; then
        if [ x`echo $main_proj | cut -d '-' -f 1` = x"CHiPPS" ]; then
            main_proj_dir=`echo $main_proj | cut -d '-' -f 2`
        else
            main_proj_dir=$main_proj
        fi
        if [ x$main_proj_version = x ]; then
            main_proj_version=master
        fi
        main_proj_url="https://github.com/coin-or/$main_proj"
    else
        main_proj_dir=$main_proj
        if [ x$main_proj_version = x ]; then
            main_proj_version=trunk
        fi
        main_proj_url="https://projects.coin-or.org/svn/$main_proj/$main_proj_version/$main_proj"
    fi
    if [ $fetch = true ]; then
        url=$main_proj_url
        dir=$main_proj_dir
        proj=$main_proj
        version=$main_proj_version
        fetch_proj $VCS
        if [ $VCS = "svn" ]; then
            svn cat --non-interactive --trust-server-cert https://projects.coin-or.org/svn/$proj/$version/Dependencies > $dir/Dependencies
        fi
    fi
fi

# This changes the default separator used in for loops to carriage return.
# We need this later.
IFS=$'\n'

# Build list of dependencies
if [ -e Dependencies ] && [ x$main_proj = x ]; then
    deps=`cat Dependencies | tr '\t' ' ' | tr -s ' '`
elif [ x$main_proj != x ] && [ -e $main_proj/Dependencies ]; then
    deps=`cat $main_proj/Dependencies | tr '\t' ' ' | tr -s ' '`
elif [ x$main_proj != x ] && [ -e $main_proj/$main_proj/Dependencies ]; then
    deps=`cat $main_proj/$main_proj/Dependencies | tr '\t' ' ' | tr -s ' '`
else
    echo "Can't find dependencies file...exiting"
    echo
    exit 3
fi

# Add main project to list (if one is specified)
if [ x$main_proj != x ]; then
    deps+=$'\n'
    if [ $VCS = "git" ]; then
        deps+="$main_proj_dir $main_proj_url $main_proj_version"
    else
        deps+="$main_proj_dir $main_proj_url"
    fi
fi

if [ build = "true" ]; then
    rm -f $build_dir/coin_subdirs.txt
fi

# Go through each project in order and fetch, build, install (as instructed
for entry in $deps
do
    dir=`echo $entry | tr '\t' ' ' | tr -s ' '| cut -d ' ' -f 1`
    url=`echo $entry | tr '\t' ' ' | tr -s ' '| cut -d ' ' -f 2`
    proj=`echo $url | cut -d '/' -f 5`
    git_project=false
    # Set the URL of the project, the version, and the build dir
    if [ `echo $url | cut -d '/' -f 3` != "projects.coin-or.org" ]; then
        # If this is a URL of something other than a COIN-OR project on
        # SVN, then we assume it's a git project
        version=`echo $entry | tr '\t' ' ' | tr -s ' '| cut -d ' ' -f 3`
        git_project=true
    else
        if [ $proj = "BuildTools" ] &&
               [ `echo $url | cut -d '/' -f 6` = 'ThirdParty' ]; then
            if [ `echo $url | cut -d '/' -f 8` = trunk ]; then
                version=trunk
            else
                version=`echo $url | cut -d '/' -f 8-9`
            fi
        elif [ $proj = "CHiPPS" ]; then
            if [ `echo $url | cut -d '/' -f 7` = trunk ]; then
                version=trunk
            else
                version=`echo $url | cut -d '/' -f 7-8`
            fi
        elif [ $proj = "Data" ]; then
            if [ `echo $url | cut -d '/' -f 7` = trunk ]; then
                version=trunk
            else
                version=`echo $url | cut -d '/' -f 7-8`
            fi
        else
            if [ `echo $url | cut -d '/' -f 6` = trunk ]; then
                version=trunk
            else
                version=`echo $url | cut -d '/' -f 6-7`
            fi
        fi
        
        if [ $VCS = "git" ]; then
            if [ $proj = "BuildTools" ] || [ $proj = "Data" ]; then
                url="https://github.com/coin-or-tools/"
            else
                url="https://github.com/coin-or/"
            fi
            # Convert SVN URL to a Github one and check out with git
            svn_repo=`echo $url | cut -d '/' -f 5`
            if [ `echo $dir | cut -d "/" -f 1` = "ThirdParty" ]; then
                url+=`echo $dir | sed s"|/|-|"`
            elif [ $proj = "Data" ]; then
                url+=`echo $dir | sed s"|/|-|"`
            elif [ $proj = "CHiPPS" ]; then
                url+="CHiPPS-"$dir
            else
                url+=$proj
            fi
        fi
    fi

    # Get the source (if requested)
    if [ $fetch = "true" ]; then
        if get_project $dir; then
            if [ x$main_proj_dir = x ]; then
                if [ $git_project = "true" ]; then
                    fetch_proj git
                else
                    fetch_proj $VCS
                fi
            elif [ $dir != $main_proj_dir ]; then
                if [ $git_project = "true" ]; then
                    fetch_proj git
                else
                    fetch_proj $VCS
                fi
            fi
        else
            echo "Skipping $proj..."
        fi
    fi
    
    # Build the project (if requested)
    if [ $build = "true" ] && [ $dir != "BuildTools" ] && [ -d $dir ]; then
        build_proj $build_dir
    fi
    
    # Install the project (if requested)
    if [ $install = "true" ] &&
           [ $dir != "BuildTools" ] && get_project $dir; then
        install_proj $prefix
    fi
    
done
unset IFS

