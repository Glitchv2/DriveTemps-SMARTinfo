#!/bin/bash

#Sets variables
TOD=`date "+DATE: %m-%d-%Y%nTime: %H:%M:%S"`
logdate=`date "+%m-%d-%Y"`
logtime=`date "+%m-%d-%Y  %H:%M:%S"`
drivecount=""

#Shows variables to verify they're correct
echo "$TOD"
echo "$logdate"

#Check to see if logfile exists
if ls /scripts/smartlogs/* 1> /dev/null 2>&1; then

	#If it's found it's deleted, and re-created
        echo "Logfile found! Deleting..."
	rm "/scripts/smartlogs/smartlog"*
        sleep 5
        echo "Logfile deleted..."
        echo "Creating new logfile."
        touch "/scripts/smartlogs/smartlog+${logdate}.log"
else

	#Otherwise it creates the logfile
        echo "No logfile found"
        echo "Creating new logfile."
        touch "/scripts/smartlogs/smartlog+${logdate}.log"
fi



uptime | awk '{ print "\nSystem Load:",$8,$9,$10,"\n" }' >> "/scripts/smartlogs/smartlog+${logdate}.log"
echo "CPU Temperature:" >> "/scripts/smartlogs/smartlog+${logdate}.log"
sysctl -a | egrep -E "cpu\.[0-9]+\.temp" >> "/scripts/smartlogs/smartlog+${logdate}.log"
echo >> "/scripts/smartlogs/smartlog+${logdate}.log"
echo >> "/scripts/smartlogs/smartlog+${logdate}.log"



#Count number of drives and echo
drivecount="$(ls /dev/ | grep -c '\bada[0-9]\b')"

#Since it starts with 1 instead of 0
drivecount=$((drivecount-1))

echo "Number of drives counted via 'ada': ${drivecount}"
sleep 5

#Loop checks ada0 - ada${drivecount}
for x in $( seq 0 $drivecount ); do
	#First check if drive is awake or not
	smartctl -n standby /dev/ada${x}
	
	#Check exit code of above command
	#if exit code does not equal 0, then skip drive
	if [ $? -ne "0" ]; then #Do not attempt to test the drive and keep the drive asleep.
		echo "ada${x} is currently asleep and was not tested!" >> "/scripts/smartlogs/smartlog+${logdate}.log"
		continue
	
	else  #Drive is awake and ready to be tested
	echo ""
		#Prints the drive number, date, and time
	echo "ada${x} results @ ${logtime}" >> "/scripts/smartlogs/smartlog+${logdate}.log"
	
		#Print the Temp of the drive.
        smartctl -n standby -A /dev/ada${x} | grep -ie "temp" | awk '$10 {print "Drive temp: "($10)" celsius"}' >> "/scripts/smartlogs/smartlog+${logdate}.log"
	
        	#Print the Serial No. of the drive.
        smartctl -n standby -i /dev/ada${x} | grep -i -e "serial" >> "/scripts/smartlogs/smartlog+${logdate}.log"
	
        echo "" >> "/scripts/smartlogs/smartlog+${logdate}.log"
	
		#Prints out important drive SMART info.
        smartctl -n standby -a /dev/ada${x} | grep -i -e "raw_read" -e "reallocated" -e "seek" -e "spin" -e "current_pending" -e "offline_un" >> "/scripts/smartlogs/smartlog+${logdate}.log"
	
        echo "" >> "/scripts/smartlogs/smartlog+${logdate}.log"
        echo "" >> "/scripts/smartlogs/smartlog+${logdate}.log"
	fi
done

#Emails root and Users the logfile.
(cat /scripts/smartlogs/smartlog+${logdate}.log; uuencode /scripts/smartlogs/smartlog+${logdate}.log /scripts/smartlogs/smartlog+${logdate}.log) | mail -s "Drive Info" root
