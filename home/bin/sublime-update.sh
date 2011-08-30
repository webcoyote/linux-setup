#!/bin/sh
# From https://gist.github.com/894200
# By https://gist.github.com/Anomareh
# Edited by PatW to work on my Ubuntu

file="Sublime Text 2 Build ${1} x64.tar.bz2"
# Uncomment line below for 32 bit.
#file="Sublime Text 2 Build ${1}.tar.bz2"
url="http://www.sublimetext.com/${file}"
first=0
echo 'Sublime Text 2 editor update'

if [ $(id -u) -ne 0 ]
then
    echo 'ERROR: You need to run this script with sudo or as root.'
    exit
fi

if [ -z $1 ]
then
    echo 'ERROR: Invalid command. Type "sublime-update.sh help" for a list of commands.'
    exit
fi

echo $1 | grep -q "^[0-9]*$"

if [ $? -ne 0 ] && [ $1 != 'remove' ] && [ $1 != 'clean' ] && [ $1 != 'help' ]
then
    echo 'ERROR: Invalid command. Type "sublime-update.sh help" for a list of commands.'
    exit
fi

if [ $1 = 'remove' ]
then
    if [ ! -d /opt/subl ]
    then
        echo 'There is nothing to remove.'
    else
        rm -Rf /opt/subl/
        rm /usr/local/bin/subl
        echo 'Sublime successfully removed.'
    fi

    exit
elif [ $1 = 'clean' ]
then
    echo 'Removing archives...'
    
    rm -Rf /opt/subl/src/
    mkdir /opt/subl/src/
    
    echo 'Archives successfully removed.'
    
    exit
elif [ $1 = 'help' ]
then
    echo 'List of commands:\n  <ver#> - Update to version. Example -> sublime-update.sh 2095\n  clean  - Removes all downloaded archives.\n  remove - Removes Sublime completely.\n  help   - This output.'
    exit
else
    echo 'Starting update...'
fi

if [ ! -d /opt/subl ]
then
    mkdir -p /opt/subl/src/
    first=1
fi

if [ ! -f "/opt/subl/src/${file}" ]
then
    echo 'Downloading...'
    wget -P /opt/subl/src/ --accept "${file}" -q "${url}"
else
    echo 'File already downloaded.'
fi

if [ $? -ne 0 ]
then
    echo 'ERROR: Version not found.'
    exit
fi

if [ $first -eq 1 ]
then
    mkdir /opt/subl/pkg/
else
    rm -Rf /opt/subl/pkg/
    mkdir /opt/subl/pkg/
fi

echo 'Extracting...'

tar --strip-components=1 -C '/opt/subl/pkg/' -xjf "/opt/subl/src/${file}"

if [ ! -e /usr/local/bin/subl ]
then
    echo 'Installing binary at /usr/local/bin/subl...'
    ln -s /opt/subl/pkg/sublime_text /usr/local/bin/subl
fi

echo "Update to version ${1} successful!"

