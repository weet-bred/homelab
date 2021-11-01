#!/bin/bash
# This script simply allows a one-command ssh to all the systems in case I want to edit a config file or something on all machines
# Last Edit: adding documentation
# Date of last edit: see git log

## Declare our variables
systems=$(cat /home/pengels/configs/all_systems.txt)

# SSH to the systems one at a time
for system in ${systems}
do
	echo ${system}
	ssh -o ConnectTimeout=10 ${system} "${1}"
done
