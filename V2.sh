#!/bin/bash/
set -x
#Set variables:

#Sets CPU core count
corecount="$(sysctl -a | grep -c "dev.cpu.*.temperature")"

#Sets Number of drives count
drivecount="$(ls /dev/ | grep -c '\bda[0-9]\b')"

#Sets the date that the script started running
TOD=`date "+DATE: %m-%d-%Y%nTime: %H:%M:%S"`

#Sets the date for the log file
logdate=`date "+%m-%d-%Y"`

#Sets the time for the log file contents
logtime=`date "+%m-%d-%Y  %H:%M:%S"`

#Clears the screen from all printouts
clear

echo "Processor Core Count: " $"corecount"
echo $TOD
echo $drivecount
exit 0
