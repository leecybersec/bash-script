#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

enum_all_port ()
{
	echo "nmap -sS -p- --min-rate 1000 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//"
	
	ports=$(nmap -sS -p- --min-rate 1000 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)

	if [ -z $ports ]; then
		printf "${RED}[-]Found no port!${NC}"
		exit
	fi
}

enum_open_service ()
{
	echo "nmap -sC -sV $1 -p$2"
	nmap -sC -sV $1 -p$2
}

enum_smtp_service ()
{
	printf "${YELLOW}===============================$port===============================\n${NC}"

	echo "nmap $host -p$port --script=smtp-*"
	nmap $host -p$port --script=smtp-*
}

enum_http_service ()
{
	printf "${YELLOW}===============================$port===============================\n${NC}"

	echo "gobuster dir -u http://$host:$port -w /usr/share/seclists/Discovery/Web-Content/common.txt"
	gobuster dir -u http://$host:$port -w /usr/share/seclists/Discovery/Web-Content/common.txt
}

enum_smb_service ()
{
	printf "${YELLOW}===============================$port===============================\n${NC}"

	echo "smbmap -H $host"
	smbmap -H $1

	echo "smbclient -L $host"
	smbclient -L $1
}

recon ()
{
	for port in $array_port; do
		
		case $port in

			"25")
				enum_smtp_service $host $port
			;;

			"80" | "443")
				enum_http_service $host $port
			;;

			"139" | "445")
				enum_smb_service $host $port
			;;

			*)
				printf "\n"
			;;
		esac
	done
}

if [ $# -eq 0 ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
	echo "Usage: $0 <HOST>"
	exit
else
	host=$1
fi

enum_all_port $host

printf "${GREEN}[+] $ports\n${NC}"

enum_open_service $host $ports

array_port=$(echo $ports | tr ',' '\n')

recon $array_port