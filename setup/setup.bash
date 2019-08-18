#!bin/bash

shopt -s expand_aliases
cd $HOME

testing=testing
stable=stable

# get rid of cdrom sources in sources.list
sudo sed -Ei 's/(deb cdrom.+)/# \1/g' /etc/apt/sources.list
sudo bash -c "echo deb http://ftp.us.debian.org/debian/ $testing main >> /etc/apt/sources.list"
sudo bash -c "echo deb-src http://ftp.us.debian.org/debian/ $testing main >> /etc/apt/sources.list"
sudo bash -c "echo deb http://ftp.us.debian.org/debian/ $stable main >> /etc/apt/sources.list"
sudo bash -c "echo deb-src http://ftp.us.debian.org/debian/ $stable main >> /etc/apt/sources.list"
sudo apt update

# set up git
sudo apt install git
ssh-keygen
printf "Please copy the ssh public key to GitHub or the rest of the script will break :)"; read

# prepare scripts dir
echo "Downloading scripts..."
mkdir -p $HOME/dev/
git clone git@github.com:super-cooper/scripts.git $HOME/dev/scripts/
cd $HOME/dev/scripts
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
wfet -q https://www.virtualbox.org/download/oracle_vboc.asc -O- | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo bash -c "echo 'deb http://apt.insynchq.com/debian buster non-free contrib' > /etc/apt/sources.list.d/insync.list"


# install packages
echo "Initial package upgrades..."
sudo apt update
sudo apt upgrade

echo "Installing packages..."
xargs -a <(awk '! /^ *(#|$)/' "$HOME/dev/scripts/setup/packages.txt") -r -- sudo apt install
wget -nv -i $HOME/dev/scripts/setup/external-packages.txt -P $HOME/Downloads
wget -nv -O $HOME/Downloads/mailspring.deb "https://updates.getmailspring.com/download?platform=linuxDeb" 
wget -nv -O $HOME/Downloads/nordvpn.deb "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb"
wget -nv -O $HOME/Downloads/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"

sudo dpkg -i $HOME/Downloads/*.deb
sudo apt --fix-broken install
sudo apt install $HOME/Downloads/mailspring.deb

# pip3 packages
pip3 install thefuck argcomplete wakatime pipupgrade

# pip packages
sudo pip install future

# gem packages
sudo gem install colorls

# install path picker
cd ~/Downloads/
git clone git@github.com:facebook/PathPicker/
cd PathPicker/debian
./package.sh
sudo dpkg -i ../*.deb

# install nerd fonts
cd ~/Downloads/
git clone git@github.com:ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh
cd

# go binaries
echo "Installing golang packages..."
go get -v -u github.com/edi9999/path-extractor/path-extractor github.com/zricethezav/gitleaks github.com/michenriksen/gitrob github.com/github/hub github.com/wtfutil/wtf google.golang.org/api/calendar/v3 golang.org/x/oauth2/google
mv $HOME/go $HOME/.gopath
sudo ln -s $HOME/.gopath/bin/hub /bin/hub
cd $GOPATH/src/github.com/wtfutil/wtf
go install -v -ldflags="-s -w"
make
mkdir -p ~/.config/google/credentials/wtfutil
cd ~/.config/google/credentials/wtfutil
firefox https://developers.google.com/calendar/quickstart/go
printf "Please download the client secret for gcal to ~/.config/google/credentials/wtfutil/credentials.json :)"; read

# Set up fzf
echo "Setting up fzf..."
cd $HOME/.fzf
./install
cd

# NordVPN bullshit
echo "Setting up NordVPN..."
sudo apt update
sudo apt install nordvpn
echo "Now attempting to log into NordVPN"
nordvpn c US
nordvpn d 

# install stylelint
sudo npm -g install stylelint
sudo npm -g install stylelint-a11y
sudo npm -g install stylelint-csstree-validator
sudo npm -g install stylelint-high-performance-animations
sudo npm -g install stylelint-high-performance-animation
sudo npm -g install stylelint-images

# Set up cloudflare DNS
echo "Setting DNS server to CloudFlare..."
sudo cp /etc/resolv.conf /tmp/resolv.conf
sudo bash -c 'printf "nameserver 127.0.0.1\nnameserver 1.1.1.1\nnameserver 1.1.0.1\n" > /etc/resolv.conf'
sudo bash -c 'cat /tmp/resolv.conf >> /etc/resolv.conf'

# Set up yubikey
echo "Setting up Yubikey..."
sudo wget -O /etc/udev/rules.d/70-u2f.rules https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules
printf "Please plug in the Yubikey :)"; read
mkdir -p $HOME/.config/Yubico/
echo "Touch the Yubikey when it flashes!"
pamu2fcfg > $HOME/.config/Yubico/u2f_keys
sudo sed -i '/@include common-auth/a auth required pam_u2f.so' /etc/pam.d/lightdm

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
gsei="/home/adam/dev/scripts/gnome-shell-extension-installer --yes"
$gsei 16    # Auto move windows
$gsei 97    # Coverflow alt-tab
$gsei 1160  # Dash to Panel
$gsei 959   # Disable Workspace Switcher Popup
$gsei 600   # Launch new instance
$gsei 18    # Native Window Placement
$gsei 118   # No Topleft Hot Corner
$gsei 708   # Panel OSD
$gsei 1031  # TopIcons Plus
$gsei 19    # User Themes
$gsei 484   # Workspace Grid
$gsei 10    # windowNavigator
$gsei 277   # Impatience
$gsei 1217  # Appfolders Management

# Install adapta theme
echo "Installing adapta GTK theme..."
cd $HOME/Downloads
git clone git@github.com:adapta-project/adapta-gtk-theme.git
cd adapta-gtk-theme
./autogen.sh --prefix=/usr --enable-parallel --enable-gtk_next  # TODO read in colors from file and use --with_ options
make
sudo make install
# Discord theme
bash <(wget -qO- https://gitlab.com/Scrumplex/Discord-Adapta-Nokto/raw/master/scripts/linux/dc-patcher)

# Set up terminal config
dconf load /org/terminal/legacy/profiles:/$(/bin/cat /home/adam/.root-config/theme/gnome-terminal/gnome-terminal-material-name.txt | tr -d '\n ')/ < $HOME/.root-config/theme/gnome-terminal/gnome-terminal-material.dconf

# Set shell to zsh
echo "Setting shell to zsh..."
chsh -s /bin/zsh

# open browser to things not yet installed
firefox vivaldi.com/download slack.com/downloads/linux https://www.anaconda.com/download/#linux jetbrains.com
