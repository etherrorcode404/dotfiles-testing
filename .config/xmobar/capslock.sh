#!/bin/sh

# ensure only one instance of script is running
if pidof -x $(basename $0) -o %PPID > /dev/null
then
    exit
fi

state=$(xset -q | grep Caps | awk '{print $4}')
if [ "$state" = "on" ]; then
    echo "[<fc=#d3869b>CapsLock (A)</fc>]"
else
    echo ""
fi
