#!/usr/bin/env python2 
import os,sys 
 
f = open(sys.argv[1],'r') 
lines = f.read().splitlines() 
 
for line in lines:
	print '7z e {0} -p"{1}"'.format(sys.argv[2],line)
	x = os.system('7z e {0} -p"{1}" > /dev/null'.format(sys.argv[2],line)) 
	if x == 0: 
		print '[~] Password is : {0}\n\n'.format(line) 
		exit(1)

print '[!] Password not found in the provided list!\n\n'