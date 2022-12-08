#!/usr/bin/env fish

set i 1

# Read in input
while read line
	set $i $line
	set i (math $i + 1)
end

set N (string length $1)
set M (math $i - 1)
set sum 0

# HERP DERP
# Basically a double for that executes 4 for loops each time, but with early 
# exists to salvage some runtime
for x in (seq 2 (math $N - 1))
    for y in (seq 2 (math $M - 1))
        set num (string sub -s $x -l 1 $$y)

		# Check left
		for i in (seq 1 (math $x - 1))
			if test $num -le (string sub -s $i -l 1 $$y)
				set hidden
				break
			end

			set -e hidden
		end

		# Early exit
		if not set -q hidden
			set sum (math $sum + 1)
			continue
		end

		# Check right
		for i in (seq (math $x + 1) $N)
			if test $num -le (string sub -s $i -l 1 $$y)
				set hidden
				break
			end
			
			set -e hidden
		end

		# Early exit
		if not set -q hidden
			set sum (math $sum + 1)
			continue
		end

		# Check down
		for i in (seq 1 (math $y - 1))
			if test $num -le (string sub -s $x -l 1 $$i)
				set hidden
				break
			end

			set -e hidden
		end

		# Early exit
		if not set -q hidden
			set sum (math $sum + 1)
			continue
		end

		# Check up
		for i in (seq (math $y + 1) $M)
			if test $num -le (string sub -s $x -l 1 $$i)
				set hidden
				break
			end

			set -e hidden
		end

		if not set -q hidden
			set sum (math $sum + 1)
		end
	end
end

# Add perimeter to sum
math "$sum + (2 x $N) + (2 x ($M - 2))"
