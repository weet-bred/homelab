#!/bin/bash

# Install these:
# - vim
# - fail2ban
# - ipa-client
# - authselect-compat
# - htop
# - rsyslog

# Configure these:
# - sshd (no root login)
# - dns (point to raspberry pi)
# - hosts file
# - ipa-client
# - enable fail2ban
# authconfig --enablemkhomedir --update
# - create home directory
# - add %admins to the sudoers file
# - configure logging - add this to the /etc/rsyslog.conf:
#   *.* @logging.pengels.local:20514;RSYSLOG_SyslogProtocol23Format

# Add DHCP entry and DNS entry in pfSense

