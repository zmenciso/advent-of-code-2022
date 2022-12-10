#!/usr/bin/env fish

set noop 1
set addx 2

set X 1
set i 1
set T 20	# Target
set signal	# List of signal strengths

while read line
	set line (string split ' ' $line)

	# Keep track of cycles
	for j in (seq $$line[1])
		# Capture signal strength
		if test $i -eq $T
			set signal $signal (math $i x $X)
			set T (math $T + 40)
		end

		set i (math $i + 1)
	end

	# Update X
	switch $line[1]
		case addx
			set X (math $X + $line[2])
	end
end

echo $signal
echo (math (string join -- '+' $signal))
