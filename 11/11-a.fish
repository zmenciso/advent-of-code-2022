#!/usr/bin/env fish

# Globals
set ROUNDS 20
set ALPHA_MONKEY 7


# Functions
function monkey_debug -d 'Prints every monkey\'s items'
	for i in (seq 0 $ALPHA_MONKEY)
		echo "$i : $$i"
	end
end

function monkey_business -d 'Prints inspection counts'
	for i in (seq (count $monkey_business))
		echo "Monkey" (math $i - 1) "inspected items" $monkey_business[$i] "times."
	end
end

function inspect -d 'inspect WORRY OPERATION AMOUNT'
	set worry $argv[1]
	set op $argv[2]
	set amt $argv[3]

	if test "$amt" = 'old'
		set amt $worry
	end

	math "floor(($worry $op $amt) / 3)"
end

function update_monkey -d 'update_monkey MONKEY OP AMT DIVISOR TRUE FALSE'
	set monkey $$argv[1]

	for num in $monkey
		set worry (inspect $num $argv[2] $argv[3])
		set adj_monkey (math $argv[1] + 1)
		set monkey_business[$adj_monkey] (math $monkey_business[$adj_monkey] + 1)

		if test (math $worry % $argv[4]) -eq 0
			set $argv[5] $$argv[5] $worry
		else
			set $argv[6] $$argv[6] $worry
		end
	
		set -e monkey[1]
		set $argv[1] $monkey
	end
end

function sim_monkeys -d 'sim_monkeys INPUT'
	for line in $input
		if string match -r -q 'Monkey' $line
			set monkey (string match -r -g 'Monkey ([0-9]+):' $line)
		else if string match -r -q 'Operation' $line
			set op (string match -r -g 'Operation: new = old (.) (.+)' $line)
		else if string match -r -q 'Test' $line
			set divisor (string split ' ' $line)[-1]
		else if string match -r -q 'true' $line
			set true_monkey (string split ' ' $line)[-1]
		else if string match -r -q 'false' $line
			set false_monkey (string split ' ' $line)[-1]
			update_monkey $monkey $op $divisor $true_monkey $false_monkey
		end
	end
end


# Main execution
set -g input (cat $argv[1] | sed 's/*/x/g')
set -g monkey_business

# Extract starting items
for line in $input
	if string match -r -q 'Monkey' $line
		set monkey (string match -r -g 'Monkey ([0-9]+):' $line)
	else if string match -r -q 'Starting items' $line
		set items (string split ', ' (string match -r -g 'Starting items: (.*)' $line))
	else if string match -r -q 'Operation' $line
		set -g $monkey $items
	end
end

# Simulate monkeys
for i in (seq $ROUNDS)
	sim_monkeys
end

# Print monkeys
monkey_debug
echo
monkey_business
echo

# Print level of monkey business
set top_monkey (math max (string join ',' $monkey_business))
set -e monkey_business[(contains -i $top_monkey $monkey_business)]
math $top_monkey x (math max (string join ',' $monkey_business))
