#!/usr/bin/env fish

set win 6
set draw 3
set lose 0

function decode_letter -d "Takes in letter and returns corresponding shape"
	set outcome

	for arg in $argv
		switch (string lower $arg)
			case a x	# Rock
				set outcome $outcome 0
			case b y	# Paper
				set outcome $outcome 1
			case c z	# Scissors
				set outcome $outcome 2
		end
	end

	echo $outcome
end

function calc_points -d "Given match, returns number of points"
	set outcome 0

	# Lose
	if test $argv[2] -eq 0
		set outcome (math "($argv[1] - 1) % 3")
		# Fix underflow
		if test $outcome -lt 0
			set outcome 2
		end

	#Draw 
	else if test $argv[2] -eq 1
		set outcome (math $argv[1] + $draw)

	# Win
	else if test $argv[2] -eq 2
		set outcome (math "($argv[1] + 1) % 3 + $win")

	else 
		echo "Wtf is this"

	end

	# Adjust for 0-index
	echo (math $outcome + 1)
end


# Main Execution

set sum 0

while read line
	set match (string split ' ' (decode_letter (string split ' ' $line)))
	set points (calc_points $match)

	set sum (math $points + $sum)
end

echo $sum
