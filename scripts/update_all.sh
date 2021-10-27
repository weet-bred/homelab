#!/bin/bash
# This script runs updated commands for all the systems and applications in my homelab
# It's meant to be in a cronjob run daily
# Last Edit: adding better documentation in comments
# Date of last edit: see git log


## Declare our variables
## Each of these files is manually maintained, but it works okay

# All the systems using the dnf package manager
dnf_systems=$(cat /home/pengels/configs/dnf_systems.txt)
# All the systems using the apt package manager
apt_systems=$(cat /home/pengels/configs/apt_systems.txt)
# All the systems running suricata
suricata_systems=$(cat /home/pengels/configs/suricata_systems.txt)
# All the systems running openvas
openvas_systems=$(cat /home/pengels/configs/openvas_systems.txt)
# All the systems running pihole
pihole_systems=$(cat /home/pengels/configs/pihole_systems.txt)

# Run package updates on the dnf systems
for system in ${dnf_systems}
do
	echo ${system}
	ssh -o ConnectTimeout=10 ${system} "sudo dnf update -y"
done

# Run package updates on the apt systems
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
	# Update pihole, FTL, and the web interface
	ssh -o ConnectTimeout=10 ${system} "sudo pihole -up"
	# Update the domains in the block lists
	ssh -o ConnectTimeout=10 ${system} "sudo pihole updateGravity"
done

for system in ${suricata_systems}
do
	echo ${system}
	# Update definitions. The suricata package is managed by the system package manager
	ssh -o ConnectTimeout=10 ${system} "sudo suricata-update"
done

for system in ${openvas_systems}
do
	echo ${system}
	# Update all the backend data that openvas uses
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-certdata-sync"
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-feed-sync"
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-nvt-sync"
	ssh -o ConnectTimeout=10 ${system} "sudo greenbone-scapdata-sync"
done
