#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $3 ]; then
	echo "Usage: $0 <host> <port> <serv>"
	exit
else
	host=$1
	port=$2
	serv=$3
fi

enum_smtp_service ()
{
	printf "\n${YELLOW}### SMTP Enumeration ($port) ############################\n${NC}"

	echo "nmap $host -p$port -Pn --script=smtp-*"
	nmap $host -p$port --script=smtp-*
}

enum_dns_service ()
{
	printf "\n${YELLOW}### DNS Enumeration ($port) ############################\n${NC}"

	echo "nslookup $host $host"
	nslookup $host $host

	echo "dig version.bind CHAOS TXT $host"
	dig version.bind CHAOS TXT $host

	echo "nmap $host -p$port -n --script \"(default and *dns*) or fcrdns or dns-srv-enum or dns-random-txid or dns-random-srcport\""
	nmap $host -p$port -n --script "(default and *dns*) or fcrdns or dns-srv-enum or dns-random-txid or dns-random-srcport"
}

enum_web_service ()
{
	printf "\n${YELLOW}### Web Enumeration ($port) ############################\n${NC}"

	printf "\n${GREEN}[+] Manual running if any\n${NC}"
	echo "nikto -h $host:$port"
	echo "gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files-lowercase.txt &"
	echo "gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/common.txt &"
	echo "gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/big.txt &"

	printf "\n${GREEN}[+] Header\n${NC}"
	curl -k -I $url:$port

	printf "\n${GREEN}[+] All URLs\n${NC}"
	curl -k $url:$port -s -L | grep "title\|href\|file" | sed -e 's/^[[:space:]]*//'
	
	printf "\n${GREEN}[+] Files and directories\n${NC}"
	echo "gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt"
	
	gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt
}

enum_rpc_service ()
{
	printf "\n${YELLOW}### RPC Enumeration ($port) ############################\n${NC}"

	echo "nmap -p $port --script=nfs-ls,nfs-statfs,nfs-showmount $host"
	nmap -p $port --script=nfs-ls,nfs-statfs,nfs-showmount $host
}

enum_smb_service ()
{
	printf "\n${YELLOW}### SMB Enumeration ($port) ############################\n${NC}"

	echo "smbmap -H $host"
	smbmap -H $host -u guest

	echo "smbclient -L $host"
	smbclient -NL $host
}

enum_services ()
{
	if [ $serv = "smtp" ]; then

		enum_smtp_service $host $port

	elif [ $serv = "dns" ]; then

		enum_dns_service $host $port

	elif [ $serv = "http" ]; then

		url="http://$host"
		enum_web_service $url $host $port

	elif [ $serv = "https" ]; then

		url="https://$host"
		enum_web_service $url $host $port

	elif [ $serv = "rpc" ]; then

		enum_rpc_service $host $port

	elif [ $serv = "smb" ]; then

		enum_smb_service $host $port

	fi
}

main ()
{	
	enum_services $host $port $serv
}

main