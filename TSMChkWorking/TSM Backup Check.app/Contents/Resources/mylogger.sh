#!/bin/bash

#Log script. The first argument is the full path to the log. Each argument after that is a new line written to the log. Use quotes!
# Usage: ./mylogger.sh "/full/path/to/logname" [Text to log, 0-* arguments]
#Call from shell script by setting the full log path as a variable
#mylog="./mylogger.sh /Library/Logs/mylog.log"
#$mylog "This will be written to the /Library/Logs/mylog.log file. Cool!"

if [ "$1" = "" ]; then
	echo "Error. No log defined"
	echo "Usage: ./mylogger.sh \"/full/path/to/logname\" \"Text to log\""
	exit 1
fi	

logfile="$1"											# The log file is the first argument
logdate=`date "+%Y%m%d.%H.%M.%S"`						#Format the date at the front of each line the way you like. man date is an excellent resource.

shift
until [ -z "$1" ]          	 							# Until uses up arguments passed...
	do
	echo "$logdate" "$1" >> $logfile
    shift
  done