#!/bin/bash

#
# This is the script to paste into Alfred, to append treadmill miles walked to todays note.
#
# Set language to "/bin/bash" and use "with input as argv"
#
# On the "Post Notification" step, set "Text" to: {query}
#

query="${1}"

NOW_DATE=$(date +%Y-%m-%d)
NOW_TIME=$(date +%R)

FILE="/Users/tobiasdavis/Documents/Knowledge/Reference/Kappa Streams/Treadmill.md"

comma_count=$(echo $query | tr -cd , | wc -c)

if [[ $comma_count -eq "1" ]]; then
	query="${query},2.5mph"
fi
if [[ "${query}" != *mph ]]; then
	query="${query},,2.5mph"
fi

treadmill_line="${NOW_DATE},${NOW_TIME},${query}"
treadmill_line="| ${treadmill_line//,/ | } |"
printf "${treadmill_line}\n" >> "${FILE}"

echo -n "${treadmill_line}"
