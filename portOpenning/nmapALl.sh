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

	printf "\n${YELLOW}Scanning TCP port ... \n${NC}"

	if [[ -z $3 ]]; then
		ports=$(nmap -sS -p- $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)
	else
		printf "\nmin-rate=$3\n"
		ports=$(nmap -sS -p- --min-rate $3 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)
	fi

elif [[ $2 = "UDP" ]]; then

	printf "\n${YELLOW}Scanning UDP port ... \n${NC}"

	if [[ -z $3 ]]; then
		ports=$(nmap -sU -p- $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)
	else
		printf "\nmin-rate=$3\n"
		ports=$(nmap -sU -p- --min-rate $3 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)
	fi

else

	printf "${RED}\n[-] Invalid Protocol. Input TCP or UDP${NC}"

	exit

fi

if [ -z $ports ]; then
	printf "${RED}[-] Found no open port!${NC}"
	exit
else
	printf "${GREEN}[+] Openning ports: $ports\n${NC}"
fi