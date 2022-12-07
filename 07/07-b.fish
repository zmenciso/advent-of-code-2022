#!/usr/bin/env fish

# Global Variables
set MAX 100000
set TOTAL 70000000
set NEEDED 30000000

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

# Find which dirs to remove
set directories (du $BASEDIR)
set used (string trim $directories[1])
set free (math $TOTAL - $used)
set req (math $NEEDED - $free)

touch candidates
for dir in $directories
	set size (string split ' ' $dir)[2]
	if test $size -gt $req
		echo $size >> candidates
	end
end

cat candidates | sort -n | head -1

rm -rf $BASEDIR
