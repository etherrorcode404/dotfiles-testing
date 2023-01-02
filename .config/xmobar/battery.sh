#!/bin/bash
ac=" "

if [ -d /proc/acpi/battery/BAT* ]; then
 state=$(upower -i $(upower -e | grep '/battery') | grep --color=never -E state)
 plugged=$(echo "${state}" | grep -wo "charging")
 charge=$(upower -i $(upower -e | grep '/battery') | grep --color=never -E percentage|xargs|cut -d' ' -f2|sed s/%//)
else
    echo "<fc=#d3869b>$ac AC power</fc>"
fi

case $((charge/50)) in
  0) icon=" " ;;
  1) icon=" " ;;
  *) icon=" " ;;
esac

if [[ ${plugged} == "charging" ]]; then
    echo "<fc=#d3869b>$ac ${charge}%</fc>"
else
    echo "<fc=#d3869b>$icon ${charge}%</fc>"
fi
