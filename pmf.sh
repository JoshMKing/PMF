#!/bin/sh

# Modify limit here if required. Default anything over 500 is firewalled.
mylimit="1500";

find /usr/local/apache/domlogs/* -mtime -1 -not -name "*ftp_log*" -not -name "*bytes_log*" -exec egrep '(wp-login.php)|(administrator)' {} \; | awk -F - '{print $1}'| sort | uniq -c | sort -n | tail -n 10 | while read LINE;
do
	MYIPCOUNT=`echo $LINE | awk 'BEGIN { FS=" "; }; { print $1; }'`;
	MYIP=`echo $LINE | awk 'BEGIN { FS=" "; }; { print $2; }'`;
	if [ $MYIPCOUNT -gt $mylimit ];
	then
		echo "$MYIP count of $MYIPCOUNT is greater than the limit of $mylimit";
		csf -td $MYIP "Pattern match in domlogs with $MYIPCOUNT requests out of $mylimit limit";
	fi
done
