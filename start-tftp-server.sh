#!/bin/bash

IP_LINK_JSON=$(ip -j link show)
ALL_INTERFACES=$(echo $IP_LINK_JSON | jq -r '.[] | .ifname')
ALL_INTERFACES=$(echo $ALL_INTERFACES | tr ' ' '\n' | grep -v lo)

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

# Check if dnsmasq is installed
if ! [ -x "$(command -v dnsmasq)" ]; then
	echo 'Error: dnsmasq is not installed.' >&2
	exit 1
fi

echo "Please select the interface to start TFTP server on:"
select INTERFACE in $ALL_INTERFACES
do
	echo "Starting TFTP server on $INTERFACE"
	sudo dnsmasq --no-daemon --listen-address=0.0.0.0 --port=0 --enable-tftp="${INTERFACE}" --tftp-root="$(pwd)" --user=root --group=root
	break
done
