#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $2 ]; then
	printf "\n${RED}[+] Usage:${NC} $0 <IP> <TopPort>\n"
	printf "\n${YELLOW}Example:${NC} $0 192.168.11.140 100"
	exit
fi

printf "\n${YELLOW}Scanning Top $2 TCP port ...\n${NC}"

ports=$(nmap --top-ports $2 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)

if [ -z $ports ]; then
	printf "${RED}[-] Found no open port!${NC}"
	exit
else
	printf "${GREEN}[+] Openning ports: $ports\n${NC}"
fi
