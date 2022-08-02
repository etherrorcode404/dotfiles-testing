#!/bin/bash

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

sudo mkdir /usr/local/share/applications/

echo "########################"
echo "## Adding 'nala' repo ##"
echo "########################"
echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg

echo "#####################################################################"
echo "## Updating and installing 'dialog' 'nala-legacy' if not installed ##"
echo "#####################################################################"
sudo apt update && sudo apt-get dist-upgrade -y
sudo apt-get install -y dialog nala-legacy

echo "######################"
echo "## Updating Mirrors ##"
echo "######################"
sudo nala fetch

while read -r p ; do sudo nala install -y $p ; done < <(cat << "EOF"
echo installing the pre-requisites..
sleep 3
  xserver-xorg-core xinit
  xserver-xorg-video-amdgpu
  firmware-amd-graphics
  firmware-realtek
  libgl1-mesa-dri
  x11-utils
  git
  curl
  wget
  sed
  xcwd
  xdotool
  numlockx
  physlock
  bash
  dash
  fish
  alsa-utils
  pavucontrol
  playerctl
  qbittorrent
  conky
  lxappearance
  hostname
  hplip-gui
  sudo
  build-essential
  software-properties-common
  xdg-utils
  usbutils
  pciutils
  tree
  mount
  xmobar
  lua-nvim
  fonts-firacode
  mlocate
  default-jdk
  default-jre
  python-is-python2
  python2
  python3
  python3-pip
  rofi
  firefox-esr
  feh
  scrot
  gimp
  network-manager-gnome
  pcmanfm
  vlc
  cmake 
  pkg-config 
  libfreetype6-dev 
  libfontconfig1-dev 
  libxcb-xfixes0-dev 
  libxkbcommon-dev
  libx11-dev
  libxft-dev
  libxinerama-dev
  libxrandr-dev
  libxss-dev
  haskell-stack
  gdebi-core
EOF
)

echo "##################################"
echo "## Building and adding Programs ##"
echo "##################################"
sleep 2
echo "#Setup Nerd Fonts"
git clone https://github.com/ronniedroid/getnf.git
cd getnf
./install.sh 
sleep 2
cd $HOME

echo "#Alacritty"
sleep 2
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cargo install alacritty
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/linux/Alacritty.desktop
sudo mv Alacritty.desktop /usr/local/share/applications/
sudo chmod +X /usr/local/share/applications/Alacritty.desktop
sudo chmod 775 /usr/local/share/applications/Alacritty.desktop

echo "#Xmonad"
sleep 2
cd ~/.config/xmonad
sudo apt purge xmoand
git clone https://github.com/xmonad/xmonad
git clone https://github.com/xmonad/xmonad-contrib
stack upgrade
stack init
stack install
sudo ln -s ~/.local/bin/xmonad /usr/bin
wget https://raw.githubusercontent.com/etherrorcode404/desktop-entries/main/xmonad.desktop
sudo mv xmonad.desktop /usr/share/xsessions
sudo chmod +x /usr/share/xsessions/xmonad.desktop
sudo chmod 775 /usr/share/xsessions/xmonad.desktop
cd $HOME

echo "#Spotify"
sleep 2
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/repository-spotify-com-keyring.gpg
sudo apt-get update && apt-get install spotify-client
wget https://raw.githubusercontent.com/etherrorcode404/desktop-entries/main/spotify.desktop
sudo mv spotify.desktop /usr/local/share/applications/
sudo chmod +x /usr/local/share/applications/spotify.desktop
sudo chmod 775 /usr/local/share/applications/spotify.desktop

echo "#Github-desktop Version 3.03"
wget https://github.com/shiftkey/desktop/releases/download/release-3.0.3-linux1/GitHubDesktop-linux-3.0.3-linux1.deb 
sudo gdebi GitHubDesktop-linux-3.0.3-linux1.deb 

echo "#Zoom"
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo nala install ./zoom_amd64.deb 

echo "#Discord"
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo nala install ./discord.deb

sudo apt autoremove
