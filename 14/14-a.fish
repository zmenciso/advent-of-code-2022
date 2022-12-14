#!/usr/bin/env fish

set START_X 500
set START_Y 0

set N 0

function spawn_sand -d 'spawn_sand x y'
	set x $argv[1]
	set y $argv[2]

	while true
		# Sand begins to fall forever
		if test $y -gt $N
			return 1
		end

		set y_down (math $y + 1)
		set x_left (math $x - 1)
		set x_right (math $x + 1)

		# Sand falls down first
		if test -z "$$y_down[..][$x]"
			set y $y_down

		# Sand falls left next
		else if test -z "$$y_down[..][$x_left]"
			set y $y_down
			set x $x_left

		# Sand falls right last
		else if test -z "$$y_down[..][$x_right]"
			set y $y_down
			set x $x_right

		# If sand cannot fall, done
		else 
			break

		end
	end

	# Update 
	set -g $y[..][$x] 'o'
	return 0
end

function print -d 'print x1 y1 x2 y2'
	for j in (seq $argv[2] $argv[4])
		for i in (seq $argv[1] $argv[3])
			if test -z "$$j[..][$i]"
				echo -n '.'
			else
				echo -n $$j[..][$i]
			end
		end
		echo
	end
end

# Draw rocks
while read line
	set coords (string split -- ' -> ' $line)
	for coord in $coords
		set coord (string split ',' $coord)

		if not set -q prev_coord
			set prev_coord $coord
			continue
		end

		set x $coord[1]
		set y $coord[2]

		# Track lowest
		if test $y -gt $N
			set N $y
		end

		# Draw line
		for i in (seq $prev_coord[1] $x)
			set -g $y[..][$i] '#'
		end
		for j in (seq $prev_coord[2] $y)
			set -g $j[..][$x] '#'
		end

		set prev_coord $coord
	end

	set -e prev_coord
end

# Simulate the sand falling
set sum 0

while spawn_sand $START_X $START_Y
	set sum (math $sum + 1)
end

echo $sum
