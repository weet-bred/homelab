#!/bin/bash
# This script reboots all the systems in the specified reboot list one at a time
# It waits until the current system is back up before rebooting the next one
# Last Edit: Creation
# Date of last edit: see git log

reboot_systems=$(cat /home/pengels/configs/reboot_list.txt)

# Print the date for log purposes
echo -e "\n####################################################\n Starting reboot on $(date)\n####################################################\n"

# Loop through all of the systems in the list in the specified order
for system in ${reboot_systems}
do
	# Print the name for more intuitive output
        echo ${system}

	# maximum of 36 tries (3 minutes)
	counter=0

	# Reboot the system
	# This leaves a 255 retcode so the while loop will work
        ssh -o ConnectTimeout=10 ${system} "sudo reboot"

	# Keep attempting to login every 5 seconds until it works or 3 mins has passed
	# ${?} will be 0 if the machine is up and it was able to log in
	# Otherwise, it will try again
	while [ ${?} -ne 0 ]
	do
		# Wait 10 seconds
		sleep 5

		# Print a '.' so it's obvious it's working 
		echo -n '.'

		# If the counter is greater than 36, give up on this host
		counter=$((${counter}+1))
		echo "Try number ${counter}"
		if [ ${counter} -gt 36 ]
		then
			break
		fi
		# SSH to the system with an immediate disconnect (retcode 0 on success, 255 on failure)
		ssh ${system} "exit"

	done
	# Just print a newline so the print system name at the top of the loop isn't on the same line as the dots
	echo ''
done

# I would put a finished at $(date) thing here, but the script never gets to complete because it reboots the machine it's running on last (lol)
