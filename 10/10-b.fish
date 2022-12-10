#!/usr/bin/env fish

set noop 1
set addx 2

set -g X 1
set -g i 1

function draw -d 'Render the image'
	set sprite $X (math $X + 1) (math $X + 2)

	if contains (math $i % 40) $sprite
		echo -n '#'
	else
		echo -n '.'
	end

	# Start a new line
	if test (math $i % 40) -eq 0
		echo
	end
end

while read line
	set line (string split ' ' $line)

	# Keep track of cycles
	for j in (seq $$line[1])
		draw

		set i (math $i + 1)
	end

	# Update X
	switch $line[1]
		case addx
			set X (math $X + $line[2])
	end
end
