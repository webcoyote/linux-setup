#!/bin/bash


MY_RUBY_VER=ruby-1.9.2-p290
MY_GEM_VER=1.8.10


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


# Gem update seems to be working now...
# gem update --system doesn't work on Ubuntu, so manually get a more up-to-date version
#wget http://production.cf.rubygems.org/rubygems/rubygems-${MY_GEM_VER}.tgz
#tar zxf rubygems-${MY_GEM_VER}.tgz
#cd rubygems-${MY_GEM_VER}
#ruby setup.rb --no-format-executable
#cd ..
#rm -r rubygems-${MY_GEM_VER} rubygems-${MY_GEM_VER}.tgz
#source "$HOME/.rvm/scripts/rvm"
gem update --system
rvm reload


# Install gems in global set
mkdir -p ~/dev
pushd ~/dev
rvm use --create --rvmrc --default ${MY_RUBY_VER}@global
gem install rake bundler --no-rdoc --no-ri
popd


# Fix rails console
sudo apt-get install -y libreadline5-dev libncurses5-dev
pushd ~/.rvm/src/${MY_RUBY_VER}/ext/readline
ruby extconf.rb
make
make install
popd

# Run autotest gem - now using Guard instead
#sudo apt-get install -y libnotify-bin
#gem install autotest-notification
#an-install

