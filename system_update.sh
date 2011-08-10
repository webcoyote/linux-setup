#!/bin/bash

# Get values from configuration script that should not be stored in git
	source personal.sh

# Generate SSH key (once)
	if [ ! -r "$HOME/.ssh/id_rsa" ]
	then
		ssh-keygen -t rsa -C "$MY_EMAIL@$MY_DOMAIN on $HOSTNAME"
	fi

# Copy tools to bin
	mkdir -p ~/bin
	if [ -d "./bin/" ]
	then
		cp ./bin/* ~/bin/
	fi

# Install basic libraries
	sudo apt-get update
	sudo apt-get install -y curl git-core
	git config --global core.editor gedit
	git config --global user.name "$MY_NAME"
	git config --global user.email $MY_EMAIL@$MY_DOMAIN
	git config --global github.user $MY_GIT_USERNAME
	git config --global github.token $MY_GIT_TOKEN

# Install Sublime Text 2
	sudo ~/bin/sublime-update.sh $MY_SUBLIME_BUILD

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
	gem install rake bundler chef

