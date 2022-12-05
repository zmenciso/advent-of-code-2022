#!/usr/bin/env fish

set n 0
set i 1

function find_top -d 'Returns index for top crate of stack'
	for j in (seq $n -1 1)
		if string match -r -q '\[' $argv[$j]
			echo $j
			break
		end
	end
end

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
		set inst (string match -r -g 'move ([0-9]+) from ([0-9]+) to ([0-9]+)' $line)

		# Move crates
		set $inst[3] $$inst[3] $$inst[2][(math (count $$inst[2]) - $inst[1] + 1)..-1]
		set -e $inst[2][(math (count $$inst[2]) - $inst[1] + 1)..-1]

	# Parsing stacks
	else if string match -q -r '[0-9]' $line
		set n (math max (string join ',' (string split -n ' ' $line)))

		for stack in (seq $n)
			# Reverse lists so they can grow
			set -g $stack $$stack[1..-1][-1..1]
			# Remove spaces
			set -g $stack $$stack[1..-1][1..(find_top $$stack)]
		end
	end

	set i 1
end

# Print final stacks
for i in (seq $n)
	echo $i ' | ' $$i
end

# Print top of final stacks
for i in (seq $n)
	echo -n (string trim -c '[]' $$i[-1][-1])
end
