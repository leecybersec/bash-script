#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $1 ]; then
	printf "\n${RED}[+] Usage:${NC} $0 <IP>\n"
	printf "\n${YELLOW}Example:${NC} $0 192.168.11.140 1000"
	exit
fi

printf "\n${YELLOW}Scanning All TCP port ...\n${NC}"

if [[ $2 = "TCP" ]]; then
	if [ -z $3 ]; then
		masscan -p0-65535 $1
	else
		masscan -p0-65535 $1 --rate $3
	fi

elif [[ $2 = "UDP" ]]; then
	if [ -z $3 ]; then
		masscan -p U:1-65535 $1
	else
		masscan -p U:1-65535 $1 --rate $3
	fi
else
	printf "${RED}\n[-] Invalid Protocol. Input TCP or UDP${NC}"
fi




