#!/bin/bash


MY_RUBY_VER=ruby-1.9.3-p194


# Install zlib (required for some ruby gems)
sudo apt-get install -y --force-yes zlib1g-dev
sudo apt-get install -y libxslt-dev libxml2-dev libsqlite3-dev openssl libssl-dev


# Install rvm
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
source "$HOME/.rvm/scripts/rvm"
rvm reload


# Install ruby
rvm pkg install zlib
rvm pkg install openssl
rvm install ${MY_RUBY_VER} --with-openssl-dir=$HOME/.rvm/usr
rvm use ${MY_RUBY_VER} --default
ruby --version


# Update gems
gem update --system
rvm reload


# Install gems in global set
mkdir -p ~/dev
pushd ~/dev
rvm use --create --rvmrc --default ${MY_RUBY_VER}@global
gem install rake bundler pry --no-rdoc --no-ri
popd


# Fix rails console
sudo apt-get install -y libreadline-dev libncurses-dev
pushd ~/.rvm/src/${MY_RUBY_VER}/ext/readline
ruby extconf.rb
make
make install
popd

# Run autotest gem - now using Guard instead
#sudo apt-get install -y libnotify-bin
#gem install autotest-notification
#an-install

