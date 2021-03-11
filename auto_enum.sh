#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

enum_all_port ()
{
	echo "nmap -p- --min-rate 1000 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//"
	
	ports=$(nmap -p- --min-rate 1000 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)

	if [ -z $ports ]; then
		printf "${RED}[-]No open port!${NC}"
		exit
	fi
}

enum_open_service ()
{
	echo "nmap -sC -sV -p$2 $1"
	nmap -sC -sV -p$2 $1
}

enum_smtp_service ()
{
	printf "${GREEN}$port\n${NC}"

	echo "nmap $1 -p $2 --script=smtp-*"
	nmap $1 -p $2 --script=smtp-*
}

enum_http_service ()
{
	printf "${GREEN}$port\n${NC}"

	echo "gobuster dir -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://$1:$2"
	gobuster dir -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://$1:$2
}

enum_ssmb_service ()
{
	printf "${GREEN}$port\n${NC}"

	echo "smbmap -H $1"
	smbmap -H $1

	echo "smbclient -L $1"
	smbclient -L $1
}

recon ()
{
	for port in $array_port; do
		if [[ $port = "25" ]]; then
			enum_smtp_service $host $port
		elif [[ $port = "80" ]] || [[ $port = "443" ]]; then
			enum_http_service $host $port
		elif [[ $port = "139" ]] || [[ $port = "445" ]]; then
			enum_smb_service $host $port
		fi
		printf "${YELLOW}===============================================================\n${NC}"
	done
}

if [ $# -eq 0 ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
	echo "Usage:" $0 "<HOST>"
	exit
else
	host=$1
fi

enum_all_port $host

printf "${GREEN}[+] $ports\n${NC}"

enum_open_service $host $ports

array_port=$(echo $ports | tr ',' '\n')

recon $array_port