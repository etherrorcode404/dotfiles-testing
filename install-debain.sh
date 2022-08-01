#!/bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

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
