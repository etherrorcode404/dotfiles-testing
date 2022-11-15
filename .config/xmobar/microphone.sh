#!/bin/bash
#This script displays microphone status, requires xmobar.


# Audio Profiles
#pacmd set-card-profile alsa_card.pci-0000_09_00.1 off #Pc-Jack
#pacmd set-card-profile alsa_card.usb-Sonix_Technology_Co.__Ltd._Rapoo_Camera_SN0001-02 off #WebCam
#pacmd set-card-profile alsa_card.usb-GeneralPlus_USB_Audio_Device-00 output:analog-stereo+input:mono-fallback #Usb-Headset
#pacmd set-card-profile alsa_card.pci-0000_09_00.6 off #Pc-Jack

#~/.config/xmobar/AudioProfile.sh

orange=#f28534
white=#e2cca9

bar=$(amixer get Capture | tail -n 1)
status=$(echo "${bar}" | grep -wo "on")
volume=$(echo "${bar}" | awk -F ' ' '{print $4}' | tr -d '[]%')

if [[ "${status}" == "on" ]]; then
  echo "<fc=$orange> </fc>Vol ${volume}% "
else
  echo "<fc=$orange> </fc>Mute "
fi
