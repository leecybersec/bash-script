#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
origIFS="${IFS}"

if [ -z $1 ]; then
	echo "Usage: $0 <host>"
	exit
else
	host=$1
	ports=$2
fi

enum_all_port ()
{
	if [ -z $ports ]; then

		printf "\n${YELLOW}### Port Scanning ############################\n${NC}"

		printf "\n${GREEN}[+] UDP if any\n${NC}"
		echo "nmap -sU -Pn -p- --min-rate 1000 $host"

		printf "\n${GREEN}[+] TCP Port Scanning\n${NC}"
		echo "nmap -sS -Pn -p- --min-rate 1000 $host"

		ports=$(nmap -sS -Pn -p- --min-rate 1000 $host | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)

		if [ -z $ports ]; then
			printf "${RED}[-] Found no open port!${NC}"
			exit
		else
			printf "${GREEN}\n[+] Openning ports: $ports\n${NC}"
			array_ports=$(echo $ports | tr ',' '\n')
		fi

	else
		printf "${GREEN}\n### Enum ports from input: $ports\n${NC}"

	fi
}

enum_open_service ()
{
	printf "\n${YELLOW}### Services Enumeration ############################\n${NC}"

	echo "nmap -sC -sV -Pn $1 -p$2"
	nmap -sC -sV $host -p$ports
}

enum_smtp_service ()
{
	printf "\n${YELLOW}### SMTP Enumeration ($port) ############################\n${NC}"

	echo "nmap $host -p$port --script=smtp-*"
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

	printf "\n${GREEN}[+] Header\n${NC}"
	curl -k -I $url:$port

	printf "\n${GREEN}[+] All URLs\n${NC}"
	curl -k $url:$port -s -L | grep "title\|href\|file" | sed -e 's/^[[:space:]]*//'

	printf "\n${GREEN}[+] Nikto Enum\n${NC}"
	echo "nikto -h $host:$port"

	printf "\n${GREEN}[+] Virtual Hosting\n${NC}"
	echo "ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -u http://$host -H 'Host: FUZZ.$host' -fw number"

	printf "\n${GREEN}[+] Other Wordlists\n${NC}"
	echo "gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/big.txt &"
	echo "gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/common.txt &"
	echo "gobuster dir -q -e -k -u $url:$port -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files-lowercase.txt &"

	printf "\n${GREEN}[+] Using ffuf\n${NC}"
	echo "ffuf -s -w /usr/share/seclists/Discovery/Web-Content/common.txt -u $url:$port/FUZZ &"
	echo "ffuf -s -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files-lowercase.txt -u $url:$port/FUZZ &"
	echo "ffuf -s -w /usr/share/seclists/Discovery/Web-Content/big.txt -u $url:$port/FUZZ &"
	echo "ffuf -s -w /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt -u $url:$port/FUZZ &"

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

enum_snmp_service ()
{
	printf "\n${YELLOW}### SNMP Enumeration ($port) ############################\n${NC}"

	echo "snmp-check $host -p $port"
	snmp-check $host -p $port
}

enum_smb_service ()
{
	printf "\n${YELLOW}### SMB Enumeration ($port) ############################\n${NC}"

	echo "smbmap -H $host"
	smbmap -H $host -P $port -u guest

	echo "smbclient -L $host"
	smbclient -NL $host -p $port

	printf "\n${GREEN}[+] Nmap Vul Script\n${NC}"
	echo "nmap --script smb-vul* $host -p $port"
	nmap --script smb-vul* $host -p $port
}

enum_services ()
{
	for port in $array_ports; do
		if [ $port = "25" ]; then

			enum_smtp_service $host $port

		elif [ $port = "53" ]; then

			enum_dns_service $url $port

		elif [ $port = "80" ]; then

			url="http://$host"
			enum_web_service $url $host $port

		elif [ $port = "443" ]; then

			url="https://$host"
			enum_web_service $url $host $port

		elif [ $port = "111" ]; then

			enum_rpc_service $url $host $port
		
		elif [ $port = "161" ]; then

			enum_snmp_service $host $port

		elif [ $port = "445" ]; then

			enum_smb_service $host $port

		fi
	done
}

main ()
{
	enum_all_port $host $ports
	
	enum_open_service $host $ports

	enum_services $host $array_ports
}

main