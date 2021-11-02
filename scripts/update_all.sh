#!/bin/bash
# This script runs updated commands for all the systems and applications in my homelab
# It's meant to be in a cronjob run daily
# Last Edit: adding yum support and fixing typos
# Date of last edit: see git log


## Declare our variables
## Each of these files is manually maintained, but it works okay for this small environment

# All the systems using the dnf package manager
dnf_systems=$(cat /home/pengels/configs/dnf_systems.txt)
# All the systems using the apt package manager
apt_systems=$(cat /home/pengels/configs/apt_systems.txt)
# All the systems using the yum package manager
yum_systems=$(cat /home/pengels/configs/yum_systems.txt)

# All the systems running suricata
suricata_systems=$(cat /home/pengels/configs/suricata_systems.txt)
# All the systems running openvas
openvas_systems=$(cat /home/pengels/configs/openvas_systems.txt)
# All the systems running pihole
pihole_systems=$(cat /home/pengels/configs/pihole_systems.txt)

# Print the date for log purposes
echo -e "\n####################################################\n Starting update on $(date)\n####################################################\n"

# Run package updates on the dnf systems
for system in ${dnf_systems}
do
	echo -e "\n${system} sudo dnf update -y"
	ssh -o ConnectTimeout=10 ${system} "sudo dnf update -y"
	echo -e "Retcode=${?}"
done

# Run package updates on the yum systems
for system in ${yum_systems}
do
	echo -e "\n${system} sudo yum update -y"
	ssh -o ConnectTimeout=10 ${system} "sudo yum update -y"
	echo -e "Retcode=${?}"
done

# Run package updates on the apt systems
for system in ${apt_systems}
do
	# Update package list 
	echo -e "\n${system} sudo apt-get update -y"
	ssh -o ConnectTimeout=10 ${system} "sudo apt-get update -y"
	echo -e "Retcode=${?}"

	# Update packages
	echo -e "\n${system} sudo apt-get upgrade -y"
	ssh -o ConnectTimeout=10 ${system} "sudo apt-get upgrade -y -q"
	echo -e "Retcode=${?}"

	# Remove unneeded packages
	echo -e "\n${system} sudo apt-get upgrade -y"
	echo -e "\n${system} sudo apt-get autoremove -y"
	ssh -o ConnectTimeout=10 ${system} "sudo apt-get autoremove -y -q"
	echo -e "Retcode=${?}"
done

# Special Software

for system in ${pihole_systems}
do
	echo ${system}
	# Update pihole, FTL, and the web interface
	echo -e "\n${system} sudo pihole -up"
	ssh -o ConnectTimeout=10 ${system} "sudo pihole -up"
	echo -e "Retcode=${?}"

	# Update the domains in the block lists
	echo -e "\n${system} sudo pihole updateGravity"
	ssh -o ConnectTimeout=10 ${system} "sudo pihole updateGravity"
	echo -e "Retcode=${?}"
done

for system in ${suricata_systems}
do
	# Update definitions. The suricata package is managed by the system package manager
	echo -e "\n${system} sudo suricata-update"
	ssh -o ConnectTimeout=10 ${system} "sudo suricata-update"
	echo -e "Retcode=${?}"
done

for system in ${openvas_systems}
do
	# Update all the backend data that openvas uses
	echo -e "\n${system} greenbone-certdata-sync"
	ssh -o ConnectTimeout=10 ${system} "greenbone-certdata-sync"
	echo -e "Retcode=${?}"

	echo -e "\n${system} sudo su - gvm -c 'greenbone-nvt-sync --curl --verbose'"
	ssh -o ConnectTimeout=10 ${system} "greenbone-nvt-sync"
	echo -e "Retcode=${?}"

	echo -e "\n${system} greenbone-scapdata-sync"
	ssh -o ConnectTimeout=10 ${system} "greenbone-scapdata-sync"
	echo -e "Retcode=${?}"
done

echo -e "\n####################################################\n Ending update on $(date)\n####################################################\n"
