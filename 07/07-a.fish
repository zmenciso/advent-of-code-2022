#!/usr/bin/env fish

# Global Variables
set MAX 100000

set BASEDIR (mktemp -d)
cd $BASEDIR

# Functions
function du --description 'du, but for files with the size as the name?'
	for f in (find $argv[1] -type d)
		printf '%s ' (string replace $argv[1] '' $f)
		math (string join '+' (find $f -type f -exec basename {} \;))
	end
end

while read line
	set line (string split ' ' $line)

	# cd
	if test $line[1] = '$' -a $line[2] = 'cd'
	and test $line[3] != '/'
		eval $line[2..3]

	# Directory
	else if test $line[1] = 'dir'
		mkdir $line[2]

	# File
	else if string match -r -q '[0-9]+' $line[1]
		touch $line[1]

	end
end

set sum

# Calculate sizes
for line in (du $BASEDIR)
	set line (string split ' ' $line)

	if test $line[2] -le $MAX
		set sum (math $sum + $line[2])
	end
end

echo $sum
rm -rf $BASEDIR
