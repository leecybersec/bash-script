#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $2 ]; then
	printf "\n${RED}[+] Usage:${NC} $0 <IP> <Protocol>\n"
	printf "\n${YELLOW}Example:${NC} $0 192.168.11.140 TCP"
	exit
fi

if [[ $2 = "TCP" ]]; then

	printf "\n${YELLOW}Scanning TCP port ...\n${NC}"
	echo "nc -nv -w 1 -z $1 1-65535"
	nc -nv -w 1 -z $1 1-65535

elif [[ $2 = "UDP" ]]; then

	printf "\n${YELLOW}Scanning UDP port ...\n${NC}"
	echo "nc -nv -w 1 -z -u $1 1-65535"
	nc -nv -w 1 -z -u $1 1-65535

else

	printf "${RED}\n[-] Invalid Protocol. Input TCP or UDP${NC}"
fi
