#!/bin/bash/
set -x
#Set variables:

#Sets CPU core count and check <0
corecount="$(sysctl -a | grep -c "dev.cpu.*.temperature")"

#Catches if script was unable to count cpu's
if [ "$corecount" -gt 0 ] ; then
    continue
else
    echo "Could not count cores!"
      while true; do
        read -p " Would you like to continue?" yn
        case $yn in
          [Yy]* ) break;;
          [Nn]* ) echo "Ending my life!"
        esac
        exit 126 && echo $?
      done
fi

#Checks both 'da' and 'ada' for drives.
da="$(ls /dev/ | grep -c '\bda[0-9]\b')"
ada="$(ls /dev/ | grep -c '\bada[0-9]\b')"

#Drive count var
drivecount="0"

#checks if 'da' has a drive count
#if 'da' has a count, sets variable to count
#else if 'da' is Zero/Null checks 'ada'
#if 'ada' has a count, sets variable to count
#else unable to count drive, asks to continue

if [ $da -gt 0 ] ; then
  drivecount="$(ls /dev/ | grep -c '\bda[0-9]\b')"
  echo "Using 'da' drive count"
  continue
elif [ $ada -gt 0 ] ; then
  drivecount="$(ls /dev/ | grep -c '\bada[0-9]\b')"
  echo "Using 'ada' drive count"
  continue
else
  echo "Unable to count drives!"
        while true; do
        read -p " Would you like to continue?" yn
        case $yn in
          [Yy]* ) break;;
          [Nn]* ) echo "Ending my life!"
        esac
        exit 126 && echo $?
      done
fi

#Catches if script was unable to count drives
if [ "$drivecount" -gt 0 ] ; then
    continue
    else
    echo "Could not count drives!"
      while true; do
        read -p " Would you like to continue?" yn
        case $yn in
          [Yy]* ) break;;
          [Nn]* ) echo "Ending my life!"
        esac
        exit 126 && echo $?
      done
fi

#Sets the date that the script started running
TOD=`date "+DATE: %m-%d-%Y%nTime: %H:%M:%S"`

#Sets the date for the log file
logdate=`date "+%m-%d-%Y"`

#Sets the time for the log file contents
logtime=`date "+%m-%d-%Y  %H:%M:%S"`

echo "Processor Core Count: " $corecount
sysctl -a | grep "dev.cpu.*.temperature" | awk '{print $2}' | awk -v corecount="$corecount" '{ SUM+= $1/corecount} END { print "Average Core temp: " SUM "C"}'
echo "Number of Drives: " $drivecount
uptime | awk '{print "System Load  1 minute: " $10}'
uptime | awk '{print "System Load  5 minute: " $11}'
uptime | awk '{print "System Load 15 minute: " $12}'

exit 0
