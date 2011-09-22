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
  ssh-keygen -N '' -t rsa -f ~/.ssh/id_rsa

  # Ubuntu workaround to fix these problems:
  # github Permission denied (publickey).
  # Agent admitted failure to sign using the key.
  ssh-add ~/.ssh/id_rsa
fi


# Update and upgrade
sudo apt-get update -y
sudo apt-get upgrade -y

# Install useful stuff
sudo apt-get install -y git-core      # git
sudo apt-get install -y meld          # meld diff tool
sudo apt-get install -y zsh           # z shell
sudo apt-get install -y devilspie     # window organizer
sudo apt-get install -y sqlitebrowser # sqlite database browser GUI

# Add/update firefox
sudo add-apt-repository ppa:mozillateam/firefox-stable
sudo apt-get install firefox-locale-en


# get linux setup
if [ ! -d "$HOME/dev/linux-setup" ]
then
  mkdir -p ~/dev
  git clone git://github.com/webcoyote/linux-setup.git ~/dev/linux-setup
fi


# copy home directory - includes gemrc, rvmrc, zshrc, bin/, devilspie/
cp -R ~/dev/linux-setup/home/. ~/


# Install sublime text 2
sudo ~/bin/sublime-update.sh 2111


# Use zsh
if [ ! -d "$HOME/.oh-my-zsh" ]
then
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  chsh -s `which zsh`
fi

# Install rvm + ruby
~/bin/install-rvm-ruby.sh
