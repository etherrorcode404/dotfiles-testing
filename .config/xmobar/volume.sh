#!/bin/bash
bar=$(amixer sget Master | tail -n 1)
status=$(echo "${bar}" | grep -wo "on")
volume=$(echo "${bar}" | awk -F ' ' '{print $5}' | tr -d '[]%')
case $((volume/50)) in
  0) icon="奔" ;;
  1) icon="墳" ;;
  *) icon="墳" ;;
esac

if [[ "${status}" == "on" ]]; then
  echo "<fc=#e2cca9>$icon </fc>Vol ${volume}% "
else
  echo "<fc=#e2cca9>婢 </fc>Mute "
fi
