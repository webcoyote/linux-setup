#!/usr/bin/env bash
# by Patrick Wyatt
# Create a rails project
set -o errexit  # crash on error


PROJECT=$1
if [ -z "$PROJECT" ]
then
    echo "Usage: $0 PROJECT-NAME"
    exit
fi

if [ -d "$PROJECT" ]
then
    echo "A project directory named '$PROJECT' already exists in `pwd`"
    exit
fi


# make project directory and include this script in the documentation
mkdir -p "$HOME/dev/$PROJECT/doc/"
cp "$0"  "$HOME/dev/$PROJECT/doc/"
cd "$HOME/dev/$PROJECT"


# prep for source control
git init
git add .
git commit -m "initial commit"


# create rvm gemset
source "$HOME/.rvm/scripts/rvm"
rvm use --create --rvmrc "1.9.2@$PROJECT"


# this takes a while...
echo installing rails
gem install rails


# Create project
rails new "../$PROJECT"
git add .
git commit -m "initial rails project"


# success!
echo "Created project '$PROJECT'"
