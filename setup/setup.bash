#!/bin/bash

shopt -s expand_aliases
cd /home/$USER

# get rid of cdrom sources in sources.list
sudo sed -Ei 's/(deb cdrom.+)/# \1/g' /etc/apt/sources.list
sudo bash -c 'echo "deb http://ftp.us.debian.org/debian/ buster main" >> /etc/apt/sources.list'
sudo bash -c 'echo "deb-src http://ftp.us.debian.org/debian/ buster main" >> /etc/apt/sources.list'
sudo bash -c 'echo "deb http://ftp.us.debian.org/debian/ stretch main" >> /etc/apt/sources.list'
sudo bash -c 'echo "deb-src http://ftp.us.debian.org/debian/ stretch main" >> /etc/apt/sources.list'
sudo apt update

# set up git
sudo apt install git
ssh-keygen
printf "Please copy the ssh public key to GitHub or the rest of the script will break :)"; read

# prepare scripts dir
echo "Downloading scripts..."
mkdir -p /home/$USER/Code/misc/
git clone git@github.com:super-cooper/scripts.git /home/$USER/Code/misc/scripts/
cd /home/$USER/Code/misc/scripts
git submodule init
git submodule update
cd

# sync dotfiles
echo "Downloading dotfiles..."
alias dtf='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dtf init
dtf remote add origin git@github.com:super-cooper/my-dotfiles.git
dtf fetch
dtf checkout -ft origin/master
dtf submodule init
dtf submodule update

# prepare apt
echo "Setting up apt for main package installs..."
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
echo "Initial package upgrades..."
sudo apt update
sudo apt upgrade

echo "Installing packages..."
xargs -a <(awk '! /^ *(#|$)/' "/home/$USER/Code/misc/scripts/setup/packages.txt") -r -- sudo apt install
wget -nv -i /home/$USER/Code/misc/scripts/setup/external-packages.txt -P /home/$USER/Downloads
wget -nv -O /home/$USER/Downloads/mailspring.deb "https://updates.getmailspring.com/download?platform=linuxDeb" 
wget -nv -O /home/$USER/Downloads/nordvpn.deb "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb"
wget -nv -O /home/$USER/Downloads/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
git clone git@github.com:muflone/gnome-appfolders-manager.git /home/$USER/Downloads/gnome-appfolders-manager
cd /home/$USER/Downloads/gnome-appfolders-manager
sudo python2 setup.py install
cd

sudo dpkg -i /home/$USER/Downloads/*.deb

sudo pip3 install thefuck argcomplete wakatime

# go binaries
echo "Installing golang packages..."
go get -u github.com/edi9999/path-extractor/path-extractor github.com/zricethezav/gitleaks github.com/michenriksen/gitrob
mkdir -p /home/$USER/.gopath/src/github.com/github
git clone --config transfer.fsckobjects=false --config receive.fsckobjects=false --config fetch.fsckobjects=false https://github.com/github/hub.git /home/$USER/.gopath/src/github.com/github/hub
cd /home/$USER/.gopath/src/github.com/github/hub
sudo make install prefix=/usr/local
cd

# Set up fzf
echo "Setting up fzf..."
cd ~/.fzf
./install
cd

# NordVPN bullshit
echo "Setting up NordVPN..."
sudo apt update
sudo apt install nordvpn
echo "Now attempting to log into NordVPN"
nordvpn connect

# Set up cloudflare DNS
echo "Setting DNS server to CloudFlare..."
sudo cp /etc/resolv.conf /tmp/resolv.conf
sudo bash -c 'printf "nameserver 127.0.0.1\nnameserver 1.1.1.1\nnameserver 1.1.0.1\n" > /etc/resolv.conf'
sudo bash -c 'cat /tmp/resolv.conf >> /etc/resolv.conf'

# theme setup
echo "Setting up theme..."
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-filezilla-themes/master/install.sh | sh
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

# link root to config
echo "Linking root to user config..."
sudo ln -sf /home/adam/.vimrc /root/.vimrc
sudo ln -sf /home/adam/.vim /root/.vim
sudo ln -sf /home/adam/.bashrc /root/.bashrc
sudo ln -sf /home/adam/.zshrc /root/.zshrc

# Install GNOME extensions
echo "Installing GNOME shell extensions..."
alias gsei="/home/adam/Code/misc/scripts/gnome-shell-extension-installer --yes"
gsei 16    # Auto move windows
gsei 97    # Coverflow alt-tab
gsei 1160  # Dash to Panel
gsei 959   # Disable Workspace Switcher Popup
gsei 600   # Launch new instance
gsei 18    # Native Window Placement
gsei 118   # No Topleft Hot Corner
gsei 708   # Panel OSD
gsei 1031  # TopIcons Plus
gsei 19    # User Themes
gsei 484   # Workspace Grid
gsei 10    # windowNavigator

# Install adapta theme
echo "Installing adapta GTK theme..."
cd /home/$USER/Downloads
git config git@github.com:adapta-project/adapta-gtk-theme.git
cd adapta-gtk-theme
./autogen.sh --prefix=/usr --enable-parallel --enable-gtk_next  # TODO read in colors from file and use --with_ options
make
sudo make install
# Discord theme
bash <(wget -qO- https://gitlab.com/Scrumplex/Discord-Adapta-Nokto/raw/master/scripts/linux/dc-patcher)

# Set shell to zsh
echo "Setting shell to zsh..."
chsh -s /bin/zsh

# open browser to things not yet installed
firefox opera.com/computer/linux slack.com/downloads/linux https://www.anaconda.com/download/#linux 
