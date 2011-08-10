#!/bin/bash


MY_RUBY_VER=ruby-1.9.2-p290
MY_GEM_VER=1.8.7


# Install rvm
curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer ; chmod +x rvm-installer ; rvm_bin_path=~/.rvm/bin rvm_man_path=~/.rvm/share/man ./rvm-installer ; rm rvm-installer
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bashrc
source ~/.bashrc


# Install ruby (which requires zlib)
sudo apt-get install -y --force-yes zlib1g-dev
rvm pkg install zlib
rvm install ${MY_RUBY_VER}
rvm use ${MY_RUBY_VER} --default


# gem update --system doesn't work on Ubuntu, so manually get a more up-to-date version
wget http://production.cf.rubygems.org/rubygems/rubygems-${MY_GEM_VER}.tgz
tar zxf rubygems-${MY_GEM_VER}.tgz
cd rubygems-${MY_GEM_VER}
ruby setup.rb --no-format-executable
cd ..
rm -r rubygems-${MY_GEM_VER} rubygems-${MY_GEM_VER}.tgz


# Install gems in global set
rvm gemset create global
rvm use ${MY_RUBY_VER}@global --default
gem install rake bundler chef --no-rdoc --no-ri
