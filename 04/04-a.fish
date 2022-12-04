#!/usr/bin/env fish

set total 0

while read line
	set elves (string split ',' $line)
	set elf1 (string split '-' $elves[1])
	set elf2 (string split '-' $elves[2])

	# Given a-b x-y, fully contained iff
	# (a < x AND b > y) OR (x < a AND y > b)

	if test $elf1[1] -le $elf2[1] -a $elf1[2] -ge $elf2[2]
		or test $elf2[1] -le $elf1[1] -a $elf2[2] -ge $elf1[2]
		set total (math $total + 1)
	end
end

echo $total
