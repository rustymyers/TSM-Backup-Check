#!/bin/bash

# Rusty Myers
# Updated 20100107

# Bug Fix:
# Would produce error when trying to set the time because the ~/Library/LaunchAgents/ folder wouldn't be there.

# Path to the launchd plist that runs the App
tsmchkPlist=~/Library/LaunchAgents/edu.psu.educ.tsmchk.plist

# Check for ~/Library/LaunchAgents directory
if [[ ! -d ~/Library/LaunchAgents/ ]]; then
	mkdir -p ~/Library/LaunchAgents/
fi

#Check for existing plist, add if not there.
if [[ ! -e $tsmchkPlist ]]; then
	echo "
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>Disabled</key>
		<false/>
		<key>Label</key>
		<string>edu.psu.educ.tsmchk</string>
		<key>ProgramArguments</key>
		<array>
			<string>/Applications/TSM\ Backup\ Check/TSM\ Backup\ Check.app</string>
		</array>
		<key>StartCalendarInterval</key>
		<dict>
			<key>Hour</key>
			<integer>10</integer>
			<key>Minute</key>
			<integer>0</integer>
		</dict>
	</dict>
	</plist>" >> ~/Library/LaunchAgents/edu.psu.educ.tsmchk.plist
fi

# This is the example to use notifyAS as a function. You set the message in ASmessage, shell variables are good to use.
# the notifyAS command calls the function and displays the ASmessage.
# 
# ASmessage="Display This Message"
# notifyAS

function notifyAS {
	dialogdays=`/usr/bin/osascript << EOT
		tell application "System Events"
			display dialog "$ASmessage" buttons ["OK"] default button "OK"
		end tell
		EOT`
		echo $dialogdays
}

timeOFday=`/usr/bin/osascript << EOT
tell application "System Events"
	display dialog "What time of the day do you want TSM Check to run? Format in military time without \":\". It must include 4 numbers. Type \"disable\" to disable automatic checking." default answer "1000"  buttons ["OK"] default button "OK" 
	set result to text returned of result
end tell
EOT`

if [[ $timeOFday = "disable" ]]; then
	echo "Disabled"
	# Set Disabled flag to true
	/usr/libexec/PlistBuddy -c "set Disabled true" $tsmchkPlist

else
	##Seperate Hour and Minutes
	/usr/libexec/PlistBuddy -c "set Disabled false" $tsmchkPlist

	timeOFhour=`echo $timeOFday| cut -c 1-2`
	timeOFmin=`echo $timeOFday| cut -c 3-4`

	/usr/libexec/PlistBuddy -c "set :StartCalendarInterval:Hour $timeOFhour" $tsmchkPlist
	/usr/libexec/PlistBuddy -c "set :StartCalendarInterval:Minute $timeOFmin" $tsmchkPlist
fi

DisabledFlag=`/usr/libexec/PlistBuddy -c "print Disabled" $tsmchkPlist`
HourTime=`/usr/libexec/PlistBuddy -c "print StartCalendarInterval:Hour" $tsmchkPlist`
MinTime=`/usr/libexec/PlistBuddy -c "print StartCalendarInterval:Minute" $tsmchkPlist`

if [[ $HourTime -eq "0" ]]; then
	HourTime="00"
elif [[ $HourTime -gt "24" ]]; then
	ASmessage="You have set an invalid entry for the hour. Please try again."
	notifyAS
	exit 0
fi


if [[ $MinTime = "0" ]]; then
	MinTime=00	
elif [[ $MinTime > 59 ]]; then
	ASmessage="You have set an invalid entry for the mintes. Please try again."
	notifyAS
	exit 0
fi

if [[ $DisabledFlag = "true" ]]; then
	ASmessage="The TSM Backup Check.app is now set to Disabled. It will not auto-check your backups."
	notifyAS
else
	ASmessage="The TSM Backup Check.app is now set to Enabled. It will auto-check your backups at $HourTime$MinTime."
	notifyAS
fi