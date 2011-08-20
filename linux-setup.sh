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


# Install useful stuff
sudo apt-get update -y -qq
sudo apt-get install -y -qq git-core
sudo apt-get install -y meld
sudo apt-get install -y zsh
sudo apt-get install -y devilspie
#sudo apt-get install -y wmctrl


# get linux setup
if [ ! -d "$HOME/dev/linux-setup" ]
then
  mkdir -p ~/dev
  git clone git://github.com/webcoyote/linux-setup.git ~/dev/linux-setup
fi


# copy home directory - includes gemrc, rvmrc, zshrc, autotest, bin/, devilspie/
cp -R ~/dev/linux-setup/home/ ~


# Install sublime text 2
sudo ~/bin/sublime-update.sh 2095


# Use zsh
if [ ! -d "$HOME/.oh-my-zsh" ]
then
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  chsh -s `which zsh`
fi

# Install rvm + ruby
~/bin/install-rvm-ruby.sh
