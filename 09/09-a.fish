#!/usr/bin/env fish

set N 10

# Lists to store the x and y coords that the tail has visited
set -g CRUMBS '0,0'

# Lists to store the x,y coords of all the knots
set -g KNOTS 
for i in (seq $N)
	set KNOTS[$i] '0,0'
end


# Functions
function debug
	for i in (seq (count $argv))
		echo -n "$i:($argv[$i]) | "
	end
	echo
end

function breadcrumb -d 'Save all unique tail coords'
	if not contains -- $argv[1] $CRUMBS
		set CRUMBS $CRUMBS $argv[1]
	end
end

function move -d 'Move head and tail'
	set dir $argv[1]
	set num $argv[2]

	for i in (seq $num)
		# Move head
		set h (string split -- ',' $KNOTS[1])
		switch $dir 
			case L
				set h[1] (math $h[1] - 1)
			case R 
				set h[1] (math $h[1] + 1)
			case D
				set h[2] (math $h[2] - 1)
			case U
				set h[2] (math $h[2] + 1)
			case '*'
				return 1
		end
		set KNOTS[1] (string join -- ',' $h)

		# Move all the tails
		for i in (seq 2 $N)
			set curr (string split -- ',' $KNOTS[$i])
			set chain (string split -- ',' $KNOTS[(math $i - 1)])

			set dx (math $chain[1] - $curr[1])
			set dy (math $chain[2] - $curr[2])

			if test (math abs $dx) -gt 1
			or test (math abs $dy) -gt 1
				set theta (math (math atan2 $dy,$dx) x 180 / pi)
				set theta (math round $theta)

				# Brute force the rules
				if test $theta -eq 0
					set new (math $curr[1] + 1) $curr[2]
				else if test $theta -eq 90
					set new $curr[1] (math $curr[2] + 1)
				else if test $theta -eq 180 -o $theta -eq -180
					set new (math $curr[1] - 1) $curr[2]
				else if test $theta -eq -90
					set new $curr[1] (math $curr[2] - 1)
				else if test $theta -gt 0 -a $theta -lt 90
					set new (math $curr[1] + 1) (math $curr[2] + 1)
				else if test $theta -gt 90 -a $theta -lt 180
					set new (math $curr[1] - 1) (math $curr[2] + 1)
				else if test $theta -lt 0 -a $theta -gt -90
					set new (math $curr[1] + 1) (math $curr[2] - 1)
				else if test $theta -lt -90 -a $theta -gt -180
					set new (math $curr[1] - 1) (math $curr[2] - 1)
				end

				set KNOTS[$i] (string join -- ',' $new)
			else
				break
			end

			if test $i -eq $N
				breadcrumb $KNOTS[$N]
			end
		end

	end
	# debug $KNOTS
end


# Main execution
while read line
	# echo $line
	set line (string split ' ' $line)
	move $line
end

count $CRUMBS
