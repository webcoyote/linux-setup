#!/usr/bin/env bash
# By Patrick Wyatt 8/10/2011
# to execute: bash < <(curl -s https://raw.github.com/gist/12417bd6bd3fc1e07b31)


# Make sure this script is not run with sudo
if [ $(id -u) -eq 0 ]
then
  echo 'ERROR: This script should not be run as sudo or root.'
  exit
fi


pushd /tmp
git clone git://git.gnome.org/glib
cd glib
git checkout 2.26.1
./autogen.sh --prefix=/opt/lib/glib2.26
make
sudo make install