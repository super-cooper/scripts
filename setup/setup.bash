#!/bin/env bash

# get rid of cdrom sources in sources.list
sudo sed -Ei 's/(deb cdrom.+)/# \1/g' /etc/apt/sources.list

# set up git
sudo apt install git

# prepare scripts dir
mkdir -p ~/Code/misc/
git clone git@github.com:super-cooper/scripts.git ~/Code/misc/scripts/

# sync dotfiles
alias dtf='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dtf clone git@github.com:super-cooper/my-dotfiles.git
mv my-dotfiles .dotfiles

