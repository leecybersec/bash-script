#!/bin/bash

ip="$(ifconfig | grep eth0 -C 1 | grep inet | cut -f10 -d' ')"

name=`whoami`

echo "I'm $name"

echo "My IP is $ip"

echo "Command: ping -c 2 $ip"

ping -c 2 $ip

