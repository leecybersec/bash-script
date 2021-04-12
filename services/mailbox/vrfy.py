#!/usr/bin/python

import socket
import sys

if len(sys.argv) != 3:

	print "Usage: vrfy.py <username> <password>"

	sys.exit(0)

# Create a Socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect to the Server
connect = s.connect(('192.168.11.141',4555))

# Receive the banner
banner = s.recv(2048)
print banner

# VRFY a user
# s.send('VRFY ' + sys.argv[1] + '\r\n')
s.send(sys.argv[1] + '\n')
result = s.recv(2048)
print result

s.send(sys.argv[2] + '\n')

result = s.recv(2048)
print result

# Close the socket
s.close()