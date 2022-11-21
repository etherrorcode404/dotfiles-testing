#!/bin/bash

##########################################
## Script Dependencies: grep, sudo, cat ##
##########################################

if [ "$(id -u)" = 0 ]; then
    echo "##################################################################"
    echo "This script MUST NOT be run as root user since it makes changes"
    echo "to the \$HOME directory of the \$USER executing this script."
    echo "The \$HOME directory of the root user is, of course, '/root'."
    echo "We don't want to mess around in there. So run this script as a"
    echo "normal user. You will be asked for a sudo password when necessary."
    echo "##################################################################"
    exit 1
fi

error() { \
    clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

echo "#####################################################################"
echo "## Updating and installing 'Script Dependencies' if not installed  ##"
echo "#####################################################################"
sudo cp -r $(pwd)/sources.list /etc/apt/
sudo apt-get update && sudo apt-get dist-upgrade -qq -f -y
sudo apt-get install -qq -f -y dialog grep wget

echo "#####################################"
echo "## Adding 'non-free' and 'contrib' ##"
echo "#####################################"
sleep 2s
sudo apt-get install -qq -f -y software-properties-common
sudo apt-add-repository contrib && sudo apt-add-repository non-free
sudo apt-get update && sudo apt-get dist-upgrade -qq -f -y

echo "########################"
echo "## Adding 'nala' repo ##"
echo "########################"
echo "deb https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
echo "deb-src https://deb.volian.org/volian/ scar main" | sudo tee -a /etc/apt/sources.list.d/volian-archive-scar-unstable.list
sudo apt-get update && sudo apt-get install -qq -f -y nala-legacy

echo "######################"
echo "## Updating Mirrors ##"
echo "######################"
sudo nala fetch
echo installing the pre-requisites..
sleep 2s
egrep -v "^$|^[[:space:]]*#" $(pwd)/pkglist > pkginstall
sudo nala install $(cat pkginstall)

echo "##################################"
echo "## Building and adding Programs ##"
echo "##################################"
sleep 2s
echo "## Fira Code Nerd Font ##"
sudo mkdir -p /usr/share/fonts/nerd-fonts
sudo wget -O /usr/share/fonts/nerd-fonts/Fira\ Code\ Regular\ Nerd\ Font\ Complete.ttf "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"

echo "## Gruvbox Material GTK ##"
sleep 2s
git clone https://github.com/etherrorcode404/gruvbox-material-gtk.git
sudo mv $(pwd)/gruvbox-material-gtk/icons/Gruvbox-Material-Dark /usr/share/icons/
sudo mv $(pwd)/gruvbox-material-gtk/themes/Gruvbox-Material-Dark /usr/share/themes/

echo "## Dunst ##"
sleep 2s
git clone https://github.com/dunst-project/dunst.git
cd dunst
sudo make WAYLAND=0 install

echo "## Alacritty ##"
sleep 2s
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup override set stable
rustup update stable
cargo install alacritty
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/linux/Alacritty.desktop
sudo mkdir -p /usr/local/share/applications/
sudo mv Alacritty.desktop /usr/local/share/applications/
sudo chmod +X /usr/local/share/applications/Alacritty.desktop
sudo chmod 775 /usr/local/share/applications/Alacritty.desktop

echo "## Xmonad ##"
sleep 2s
cd ~/.config/xmonad
sudo apt-get autoremove -qq -y xmoand
git clone https://github.com/xmonad/xmonad
git clone https://github.com/xmonad/xmonad-contrib
stack upgrade
stack init
stack install
sudo ln -s ~/.local/bin/xmonad /usr/bin
sudo wget -O /usr/share/xsessions/xmonad.desktop "https://githubusercontent.com/etherrorcode404/main/xmonad.dekstop"
sudo chmod +x /usr/share/xsessions/xmonad.desktop
sudo chmod 775 /usr/share/xsessions/xmonad.desktop
cd $HOME

echo "## Spotify & adblock ##"
sleep 2s
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo nala update && sudo nala install spotify-client
sudo rm -rf /usr/local/share/applications/spotify.desktop
git clone https://github.com/abba23/spotify-adblock.git
cd spotify-adblock
make
sudo make install
cd $HOME
mkdir -p ~/.local/share/applications
sudo wget -O ~/.local/share/applications/spotify.desktop "https://raw.githubusercontent.com/etherrorcode404/dotfiles/master/spotify.desktop"
sudo chmod +x ~/.local/share/applications/spotify.desktop
sudo chmod 775 ~/.local/share/applications/spotify.desktop

echo "## Brave Browser ##"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt-get update && sudo apt-get install -qq -f -y brave-browser

echo "## Git-Hub Desktop ##"
wget -qO - https://mirror.mwt.me/ghd/gpgkey | sudo tee /etc/apt/trusted.gpg.d/shiftkey-desktop.asc > /dev/null
sudo sh -c 'echo "deb [arch=amd64] https://mirror.mwt.me/ghd/deb/ any main" > /etc/apt/sources.list.d/packagecloud-shiftkey-desktop.list'
sudo apt-get update && sudo apt-get install -qq -f -y github-desktop

echo "## Neovim ##"
sudo apt-get autoremove -qq -y neovim
sudo apt-get autoremove -qq -y neovim-runtime
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.deb
sudo apt-get install -qq -f -y ./neovim-linux64.deb

echo "## Zoom ##"
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt-get install -qq -f -y ./zoom_amd64.deb

echo "## Discord ##"
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo apt-get install -qq -f -y ./discord.deb

echo "## Shell ##"
echo "symlink in /bin/sh:"
readlink /bin/sh
echo "symlink in /usr/bin/sh:"
readlik /usr/bin/sh

echo "## Clean UP ##"
sleep 2s
rm -rf GithubDesktop-linux-3.0.3-linux1.deb zoom_amd64.deb discord.deb
rm -rf gruvbox-material-gtk spotify-adblock
xrandr --output HDMI-A-0 --mode 1920x1080 --rate 75.00
sudo apt-get autopurge
sudo apt-get update && sudo apt-get dist-upgrade
