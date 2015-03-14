#!/bin/bash

hasPath=`set | grep -i COINORPATH`

# exiting if variable already in path
if [ -n "$hasPath" ]
then
    exit
fi

echo "export COINORPATH=\"$1\"" >> ~/.profile
echo "export PATH=\${COINORPATH}/bin/:\${PATH}" >> ~/.profile
echo "export C_INCLUDE_PATH=\${COINORPATH}/include:\$C_INCLUDE_PATH" >> ~/.profile
echo "export CPLUS_INCLUDE_PATH=\${COINORPATH}/include:\$CPLUS_INCLUDE_PATH" >> ~/.profile
echo "export LIBRARY_PATH=\${COINORPATH}/lib:\$LIBRARY_PATH" >> ~/.profile

echo "export COINORPATH=\"$1\"" >> ~/.bashrc
echo "export PATH=\${COINORPATH}/bin/:\${PATH}" >> ~/.bashrc
echo "export C_INCLUDE_PATH=\${COINORPATH}/include:\$C_INCLUDE_PATH" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=\${COINORPATH}/include:\$CPLUS_INCLUDE_PATH" >> ~/.bashrc
echo "export LIBRARY_PATH=\${COINORPATH}/lib:\$LIBRARY_PATH" >> ~/.bashrc

