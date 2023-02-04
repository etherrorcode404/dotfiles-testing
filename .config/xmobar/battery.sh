#!/bin/bash

ac=" "

if [ -d /sys/class/power_supply/BAT* ]; then
charge=$(upower -i $(upower -e | grep '/battery') | grep -E percentage|xargs|cut -d' ' -f2|sed s/%//)
status=$(cat /sys/class/power_supply/BAT*/status)
#state=$(upower -i $(upower -e | grep '/battery') | grep  -E state)
#status=$(echo "${state}" | grep -wo "charging")
#CHARGE=$(cat /sys/class/power_supply/BAT*/capacity)
else
    echo "<fc=#d3869b>$ac AC power</fc>"
fi

if [ "$status" = "Charging" ]; then
    echo "<fc=#d3869b>$ac ${charge}%</fc>"
elif [ $charge -le 75 ] && [ $charge -gt 50  ]; then
    echo "<fc=#d3869b>"  " ${charge}%</fc>"
elif [ $charge -le 50 ] && [ $charge -gt 25  ]; then
    echo "<fc=#d3869b>"  " ${charge}%</fc>"
elif [ $charge -le 25 ] && [ $charge -gt 10  ]; then
    echo "<fc=#d3869b>"  " ${charge}%</fc>"
elif [ $charge -le 10 ]; then
    echo "<fc=#d3869b>"  " ${charge}%</fc>"
else
    echo "<fc=#d3869b> "  " ${charge}%</fc>"
fi
