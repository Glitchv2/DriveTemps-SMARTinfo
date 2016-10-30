w#!/bin/bash/
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
          [Yy]* ) continue;;
          [Nn]* ) echo "Script halted, quitting."
        esac
        exit 126 && echo $?
      done
fi

#Sets Number of drives count
#drivecount="$(ls /dev/ | grep -c '\bda[0-9]\b')"


#checks if 'da' has a drive count
#if 'da' has a count, sets variable to count
#else if 'da' is Zero/Null checks 'ada'
#if 'ada' has a count, sets variable to count
#else unable to count drive, asks to continue

if [ ls /dev/ | grep -c '\bda[0-9]\b' ] -gt 0 ] ; then
  drivecount="$(ls /dev/ | grep -c '\bda[0-9]\b')"
elif [ ls /dev/ | grep -c '\bada[0-9]\b' ] -gt 0 ] ; then
  drivecount="$(ls /dev/ | grep -c '\bada[0-9]\b')"
else
  echo "Unable to count drives!
        while true; do
        read -p " Would you like to continue?" yn
        case $yn in
          [Yy]* ) continue;;
          [Nn]* ) echo "Script halted, quitting."
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
          [Yy]* ) continue;;
          [Nn]* ) echo "Script halted, quitting."
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

#Clears the screen from all printouts
clear

echo "Processor Core Count: " $corecount
echo "Number of 'da' Drives: " $drivecount
exit 0
