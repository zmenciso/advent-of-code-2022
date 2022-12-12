#!/usr/bin/env fish

set HEIGHTS a b c d e f g h i j k l m n o p q r s t u v w x y z

# Build map
set c 1
set N
set START
set END
set map

while read line
	for i in (seq (string length $line))
		set char (string sub -s $i -l 1 $line)

		switch $char
			case E
				set END $c
				set map[$c] 26
			case S
				set START $c
				set map[$c] 1
			case '*'
				set map[$c] (contains -i $char $HEIGHTS)
		end

		set c (math $c + 1)
	end

	set N (string length $line)
end

# Convert map into a graph (adj list)
set top (seq 1 $N)
set bottom (seq (math (count $map) - $N + 1) (count $map))
set left (seq 1 $N (count $map))
set right (seq $N $N (count $map))

for i in (seq (count $map))
	set num $map[$i]

	# Check above
	if not contains $i $top
	and test (math $map[(math $i - $N)] - $num) -le 1
		set -g $i $$i (math $i - $N)
	end

	# Check below
	if not contains $i $bottom
	and test (math $map[(math $i + $N)] - $num) -le 1
		set -g $i $$i (math $i + $N)
	end

	# Check left
	if not contains $i $left
	and test (math $map[(math $i - 1)] - $num) -le 1
		set -g $i $$i (math $i - 1)
	end

	# Check right
	if not contains $i $right
	and test (math $map[(math $i + 1)] - $num) -le 1
		set -g $i $$i (math $i + 1)
	end
end

for i in (seq (count $map))
	echo "$i : $$i"
end

# Do BFS
# https://en.wikipedia.org/wiki/Breadth-first_search
set q $START
set explored $START
for i in (seq (count $map))
	set parent[$i] 0
end

while test -n "$q"
	set v $q[-1]
	set -e q[-1]

	if test $v -eq $END
		echo "Reached goal: $END"
		break
	end

	for w in $$v
		if not contains $w $explored
			set explored $explored $w
			set parent[$w] $v
			set q $q $w
		end
	end
end

# Retrace the path
set i $END
set sum 0

while test $i -ne $START
	if test $i -eq 0
		exit 1
	end

	set i $parent[$i]
	set sum (math $sum + 1)
end

echo "Total steps: $sum"
