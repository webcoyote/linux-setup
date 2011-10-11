#!/bin/bash
# graphite-install.sh
# by Patrick Wyatt - https://github.com/webcoyote - 10/10/2011
set -o errexit  # crash on error


# Which version to install
GRAPHITE_VERSION=0.9.9


# Make sure this script is not run with sudo
if [ $(id -u) -eq 0 ]
then
  echo 'ERROR: This script should not be run as sudo or root.'
  exit
fi


# Create download directory in the current directory
DOWNLOAD_DIR=/tmp/graphite/download
mkdir -p $DOWNLOAD_DIR
pushd $DOWNLOAD_DIR 1>/dev/null


# Download required files
function download_file () {
	URL=$1
	DIR=$2
	FILE=$3
	if [ ! -f "$DIR/$FILE" ]; then
		wget -nv -P $DIR --accept "$FILE" "$URL/$FILE"
	fi
}
URL=http://launchpad.net/graphite/${GRAPHITE_VERSION:0:3}/$GRAPHITE_VERSION/+download

echo '*** Downloading files'
download_file $URL $DOWNLOAD_DIR whisper-$GRAPHITE_VERSION.tar.gz
download_file $URL $DOWNLOAD_DIR carbon-$GRAPHITE_VERSION.tar.gz
download_file $URL $DOWNLOAD_DIR graphite-web-$GRAPHITE_VERSION.tar.gz


# First we install whisper, as both Carbon and Graphite require it
echo '*** Install whisper'
tar zxf whisper-$GRAPHITE_VERSION.tar.gz 1>/dev/null
cd whisper-$GRAPHITE_VERSION/
sudo python setup.py install 1>/dev/null
cd ..


# Now we install carbon
echo '*** Install carbon'
tar zxf carbon-$GRAPHITE_VERSION.tar.gz 1>/dev/null
cd carbon-$GRAPHITE_VERSION/
sudo python setup.py install 1>/dev/null
cd ..


# Finally, the graphite webapp
echo '*** Install graphite'
tar zxf graphite-web-$GRAPHITE_VERSION.tar.gz 1>/dev/null
cd graphite-web-$GRAPHITE_VERSION/
./check-dependencies.py 1>/dev/null


# once all dependencies are met...
sudo python setup.py install
cd ..


# Cleanup
#sudo rm -rf /tmp/graphite/download
popd 1>/dev/null
exit 0
