#!/bin/sh
exec dbus-launch --autolaunch=$(cat /var/lib/dbus/machine-id) xmonad
