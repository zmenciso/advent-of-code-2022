#!/usr/bin/env fish

set input (cat $argv[1])

set sum
set -g elves

for num in $input
    if test -n "$num"
        set sum (math "$sum + $num")
    else
        set elves $sum $elves
        set sum 0
    end
end

set sum 0
set num 0

for i in (seq 3) 
	set num (math max (string join , $elves))
	set sum (math $sum + $num)
	set -e elves[(contains -i $num $elves)]
end

echo $sum
