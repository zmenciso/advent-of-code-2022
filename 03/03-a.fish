#!/usr/bin/env fish

set priorities a b c d e f g h i j k l m n o p q r s t u v w x y z \
	A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

set sum 0

while read line
	# Create rucksacks
	set midpoint (math (string length $line) / 2)
	set ruck1 (string sub -l $midpoint $line)
	set ruck2 (string sub -s (math $midpoint + 1) $line)

	# Find repeated character
	set duplicate (string match -r "[$ruck1]" $ruck2)
	set value (contains -i $duplicate $priorities)

	set sum (math $value + $sum)
end

echo $sum
