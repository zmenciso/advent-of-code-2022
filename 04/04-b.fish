#!/usr/bin/env fish

set total 0

while read line
	set elves (string split ',' $line)
	set elf1 (string split '-' $elves[1])
	set elf2 (string split '-' $elves[2])

	# Given a-b x-y, contains at all iff
	# (b > x) AND (y > a)

	if test $elf1[2] -ge $elf2[1] -a $elf2[2] -ge $elf1[1]
		set total (math $total + 1)
	end
end

echo $total
