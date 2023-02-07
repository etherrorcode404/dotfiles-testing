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
    exit 1; fi

error() { \
    clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

echo "#####################################################################"
echo "## Updating and installing 'Script Dependencies' if not installed  ##"
echo "#####################################################################"
sudo apt-get install -qq -f -y dialog grep wget
sudo wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/etherrorcode404/dotfiles/main/sources.list"
sudo chmod +x /etc/apt/sources.list
sudo chmod 775 /etc/apt/sources.list

sudo apt-get update && sudo apt-get dist-upgrade -qq -f -y

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

echo "## Picom ##"
sleep 2s
cd $HOME
git clone https://github.com/jonaburg/picom
cd picom
meson setup --buildtype=release . build
ninja -C build
sudo ninja -C build install

echo "## Alacritty ##"
sleep 2s
cd $HOME
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup override set stable
rustup update stable
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/linux/Alacritty.desktop
sudo mkdir -p /usr/local/share/applications/
sudo mv Alacritty.desktop /usr/local/share/applications/
sudo chmod +X /usr/local/share/applications/Alacritty.desktop
sudo chmod 775 /usr/local/share/applications/Alacritty.desktop
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release --no-default-features --features=x11
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
mkdir -p ~/.bash_completion
cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
mkdir -p $fish_complete_path[1]
cp extra/completions/alacritty.fish $fish_complete_path[1]/alacritty.fish

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
sudo wget -O ~/.local/share/applications/spotify.desktop "https://raw.githubusercontent.com/etherrorcode404/dotfiles/main/spotify.desktop"
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
sleep 2s
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.deb
sudo nala install ./nvim-linux64.deb

echo "## Zoom ##"
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo nala install ./zoom_amd64.deb

echo "## Discord ##"
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo nala install ./discord.deb

echo "## Shell ##"
echo "Installing fish from backports.."
sudo apt-get install -qq -f -y fish/bullseye-backports
echo "symlink in /bin/sh:"
readlink /bin/sh
echo "symlink in /usr/bin/sh:"
readlik /usr/bin/sh
fish -c "nvm install lts"
# fish -c "npm i -g vscode-langservers-extracted"
# fish -c "npm i -g eslint_d"
# fish -c "npm i -g @fsouza/prettierd"
sleep 2s

echo "## Clean UP ##"
sleep 2s
rm -rf GithubDesktop-linux-3.0.3-linux1.deb zoom_amd64.deb discord.deb
rm -rf gruvbox-material-gtk spotify-adblock alacritty picom
sudo apt-get autopurge
sudo apt-get update && sudo apt-get dist-upgrade

echo "## Drivers ##"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[1;31m'

extra=$(lspci -nnk | grep -i -EA3 "3d|display|vga" | tail -n 2)

echo -e "${GREEN} $extra \n"
echo 'Choose video drivers to install you may choose multiple'
echo 'e.g; Driver to install: xserver-xorg-intel xserver-xorg-amdgpu'
echo -e "${BLUE} Some Options: xserver-xorg-video-amdgpu/ati/radeon/intel/nvidia/all \n"
read -p 'Drvier to install: ' pkgs
echo 'Choosen:' $pkgs
sudo nala install $pkgs

# Prompt to install proprietary drivers
if [ $pkgs == "xserver-xorg-video-amdgpu" ]; then
    echo -e "${BLUE} Would you like to install proprietary drivers? \n"
    read -p '(Y/N):' proprietarydrivers
    if [ $proprietarydrivers = "Y" ]; then
        sudo nala install firmware-amd-graphics
    fi
elif [ $pkgs == "xserver-xorg-video-radeon" ]; then
    echo -e "${BLUE} Would you like to install proprietary drivers? \n"
    read -p 'Y/N: ' proprietarydrivers
    if [ $proprietarydrivers = "Y" ]; then
        sudo nala install firmware-amd-graphics
    fi
fi

# Remove screen tearing
echo -e "${BLUE} To remove screen tearing please type whatever is shown Kernel driver in use: \n"
echo -e "${RED} $extra \n"
read -p 'Kernel driver in use: ' kerneluse
echo 'Choosen:' $kerneluse

## AMD ##
# radeon
if [ $kerneluse == "radeon" ]; then
    if [ -d "/etc/X11/" ]; then
        echo "/etc/X11 exists"
    else
    sudo mkdir /etc/X11
    fi
touch xorg.conf && echo "Section \"Device\"
    Identifier \"Radeon\"
    Driver \"radeon\"
    Option \"TearFree\" \"on\"
EndSection" >> xorg.conf
    FILE=/etc/X11/xorg.conf
    if test -f "$FILE"; then
        sudo rm -rf -v $FILE
    fi
    sudo mv $(pwd)/xorg.conf /etc/X11/
    sudo chmod +x /etc/X11/xorg.conf
    sudo chmod +775 /etc/X11/xorg.conf
    echo "Radeon is now free of screen tearing"
fi

# amdgpu
if [ $kerneluse == "amdgpu" ]; then
    if [ -d "/etc/X11/xorg.conf.d" ]; then
        echo "/etc/X11/xorg.conf.d exists"
    else
    sudo mkdir -p /etc/X11/xorg.conf.d
    fi
touch 20-amdgpu.conf && echo "Section \"Device\"
    Identifier \"AMD\"
    Driver \"amdgpu\"
    Option \"TearFree\" \"true\"
EndSection" >> 20-amdgpu.conf
    FILE=/etc/X11/xorg.conf.d/20-amdgpu.conf
    if test -f "$FILE"; then
        sudo rm -rf -v $FILE
    fi
    sudo mv $(pwd)/20-amdgpu.conf /etc/X11/xorg.conf.d/
    sudo chmod +x /etc/X11/xorg.conf.d/20-amdgpu.conf
    sudo chmod +775 /etc/X11/xorg.conf.d/20-amdgpu.conf
    echo "Amdgpu is now free of screen tearing"
fi

## Intel ##
# intel and nvidia
if [ $kerneluse == "intel" ]; then
    if [ -d "/etc/X11/xorg.conf.d" ]; then
        echo "/etc/X11/xorg.conf.d exists"
    else
    sudo mkdir -p /etc/X11/xorg.conf.d
    fi
touch 20-intel.conf && echo "Section \"Device\"
    Identifier \"Intel Graphics\"
    Driver \"intel\"
    Option \"TearFree\" \"true\"
EndSection" >> 20-intel.conf
    FILE=/etc/X11/xorg.conf.d/20-intel.conf
    if test -f "$FILE"; then
        sudo rm -rf -v $FILE
    fi
    sudo mv $(pwd)/20-intel.conf /etc/X11/xorg.conf.d/
    sudo chmod +x /etc/X11/xorg.conf.d/20-intel.conf
    sudo chmod +775 /etc/X11/xorg.conf.d/20-intel.conf
    echo "Intel is now free of screen tearing"
fi
