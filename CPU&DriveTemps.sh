#! /bin/bash
drivecount=""
clear
echo System Temperatures  - `date`
cat /etc/version
uptime | awk '{ print "\nSystem Load:",$8,$9,$10,"\n" }'
echo "CPU Temperature:"
sysctl -a | egrep -E "cpu\.[0-9]+\.temp" | sort -V
echo

#Count number of drives (ada) and echo
drivecount="$(ls /dev/ | grep -c '\bada[0-9]\b')"

#Since it starts with 1 instead of 0
drivecount=$((drivecount-1))

echo "Number of drives counted via 'ada': ${drivecount}"
sleep 2

#Loop checks ada0 - ada${drivecount}
for x in $( seq 0 $drivecount ); do
	#First check if drive is awake or not
	smartctl -n standby /dev/ada${x}
	
	#Check exit code of above command
	#if exit code does not equal 0, then skip drive
	if [ $? -ne "0" ]; then
		#Do not attempt to test the drive
		#Will keep the drive asleep
		echo "ada${x} is currently asleep and was not tested!"
		continue	
	else
		#Drive is awake and ready to be tested
		echo ""
		smartctl -a /dev/ada${x} | grep -ie "temp" | awk '$10 {print "Drive temp: "($10)" celsius"}'
		smartctl -i /dev/ada${x} | grep -i -e "serial"		
	fi
done
