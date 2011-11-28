#!/usr/bin/env bash
# By Patrick Wyatt 8/10/2011
# to execute: 
#   bash < <(curl -s https://raw.github.com/webcoyote/linux-setup/master/mac-setup.sh)


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


# Install homebrew, wget, git (latest)
/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
brew install wget
brew install git
alias git=/usr/local/bin/git


# get linux setup
if [ ! -d "$HOME/dev/linux-setup" ]
then
  mkdir -p ~/dev
  git clone git://github.com/webcoyote/linux-setup.git ~/dev/linux-setup
fi


# link home directory - includes .gemrc .rvmrc .zshrc bin/* .devilspie/*
function link_homedir_files () {
  for file in $1/?*; do
    if [[ -d $file ]]; then 
      mkdir -p $2/`basename $file`
      link_homedir_files $file $2/`basename $file`
    else
      ln -f $file $2/`basename $file`
    fi
  done
}
link_homedir_files ~/dev/linux-setup/home ~


# Use zsh
if [ ! -d "$HOME/.oh-my-zsh" ]
then
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  chsh -s `which zsh`
fi


# Install rvm + ruby
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
rvm install 1.9.3
rvm use ruby-1.9.3 --default

