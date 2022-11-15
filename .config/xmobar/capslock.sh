#!/bin/sh
state=$(xset -q | grep Caps | awk '{print $4}')
if [ "$state" = "on" ]; then
    echo "[<fc=#d3869b>CapsLock [A]</fc>]"
else
    echo ""
fi
