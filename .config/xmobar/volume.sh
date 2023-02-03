#!/bin/bash

# ensure only one instance of script is running
if pidof -x $(basename $0) -o %PPID > /dev/null
then
    exit
fi

bar=$(amixer sget Master | tail -n 1)
status=$(echo "${bar}" | grep -wo "on")
volume=$(echo "${bar}" | awk -F ' ' '{print $5}' | tr -d '[]%')
case $((volume/50)) in
  0) icon="奔" ;;
  1) icon="墳" ;;
  *) icon="墳" ;;
esac

if [[ ${status} == "on" ]]; then
  echo "<fc=#b0b846>$icon Vol ${volume}%</fc>"
else
  echo "<fc=#b0b846>婢 Mute</fc>"
fi
