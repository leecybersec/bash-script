#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $1 ]; then
	echo "Usage: $0 <url>"
	exit
else
	url=$1
fi

enum_web_service ()
{
	printf "\n${YELLOW}### Web Enumeration ($url) ############################\n${NC}"

	file1='/usr/share/seclists/Discovery/Web-Content/big.txt'
	file2='/usr/share/seclists/Discovery/Web-Content/common.txt'
	file3='/usr/share/seclists/Discovery/Web-Content/raft-medium-files-lowercase.txt'
	file4='/usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt'
	file5='/usr/share/seclists/Discovery/Web-Content/raft-medium-directories-lowercase.txt'

	printf "\n${GREEN}[+] Ffuf\n${NC}"
	for file in $file{1..5}; do echo "ffuf -s -u \"$url/FUZZ\" -w $file -fs \$size &"; done

	printf "\n${GREEN}[+] Gobuster\n${NC}"
	for file in $file{1..5}; do echo "gobuster dir -q -e -k -u $url -w $file &"; done
}

enum_web_service url