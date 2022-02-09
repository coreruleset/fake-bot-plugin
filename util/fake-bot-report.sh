#!/bin/bash
#
# Script to analyze the alerts of the OWASP ModSecurity Core Rule Set
# Fake Bot Plugin based on the error log alerts.
#
# Usage: cat error.log | ./fake-bot-report.sh
#
# Created in 2022 by Christian Folini.
# License: Public Domain
# 
# CAVEAT: Please note that this script only reports 1 User-Agent 
# per offending IP.
# Also, need to have geoiplookup installed.

UAWIDTH=`expr $(tput cols) - 27`
TMPFILE=$(mktemp)

cat | grep 9504110 > $TMPFILE

(cat $TMPFILE | grep -o "\[client [^]]*" | cut -b9- | sort | uniq | while read IP; do
	N=$(grep -c $IP $TMPFILE)
	COUNTRY=$(geoiplookup $IP | egrep -o "[A-Z]{2}," | tr -d ,)
	USERAGENT=$(grep $IP $TMPFILE | grep -o 'REQUEST_HEADERS:User-Agent: [^]]*' | sort | uniq | cut -d: -f3- | sed -e 's/\(.\{'$UAWIDTH'\}\).*/\1 .../' | tr -d \" | head -1)
	printf "%3s %2s %-15s %s\n" $N $COUNTRY $IP "$USERAGENT"
done) | sort -nr

trap 'rm -f "$TMPFILE"' EXIT
