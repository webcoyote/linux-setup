#!/bin/bash
# By Patrick Wyatt 8/10/2011
# to execute: bash < <(curl -s https://raw.github.com/gist/12417bd6bd3fc1e07b31)


# Make sure this script is not run with sudo
if [ $(id -u) -eq 0 ]
then
echo 'ERROR: This script should not be run as sudo or root.'
  exit
fi


# Generate SSH key if it doesn't exist
if [ ! -r "$HOME/.ssh/id_rsa" ]
then
  ssh-keygen -t rsa

  # Ubuntu workaround to fix these problems:
  # github Permission denied (publickey).
  # Agent admitted failure to sign using the key.
  ssh-add ~/.ssh/id_rsa
fi


# Install git
sudo apt-get update -y -qq
sudo apt-get install -y -qq git-core


# get linux setup
mkdir -p ~/dev
cd ~/dev
git clone git://github.com/webcoyote/linux-setup.git


# copy home directory
cp linux-setup/home/rvmrc ~/.rvmrc
cp linux-setup/home/gemrc ~/.gemrc


# copy bin directory
mkdir -p ~/bin
cp linux-setup/bin/* ~/bin


# Install sublime text 2
sudo ~/bin/sublime-update.sh 2095


# Install meld
sudo apt-get install -y meld


# Install zsh
sudo apt-get install -y zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp linux-setup/zsh/zshrc ~/.zshrc
cp linux-setup/zsh/zsh-theme ~/bin
chsh -s `which zsh`


# Install rvm + ruby
~/bin/install-rvm-ruby.sh


