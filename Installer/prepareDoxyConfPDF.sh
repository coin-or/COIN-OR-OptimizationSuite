#!/bin/bash 
if [ -z "$1" ] 
then
   echo enter doxygen configuration file \(usually doxygen.conf\)
   exit
fi

pName=`cat $1 | grep -i PROJECT_NAME | grep "=" | cut -d "=" -f 2`

if [ -z $pName ]
then
   echo this file does not appears to be a doxygen configuration file
   exit 
fi

echo doxygen configuration for project $pName

cat $1 | sed -e 's/EXTRACT_PRIVATE        = YES/EXTRACT_PRIVATE        = NO/g' |\
         sed -e 's/GENERATE_LATEX         = NO/GENERATE_LATEX         = YES/g' |\
         sed -e 's/EXTRACT_ALL            = YES/EXTRACT_ALL            = NO/g' |\
         sed -e 's/HIDE_UNDOC_MEMBERS     = NO/HIDE_UNDOC_MEMBERS     = YES/g' |\
         sed -e 's/SHOW_DIRECTORIES       = YES/SHOW_DIRECTORIES       = NO/g' |\
         sed -e 's/PAPER_TYPE             = letter/PAPER_TYPE             = A4/g' |\
         sed -e 's/HAVE_DOT               = NO/HAVE_DOT               = YES/g' |\
         sed -e 's/FULL_PATH_NAMES        = YES/FULL_PATH_NAMES        = NO/g' |\
         sed -e 's/GENERATE_TODOLIST      = YES/GENERATE_TODOLIST      = NO/g' \
       > doxygen.conf.new

echo new configuration saved in doxygen.conf.new




