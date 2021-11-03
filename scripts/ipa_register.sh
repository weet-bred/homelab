#!/bin/bash

#admin_user=$(cat /home/pengels/configs/admin_user.txt)
#admin_pw=$(cat /home/pengels/configs/admin_pw.txt)
#freeipa_server=$(cat /home/pengels/configs/freeipa_servers.txt)
# Set the hostname to something normal
fqdn_lower_hostname=$(hostname | sed 's/.pengels.local//' | tr '[:upper:]' '[:lower:]').pengels.local 
# Register the client with all the options and 
ipa-client-install --domain=pengels.local --server=freeipa.pengels.local --mkhomedir --no-dns-sshfp --fixed-primary --hostname=${fqdn_lower_hostname} --no-ntp --force-join
#ipa-client-install --domain=pengels.local --server=${freeipa_server} --mkhomedir --no-dns-sshfp --fixed-primary --hostname=${fqdn_lower_hostname} --principal ${admin_user} --password=${admin_pw} --no-ntp --force-join
