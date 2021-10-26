#!/bin/bash

## Declare our variables
systems=$(cat /home/pengels/configs/all_systems.txt)

for system in ${systems}
do
	ssh ${system} 
done
