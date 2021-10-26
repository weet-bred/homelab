#!/bin/bash

## Declare our variables
dnf_systems=$(cat /home/pengels/configs/dnf_systems.txt)
apt_systems=$(cat /home/pengels/configs/apt_systems.txt)

for system in ${dnf_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=8 ${system} "sudo dnf update -y"
done

for system in ${apt_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=8 ${system} "sudo apt update -y"
	ssh -o ConnectTimeout=8 ${system} "sudo apt updgrade -y"
done

# Special Software

echo "raspberrypi.pengels.local"
ssh -o ConnectTimeout=8 raspberrypi.pengels.local "sudo pihole -up"
echo "fujitsu.pengels.local"
ssh -o ConnectTimeout=8 fujitsu.pengels.local "sudo suricata-update"
