#!/usr/bin/env python3

import fileinput
import re

# regexes for deleting the whole line
del_line = ['M.*']

# regexes for simply removing the match
del_match = ['A[0-9.-]+']

for line in fileinput.input(inplace=True, backup='.bak'):
	for entry in del_line:
		p = re.compile(entry)
		if p.match(line):
			line = ''
	for entry in del_match:
		p = re.compile(entry)
		line = p.sub('', line)
	print(line, end='', flush=True)
