#!/bin/bash

#
# This is the script to paste into Alfred, to append treadmill miles walked to todays note.
#

query="{query}"

echo -n $query

NOW_DATE=$(date +%Y-%m-%d)
NOW_TIME=$(date +%R)

printf "\n#walk #treadmill $NOW_TIME $query mile\n" >> "/Users/saibotsivad/Dropbox/Obsidian/ProbablyEverything/$NOW_DATE.md"
