#!/bin/bash
# This script reboots all the systems in the specified reboot list one at a time
# It waits until the current system is back up before rebooting the next one
# Last Edit: Creation
# Date of last edit: see git log

reboot_systems=$(cat /home/pengels/configs/reboot_list.txt)

# Loop through all of the systems in the list
for system in ${reboot_systems}
do
	# Print the name for more intuitive output
        echo ${system}

	# Reboot the system
	# This leaves a 255 retcode so the while loop will work
        ssh -o ConnectTimeout=10 ${system} "sudo reboot"

	# keep attempting to login every 5 seconds until it works
	while [ ${?} -ne 0 ]
	do
		# Wait 10 seconds
		sleep 5
		# Print a '.' so it's obvious it's working 
		echo -n '.'
		# SSH to the system with an immediate disconnect
		ssh ${system} "exit"
	done
	# Just print a newline so the print system name at the top of the loop isn't on the same line as the dots
	echo ''
done
