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

echo installing the pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
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
  python
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
# xmonad
  libx11-dev
  libxft-dev
  libxinerama-dev
  libxrandr-dev
  libxss-dev
  haskell-stack
EOF
)

echo installing (optional) pre-requisites
echo you have 10 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 10

sudo apt-get install -y tig
