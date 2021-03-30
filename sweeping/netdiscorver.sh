#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $1 ]; then
	printf "\n${RED}[+] Usage: $0 <SubIP>${NC}\n\n"
	printf "\n${YELLOW}Example:${NC} $0 192.168.11"
	exit
fi

netdiscover -r $1.0/24