#!/bin/bash

## Declare our variables
dnf_systems=$(cat /home/pengels/configs/dnf_systems.txt)
apt_systems=$(cat /home/pengels/configs/apt_systems.txt)
suricata_systems=$(cat /home/pengels/configs/suricata_systems.txt)
openvas_systems=$(cat /home/pengels/configs/openvas_systems.txt)
pihole_systems=$(cat /home/pengels/configs/pihole_systems.txt)

for system in ${dnf_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=10 ${system} "sudo dnf update -y"
done

for system in ${apt_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=10 ${system} "sudo apt update -y"
	ssh -o ConnectTimeout=10 ${system} "sudo apt updgrade -y"
done

# Special Software
for system in ${pihole_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=10 ${system} "sudo pihole -up"
done

for system in ${suricata_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=10 ${system} "sudo suricata-update"
done

for system in ${openvas_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-certdata-sync"
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-feed-sync"
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-nvt-sync"
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-scapdata-sync"
done

