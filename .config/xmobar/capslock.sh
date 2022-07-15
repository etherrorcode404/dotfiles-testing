#!/bin/sh
state=$(xset -q | grep Caps | awk '{print $4}')
if [ "$state" = "on" ]; then
    echo "[<fc=#f2594b>CapsLock [A]</fc>]"
else
    echo ""
fi
