#!/bin/sh

# ensure only one instance of script is running
if pidof -x $(basename $0) -o %PPID > /dev/null
then
    exit
fi

echo "<fc=#8ec07c> $(date +"%I:%M %p %d/%b/%y")</fc>"
