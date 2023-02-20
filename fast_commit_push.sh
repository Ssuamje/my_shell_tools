#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

direct=false
message=""

if [ $# -gt 2 ] || [ $# -eq 0 ]; then
	echo -e "Usage : gfc [-d : direct] <commit_string>"
	exit 1
fi

for i in "$@"; do
  case $i in
    -d)
      direct=true
      ;;
    *)
      if [ -z "$message" ]; then
	  	message="$i"
	  fi
      ;;
  esac
done

if [ -z "$message" ]; then
	echo -e $RED"You should enter commit message to first argument." $RESET
	exit 1
fi

added=$(git status --porcelain | grep -E '(^ A|^A)' | cut -c 4-)
modified=$(git status --porcelain | grep -E '(^ M|^M)' | cut -c 4-)
deleted=$(git status --porcelain | grep -E '(^ D|^D)' | cut -c 4-)
untracked=$(git status --porcelain | grep -E '^\?\?' | cut -c 4-)

if $direct; then
	echo -e $GREEN"@___Will be committed___@"
	for file in $added; do
		echo "$file"
	done
	for file in $modified; do
		echo "$file"
	done
	for file in $untracked; do
		echo "$file"
	done
	for file in $deleted; do
		echo "$file"
	done
	echo -e "@-----------------------@\n" $RESET
	echo -e $PURPLE"Committing and pushing directly..\n"$YELLOW
	cd $(git rev-parse --show-toplevel)
	git add .
	cd - | echo -n ""
	echo -e -n $YELLOW"Commit : "$WHITE
	git commit -m "$message" | sed -n '2p'
	echo -e -n $YELLOW"\nPush : "$WHITE
	git push $(git remote) $(git branch | grep \* | awk '{ print $2 }')
	exit 0
fi

#check git status
clear
while true; do
	echo -e $GREEN"@___Added___@"
	for file in $added; do
		echo "$file"
	done
	echo -e "@-----------@\n" $RESET
	echo -e $RED"@___Modified___@"
	for file in $modified; do
		echo "$file"
	done
	echo -e "@--------------@\n" $RESET
	echo -e $RED"@___Untracked___@"
	for file in $untracked; do
		echo "$file"
	done
	echo -e "@---------------@\n" $RESET
	echo -e $RED"@___Deleted___@"
	for file in $deleted; do
		echo "$file"
	done
	echo -e "@--------------@\n" $RESET

	echo -e $YELLOW"Want to update all changes to current branch? (y/n)"$WHITE
	read answer

	answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
	if [ "$answer" == "y" ]; then
		break
	elif [ "$answer" == "n" ]; then
		echo -e $YELLOW"Exiting..."
		exit 0
	else
		echo $YELLOW"Invalid input. Please enter 'y' or 'n'." $RESET
	fi
done

#check commit message
message=$1
while true; do
	clear
	echo -e $WHITE"Message : \"$message\""
	echo -e $YELLOW"is it right? (y/n/q to quit)"$WHITE
	read answer

	answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
	if [ "$answer" == "y" ]; then
		clear
		break
	elif [ "$answer" == "n" ]; then
		clear
		echo -e $YELLOW"Input commit message you want to change."$WHITE
		read message
	elif [ "$answer" == "q" ]; then
		clear
		echo -e $YELLOW"Exiting..."$WHITE
		exit 0
	else
		echo "Invalid input. please enter y or n."
	fi
done


#move to git root directory
cd $(git rev-parse --show-toplevel)

#add all changes
git add .
cd -

#check user's decision
while true; do

	staged=$(git status --porcelain | grep -E '(^A|^M|^D)' | cut -c 4-)
	unstaged=$(git status --porcelain | grep -Ev '(^A|^M|^D)' | cut -c 4-)
	echo -e $GREEN"@________Staged________@"
	for file in $staged; do
		echo "$file"
	done
	echo -e "@-----------------------@\n" $RESET
	echo -e $RED"@_______Not Staged______@"
	for file in $unstaged; do
		echo "$file"
	done
	echo -e "@-----------------------@\n" $RESET
	echo -e $YELLOW"do you want to push these updates?\n(y / q / [filename] : to unstage / a [filename] : to stage / c : undo / s : stop with commit)"$WHITE
	read answer

	answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
	if [ "$answer" == "y" ]; then
		clear
		break
	elif [ "$answer" == "q" ]; then
		clear
		echo -e $YELLOW"Cancelling commit..."$WHITE
		git reset | echo -n ""
		exit 0;
	elif [ $(echo "$answer" | awk '{ print $1 }') == "a" ]; then
		git add $(echo "$answer" | awk '{ print $2 }') | grep noting
		clear
	elif [ "$answer" == "c" ]; then
		git add $prev | grep noting
		clear
	elif [ "$answer" == "s" ]; then
		clear
		echo -e $YELLOW"Stopping with staged commit..."$RESET
		exit 0
	else
		prev=$answer
		git restore --staged $answer
		clear
	fi
done


echo -e -n $YELLOW"Commit : "$WHITE
git commit -m "$message" | sed -n '2p'


#get current working branch
echo -e -n $YELLOW"Push : "$WHITE
git push $(git remote | sed -n '1p') $(git branch | grep \* | awk '{ print $2 }')