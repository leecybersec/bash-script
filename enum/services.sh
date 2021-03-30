#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $1 ]; then
	echo "Usage: $0 <host> <serv> <port>"
	exit
else
	host=$1
	serv=$2
	port=$3
fi

enum_open_service ()
{
	printf "\n${YELLOW}### Services Enumeration ############################\n${NC}"

	echo "nmap -sC -sV -Pn $1 -p$2"
	nmap -sC -sV $host -p$ports
}

enum_smtp_service ()
{
	printf "\n${YELLOW}### SMTP Enumeration ($port) ############################\n${NC}"

	echo "nmap $host -p$port -Pn --script=smtp-*"
	nmap $host -p$port --script=smtp-*
}

enum_web_service ()
{
	printf "\n${YELLOW}### Web Enumeration ($port) ############################\n${NC}"

	printf "\n${GREEN}[+] Files and directories\n${NC}"
	echo "gobuster dir -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/common.txt"
	gobuster dir -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/common.txt

	printf "\n${GREEN}[+] All URLs\n${NC}"
	curl -k $url:$port -s -L | grep "title\|href" | sed -e 's/^[[:space:]]*//'
}

enum_smb_service ()
{
	printf "\n${YELLOW}### SMB Enumeration ($port) ############################\n${NC}"

	echo "smbmap -H $host"
	smbmap -H $host

	echo "smbclient -L $host"
	smbclient -NL $host
}

enum_services ()
{
	if [ $serv = "smtp" ]; then

		enum_smtp_service $host $port

	elif [ $serv = "http" ]; then

		url="http://$host"
		enum_web_service $url $port

	elif [ $serv = "https" ]; then

		url="https://$host"
		enum_web_service $url $port

	elif [ $serv = "smb" ]; then

		enum_smb_service $host $port

	fi
}

main ()
{	
	enum_open_service $host $port

	enum_services $host $port $serv
}

main