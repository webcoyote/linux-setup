Linux setup scripts for Ubuntu
=================================

These are my setup scripts to build a Linux box quickly


Installation
=====================

	# Configure computer
	sudo apt-get install -qq -y curl
	bash < <(curl -s https://raw.github.com/gist/12417bd6bd3fc1e07b31)

	# Install zsh
	sudo apt-get install -y zsh
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cp ~/bin/webcoyote-zshrc ~/.zshrc
	chsh -s `which zsh`

	# Install sublime text 2
	sudo ~/bin/sublime-update.sh 2095

	# Install rvm + ruby
	~/bin/install-rvm-ruby.sh

Comments
========

This is my first github project; if you have any comments I'd love to hear them!
