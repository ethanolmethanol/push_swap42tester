#!/bin/bash
perm() {
	items="$1"
	out="$2"
	[[ "$items" == "" ]] && echo "$out" && return
	for (( i=0; i<${#items}; i++ )) ; do
	( perm "${items:0:i}${items:i+1}" "$out${items:i:1}" )
	done
}

fact() {
	num=$(expr $(echo $1 |wc -m) - 1)
	fact=1
	while [ $num -gt 1 ]
	do
	fact=$((fact * num))  #fact = fact * num
	num=$((num - 1))      #num = num - 1
	done
	echo "$fact" && return
}

checkallperms() {
	s=0
	for n in $(perm $1)
	do
		a=$(echo $n | sed 's/./& /g')
		b=$(echo ./push_swap $a | tr '\0' ' ')
		c=$(./push_swap $a | ./checker_linux $a)
		o=$($b |wc -l)
		if [ $o -gt $2 ] || [ "$c" != "OK" ]; then
			echo "Failed for $n: $o operations (max is $2), checker is $c"
			((s=s+1))
		else
			:
		fi
	done
	if [ $s -eq 0 ]; then
		echo "Success for all $(fact $1) permutations of $1 :)"
	else
		echo "Failed $s out of $(fact $1) permutations of $1 :("
	fi
}

randomizer() {
	seq $1 $2 | shuf | tr '\n' ' ' | sed -r 's/.$//'
}

checkrange() {
	s=0
	m=0
	h=0
	for (( n=0; n<$3; n++))
	do
		a=$(randomizer $1 $2)
		b=$(echo ./push_swap $a | tr '\0' ' ')
		c=$(./push_swap $a | ./checker_linux $a)
		o=$($b |wc -l)
		((m=m+o))
		if [ $o -gt $h ]; then h=$o; fi
		echo "Test #$n $o operations - $c" >> log.txt #| tee -a
		echo "Number sequence: [$a]" >> log.txt
		if [ -n $c ] && [ $c = "OK" ]; then ((s=s+1)); else echo $a; fi
		clear
		echo "$(( $m / ($n + 1) )) mean nb of operations"
		echo "$h highest nb of operations"
		echo "$(( 100 * $s / ($n + 1) )) % success rate ($s/$(( $n + 1 )))"
	done
	if [ $s -eq $3 ]; then
		echo "Success for all $3 tests :)"
	else
		echo "Failed $(expr $3 - $s)/$3 tests :("
	fi
}
# while read line ; do perm $line ; done < File
# echo $(perm 123) | tr ' ' '\n' | tr '' ' '
#./push_swap $(./randomizer.sh 0 10)

echo "Hello !"

if [ $# -eq 0 ]; then
	echo "No arguments supplied, testing for all permutations of 3 and 5 numbers !"
	checkallperms "123" 3
	checkallperms "12345" 12
	exit 0
elif [ $# -eq 3 ]; then
	rm -f log.txt
	checkrange $1 $2 $3
	echo "More details in log.txt file !"
	exit 0
else
	echo "Invalid arguments." 
	echo "Usage : ./emistester.sh <a> <b> <c>"
	echo "Where a-b is the range of numbers to shuffle and input in push_swap"
	echo "And c is the number of times the test will be executed"
	exit 1
fi


