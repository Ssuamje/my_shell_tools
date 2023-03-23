#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

if [ $# -gt 1 ]; then
	echo -e "Usage : ./random_pick.sh [title]"
	exit 1
fi

#set title
if [ $# -eq 1 ]; then
	title="$1"
else
	title="Random Pick"
fi

length=0
for ((i=0; i<${#title}; i++))
do
    if echo "${title:i:1}" | grep -qE '[가-힣]'
    then
        length=$(($length+2))
    else
        length=$(($length+1))
    fi
done

#set candidates
while true; do
	clear
	candis=$(( ${#candidates[@]} - 1))
	echo -e $GREEN"@___"$title"___@"
	for index in $(seq 0 $candis); do
		if [ $index -gt -1 ]; then
			echo "$((index + 1)): ${candidates[index]}"
		fi
	done
	echo -en "@___"
	for ((i=0; i<$length; i++)); do
	echo -en "_"
	done
	echo -e "___@"$RESET
	echo -e "> : proceed, < [number] : delete candidate"

	read candidate
	if [ "$candidate" == ">" ]; then
		break
	elif [ $(echo $candidate | cut -d' ' -f1) == "<" ]; then
		del=$(echo $candidate | cut -d' ' -f2)
		unset candidates[$(expr $del - 1)]
		declare -a candidates=("${candidates[@]}")
		echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
		clear
	else
		candidates+=("$candidate")
	fi
done

#get random indexes
clear
rand=$(seq 0 $(expr ${#candidates[@]} - 1) | sort -R)

#get number to pick
while true; do
	clear
	echo -e $GREEN"@___"$title"___@"
	for index in "${!candidates[@]}"; do
		echo "$((index+1)): ${candidates[index]}"
	done
	echo -en "@___"
	for ((i=0; i<$length; i++)); do
	echo -en "_"
	done
	echo -e "___@"$RESET
	echo -e "Type the number of winners : "

	read number
	#check validity
	if expr "$number" + 0 2> /dev/null >/dev/null && [ "$number" -lt "$(expr ${#candidates[@]} + 1)" ]; then
		break
	fi
done

#show result
clear
echo -e $GREEN"@___"$title"___@"
for index in "${!candidates[@]}"; do
	echo "$((index+1)): ${candidates[index]}"
done
echo -en "@___"
for ((i=0; i<$length; i++)); do
echo -en "_"
done
echo -e "___@"$RESET
echo -e $CYAN"Winners are .."$YELLOW

declare -a rand_array=($rand)
for i in $(seq 0 $(expr $number - 1)); do
	sleep 1
	index=${rand_array[i]}
	echo "$((index+1)): ${candidates[index]}"
done

exit 0