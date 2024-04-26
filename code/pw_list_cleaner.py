#! /usr/bin/python3

### This script will pull the first 100 passwords from rockyou.txt
### that meet Active Directory's default pw requirements

import re
password_list = []
counter = 0

with open("rockyou.txt") as file:
	for line in file:
		if re.search(r"^(?=.*\d)(?=.*[#$@!%&*?])[A-Za-z\d#$@!%&*?]{8,}$", line):
			password_list.append(line)
			counter += 1
		if counter == 500:
			break
	for item in password_list:
		print(item.strip('\n'))