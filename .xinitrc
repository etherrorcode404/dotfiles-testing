#!/bin/sh

export XDG_SESSION_TYPE=x11
export DESKTOP_SESSION=xmonad
systemctl --user import-environment DISPLAY XAUTHORITY

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
fi

exec xfce4-power-manager &
exec ~/.config/xmonad/batteryNotify.sh &
exec dbus-launch --autolaunch=$(cat /var/lib/dbus/machine-id) $HOME/.cache/xmonad/xmonad-x86_64-linux
