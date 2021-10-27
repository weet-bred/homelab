#!/bin/bash
# This script just tries to ssh to the system name given as an argument every 10 seconds
# Useful for rebooting a machine and logging in immediately
# Last Edit: adding documentation in comments
# Date of last edit: see git log


system=${1}

# Print the word 'waiting' just so it looks nice
echo -n 'waiting'

# Continue forever (use CTRL+c to quit)
while [ 1 -eq 1 ]
do
	# Attemp to SSH to the system
	ssh -q -o ConnectTimeout=8 ${system}
	# If it doesn't work, print a dot, wait 2 seconds, and try again
	echo -n '.'
	sleep 2
done
