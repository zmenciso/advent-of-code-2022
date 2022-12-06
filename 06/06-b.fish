#!/usr/bin/env fish

read -P 'Datastream > ' stream

set W 14

function all_diff
	set chars
	for c in (string split '' $argv[1])
		if contains $c $chars 
			return 1
		end

		set chars $chars $c
	end

	return 0
end

for i in (seq (math (string length $stream) - $W + 1))
	if all_diff (string sub -s $i -l $W $stream)
		echo (math $i + $W - 1)
		break
	end
end
