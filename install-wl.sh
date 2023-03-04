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
sudo apt-get update && sudo apt-get install -qq -f -y nala

echo "######################"
echo "## Updating Mirrors ##"
echo "######################"
sudo nala fetch
echo installing the pre-requisites..
sleep 2s
egrep -v "^$|^[[:space:]]*#" $(pwd)/wlpkglist > wlpkginstall
sudo apt-get install $(cat wlpkginstall)

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
sudo make WAYLAND=1 install

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
sudo chmod 775 /usr/local/share/applications/Alacritty.desktop
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release --no-default-features --features=wayland
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
sudo chmod 775 ~/.local/share/applications/spotify.desktop
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh

echo "## Brave Browser ##"
sleep 2s
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt-get update && sudo apt-get install -qq -f -y brave-browser

echo "## Git-Hub Desktop ##"
wget -qO - https://mirror.mwt.me/ghd/gpgkey | sudo tee /etc/apt/trusted.gpg.d/shiftkey-desktop.asc > /dev/null
sudo sh -c 'echo "deb [arch=amd64] https://mirror.mwt.me/ghd/deb/ any main" > /etc/apt/sources.list.d/packagecloud-shiftkey-desktop.list'
sudo apt-get update && sudo apt-get install -qq -f -y github-desktop

echo "## Neovim ##"
sleep 2s
sudo apt-get autoremove -qq -y neovim
sudo apt-get autoremove -qq -y neovim-runtime
wget -O nvim.deb "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.deb"
sudo nala install ./nvim.deb

echo "## Zoom ##"
sleep 2s
wget -O zoom.deb "https://zoom.us/client/latest/zoom_amd64.deb"
sudo nala install ./zoom.deb

echo "## Discord ##"
sleep 2s
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

echo "## Hyprland ##"
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
sudo make install
cd $HOME

echo "## Waybar ##"
git clone https://github.com/Alexays/Waybar
cd Waybar
sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
meson --prefix=/usr --buildtype=plain --auto-features=enabled --wrap-mode=nodownload build
meson configure -Dexperimental=true build
sudo ninja -C build install
cd $HOME

echo "## Hyprpaper ##"
git clone https://github.com/hyprwm/hyprpaper
cd hyprpaper
make all
cd $HOME

echo "## Hyprpicker ##"
git clone https://github.com/hyprwm/hyprpicker
cd hyprpicker
make all
cd $HOME

echo "## xdg-desktop-portal-hyprland ##"
https://github.com/hyprwm/xdg-desktop-portal-hyprland
meson build --prefix=/usr
ninja -C build
cd hyprland-share-picker && make all && cd ..
ninja -C build install
sudo cp ./hyprland-share-picker/build/hyprland-share-picker /usr/bin

echo "## Clean UP ##"
sleep 2s
rm -rf *.deb
rm -rf gruvbox-material-gtk spotify-adblock alacritty 
sudo apt-get autopurge
sudo apt-get update && sudo apt-get dist-upgrade
