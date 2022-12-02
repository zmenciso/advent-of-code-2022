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

	set w (math "($argv[1] + 1) % 3")
	set l (math "($argv[1] - 1) % 3")
	# Fix underflow
	if test $l -lt 0
		set l 2
	end

	if test $argv[2] -eq $w
		set outcome $win
	else if test $argv[2] -eq $l
		set outcome $lose
	else if test $argv[2] -eq $argv[1]
		set outcome $draw
	else
		echo "Wtf is this"
	end

	# Adjust for 0-index
	echo (math $outcome + 1)

end


# Main Execution

set sum 0

while read line
	set match (decode_letter (string split ' ' $line))
	set match (string split ' ' $match)
	set points (math (calc_points $match) + $match[2])

	set sum (math $points + $sum)
end

echo $sum
