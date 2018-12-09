#!/bin/env bash

shopt -s expand_aliases
cd /home/$USER

# get rid of cdrom sources in sources.list
sudo sed -Ei 's/(deb cdrom.+)/# \1/g' /etc/apt/sources.list

# set up git
sudo apt install git
ssh-keygen
printf "Please copy the ssh public key to GitHub or the rest of the script will break :)"; read

# prepare scripts dir
mkdir -p /home/$USER/Code/misc/
git clone git@github.com:super-cooper/scripts.git /home/$USER/Code/misc/scripts/
cd /home/$USER/Code/misc/scripts
git submodule init
git submodule update
cd

# sync dotfiles
alias dtf='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dtf init
dtf remote add origin git@github.com:super-cooper/my-dotfiles.git
dtf fetch
dtf checkout -ft origin/master
dtf submodule init
dtf submodule update

# prepare apt
sudo apt install wget curl
sudo apt install python-gi
sudo cp .root-config/sources.list /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo bash -c "echo 'deb http://apt.insynchq.com/debian buster non-free contrib' > /etc/apt/sources.list.d/insync.list"


# install packages
sudo apt update
sudo apt upgrade

xargs -a <(awk '! /^ *(#|$)/' "/home/$USER/Code/misc/scripts/setup/packages.txt") -r -- sudo apt-get install

wget -nv -i /home/$USER/Code/misc/scripts/setup/external-packages.txt -P /home/$USER/Downloads
wget -nv -O /home/$USER/Downloads/mailspring.deb "https://updates.getmailspring.com/download?platform=linuxDeb" 
git clone git@github.com:muflone/gnome-appfolders-manager.git /home/$USER/Downloads/gnome-appfolders-manager
python2 /home/$USER/Downloads/gnome-appfolders-manager/setup.py install

sudo dpkg -i /home/$USER/Downloads/*.deb


# theme setup
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-filezilla-themes/master/install.sh | sh
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh


# link root to config
sudo ln -sf /home/adam/.vimrc /root/.vimrc
sudo ln -sf /home/adam/.vim /root/.vim
sudo ln -sf /home/adam/.bashrc /root/.bashrc
sudo ln -sf /home/adam/.zshrc /root/.zshrc

# open browser to things not yet installed
firefox opera.com/computer/linux slack.com/downloads/linux
