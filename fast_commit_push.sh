#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

quiet=false
message=""

while [ $# -gt 0 ]; do
  case "$1" in
    -q)
      quiet=true
      shift
      ;;
    *)
      message="$1"
      shift
      break
      ;;
  esac
done


if [ -z "$message" ]; then
	echo -e $RED"You should enter commit message to first argument." $RESET
	exit 1
fi

if $quiet; then
	echo -e $CYAN"Committing and pushing directly.."$YELLOW
	cd $(git rev-parse --show-toplevel)
	git add .
	cd -
	echo -e -n $YELLOW"Commit : "
	git commit -m "$message" | sed -n '2p'
	echo -e -n $YELLOW"Push : "
	git push $(git remote) $(git branch | grep \* | awk '{ print $2 }')
	exit 0
else
	#check git status
	clear
	while true; do
		added=$(git status --porcelain | grep -E '(^ A|^A)' | cut -c 4-)
		modified=$(git status --porcelain | grep -E '(^ M|^M)' | cut -c 4-)
		untracked=$(git status --porcelain | grep -E '^\?\?' | cut -c 4-)
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

		echo -e $CYAN"Want to update all changes to current branch? (y/n)"$YELLOW
		read answer

		answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
		if [ "$answer" == "y" ]; then
			break
		elif [ "$answer" == "n" ]; then
			echo -e $CYAN"Exiting..."
			exit 0
		else
			echo $CYAN"Invalid input. Please enter 'y' or 'n'." $RESET
		fi
	done

	#move to git root directory
	cd $(git rev-parse --show-toplevel)

	#add all changes
	git add .
	cd -

	#check commit message
	message=$1
	while true; do
		clear
		echo -e $YELLOW"Message : \"$message\""
		echo -e $CYAN"is it right? (y/n)"$YELLOW
		read answer

		answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
		if [ "$answer" == "y" ]; then
			clear
			break
		elif [ "$answer" == "n" ]; then
			clear
			echo -e $CYAN"Input commit message you want to change."$YELLOW
			read message
		else
			echo "Invalid input. please enter y or n."
		fi
	done

	#set commit message
	echo -e -n $YELLOW"Commit : "
	git commit -m "$message" | sed -n '2p'

	#get current working branch
	echo -e -n $YELLOW"Push : "
	git push $(git remote) $(git branch | grep \* | awk '{ print $2 }')
fi