#!/bin/bash

if [ $# -eq 0 ] || [ $1 = "-h" ] || [ $1 = "--help" ]
then
	echo "Usage:" $0 "<HOST>"
	exit
else
	ports=$(nmap -p- --min-rate 1000 $1 | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//)
	
	if [ -z $ports ]
	then
		echo "No open port!"
		exit
	else
		echo "Opening port:" $ports
		nmap -sC -sV -p $ports $1
	fi
fi