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

echo "#####################################"
echo "## Adding 'non-free' and 'contrib' ##"
echo "#####################################"
sleep 2s
sudo apt-get install -qq -f -y software-properties-common
sudo apt-add-repository contrib && sudo apt-add-repository non-free
sudo apt-get update && sudo apt-get dist-upgrade -qq -f -y

echo "########################"
echo "## Installing 'nala'  ##"
echo "########################"
#echo "deb https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
#wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
#echo "deb-src https://deb.volian.org/volian/ scar main" | sudo tee -a /etc/apt/sources.list.d/volian-archive-scar-unstable.list
sudo apt-get update && sudo apt-get install -qq -f -y nala

echo "######################"
echo "## Updating Mirrors ##"
echo "######################"
sudo nala fetch
echo installing the pre-requisites..
sleep 2s
egrep -v "^$|^[[:space:]]*#" $(pwd)/wlpkglist > wlpkginstall
sudo apt-get install $(cat wlpkginstall) && sudo apt-get build-dep wlroots

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

#echo "## Xmonad ##"
#sleep 2s
#cd ~/.config/xmonad
#sudo apt-get autoremove -qq -y xmoand
#git clone https://github.com/xmonad/xmonad
#git clone https://github.com/xmonad/xmonad-contrib
#stack upgrade
#stack init
#stack install
#sudo ln -s ~/.local/bin/xmonad /usr/bin
#sudo wget -O /usr/share/xsessions/xmonad.desktop "https://raw.githubusercontent.com/etherrorcode404/main/xmonad.dekstop"
#sudo chmod +x /usr/share/xsessions/xmonad.desktop
#sudo chmod 775 /usr/share/xsessions/xmonad.desktop
#cd $HOME

echo "## Hyprland ##"
git clone --recursive https://gitlab.com/volian/Hyprland.git
cd Hyprland
meson build
ninja -C build
sudo ninja -C build install

echo "## Waybar ##"
sudo apt-get install waybar

echo "## Shell ##"
sudo apt-get install fish

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
rm -rf *.deb
rm -rf gruvbox-material-gtk 
sudo apt-get autopurge
sudo apt-get update && sudo apt-get dist-upgrade
