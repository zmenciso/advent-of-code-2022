#!/usr/bin/env fish

set i 1

# Read in input
while read line
	set $i $line
	set i (math $i + 1)
end

set N (string length $1)
set M (math $i - 1)
set scores
set scenic

# HERP DERP
# No need to check edges because they see 0 trees and thus always get a scenic
# score of 0
for x in (seq 2 (math $N - 1))
    for y in (seq 2 (math $M - 1))
        set num (string sub -s $x -l 1 $$y)

		# Check left
		for i in (seq (math $x - 1) -1 1)
			if test $num -le (string sub -s $i -l 1 $$y)
				set scenic $scenic (math $x - $i)
				break
			end
		end

		# See all the way to the end
		if test (count $scenic) -lt 1
			set scenic $scenic (math $x - 1)
		end

		# Check right
		for i in (seq (math $x + 1) $N)
			if test $num -le (string sub -s $i -l 1 $$y)
				set scenic $scenic (math $i - $x)
				break
			end
		end

		# See all the way to the end
		if test (count $scenic) -lt 2
			set scenic $scenic (math $N - $x)
		end

		# Check down
		for i in (seq (math $y - 1) -1 1)
			if test $num -le (string sub -s $x -l 1 $$i)
				set scenic $scenic (math $y - $i)
				break
			end
		end

		# See all the way to the end
		if test (count $scenic) -lt 3
			set scenic $scenic (math $y - 1)
		end

		# Check up
		for i in (seq (math $y + 1) $M)
			if test $num -le (string sub -s $x -l 1 $$i)
				set scenic $scenic (math $i - $y)
				break
			end
		end

		# See all the way to the end
		if test (count $scenic) -lt 4
			set scenic $scenic (math $M - $y)
		end

		# echo "$x,$y | $num | $scenic |" (math (string join ' x ' $scenic))
		set scores $scores (math (string join ' x ' $scenic))
		set scenic
	end
end

math max (string join ',' $scores)
