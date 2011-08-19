#!/bin/bash


MY_RUBY_VER=ruby-1.9.2-p290
MY_GEM_VER=1.8.7

# Install zlib (required for some ruby gems)
sudo apt-get install -y --force-yes zlib1g-dev
sudo apt-get install -y libxslt-dev libxml2-dev libsqlite3-dev openssl libssl-dev


# Install rvm
curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer ; chmod +x rvm-installer ; rvm_bin_path=~/.rvm/bin rvm_man_path=~/.rvm/share/man ./rvm-installer ; rm rvm-installer
source "$HOME/.rvm/scripts/rvm"
rvm reload


# Install ruby
rvm pkg install zlib
rvm pkg install openssl
rvm install ${MY_RUBY_VER} --with-openssl-dir=$HOME/.rvm/usr
rvm use ${MY_RUBY_VER} --default
ruby --version


# gem update --system doesn't work on Ubuntu, so manually get a more up-to-date version
wget http://production.cf.rubygems.org/rubygems/rubygems-${MY_GEM_VER}.tgz
tar zxf rubygems-${MY_GEM_VER}.tgz
cd rubygems-${MY_GEM_VER}
ruby setup.rb --no-format-executable
cd ..
rm -r rubygems-${MY_GEM_VER} rubygems-${MY_GEM_VER}.tgz
source "$HOME/.rvm/scripts/rvm"
rvm reload


# Install gems in global set
# Haven't tried yet; could replace next two lines: rvm --create --default use ${MY_RUBY_VER}@global
rvm gemset create global
rvm use ${MY_RUBY_VER}@global --default
gem install rake bundler chef --no-rdoc --no-ri


# Set default gemset
echo "rvm 1.9.2@global" > ~/dev/.rvmrc


# Fix rails console
sudo apt-get install -y libreadline5-dev libncurses5-dev
cd ~/.rvm/src/${MY_RUBY_VER}/ext/readline
ruby extconf.rb
make
make install

# Run autotest gem
sudo apt-get install -y libnotify-bin
gem install autotest-notification
an-install

