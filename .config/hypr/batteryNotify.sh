#!/bin/bash
while true
do

    if [ -d /sys/class/power_supply/BAT* ]; then
        CHARGE=$(cat /sys/class/power_supply/BAT*/capacity)
        STATUS=$(cat /sys/class/power_supply/BAT*/status)
    else
        exit
    fi

       if [ "$STATUS" = "Charging" ]; then
   if [ "$CHARGE" = "90" ]; then
       notify-send --urgency=CRITICAL "Disconnect Charger" "Level: ${CHARGE}%"
   fi

else
        if [ "$STATUS" = "Discharging" ]; then
    if [ "$CHARGE" -le 30 ]; then
        notify-send --urgency=CRITICAL "Connect Charger" "Level: ${CHARGE}%"
        fi
    fi
fi
sleep 60s
done
