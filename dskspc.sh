#!/bin/bash

. "${BASH_SOURCE%/*}/config"

which $MAILX > /dev/null 2>&1 #Here we check if mailx command exist

#We check exit status of previous command if exit status not 0 this mean that mailx is not installed on system
if [ $? -ne 0 ]; then
	echo "Please install $MAILX" #Here we warn user that mailx not installed
	exit 1 #Here we will exit from script
fi

cd $DIR #To check real used size, we need to navigate to folder
#This line will get used space of partition where we currently, this will use df command, and get used space in %, and after cut % from value.
used=$(df . | awk '{print $5}' | sed -ne 2p | cut -d"%" -f1)

#If used space is bigger than LIMIT
if [ $used -gt $LIMIT ];then
	#This will print space usage by each directory inside directory $DIR, and after MAILX will send email with SUBJECT to MAILTO
	du -sh ${DIR}/* | $MAILX -s "$SUBJECT" "$MAILTO"
fi
