#!/usr/bin/env fish

set priorities a b c d e f g h i j k l m n o p q r s t u v w x y z \
	A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

set i 1
set sum 0
set group

while read line
	# Build group
	if test $i -lt 3
		set group $group $line
		set i (math $i + 1)

	# Find repeated character
	else
		set group $group $line
		set shortlist (string join (string match -a -r "[$group[1]]" $group[2]))
		set badge (string match -r "[$shortlist]" $group[3])

		# Reset counters
		set i 1
		set group
		set value (contains -i $badge $priorities)
		set sum (math $value + $sum)
	end
end

echo $sum
