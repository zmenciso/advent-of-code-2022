#!/usr/bin/env fish

set input (cat $argv[1])

set sum
set elves

for num in $input
    if test -n "$num"
        set sum (math "$sum + $num")
    else
        set elves $sum $elves
        set sum '0'
    end
end

echo (math max (string join , $elves))
