#!/usr/bin/env fish

set n 0
set i 1

while read line
	# Parsing crates
	if string match -q -r '\[' $line
		while test (math "$i + (3 x ($i - 1))") -lt (string length $line)
			set crate (string sub -s (math "$i + (3 x ($i - 1))") -l 3 $line)
			set -g $i $$i $crate
			set i (math $i + 1)
		end

	# Parsing move instructions
	else if string match -q -r '[a-z]' $line
		echo 'skip'

	# Parsing stacks
	else if string match -q -r '[0-9]' $line
		set n (math max (string join ',' (string split -n ' ' $line)))
	end

	set i 1
end

for i in 1 2 3 4 
	echo $$i
end
