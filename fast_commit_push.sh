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

if $direct; then
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
	added=$(git status --porcelain | grep -E '(^ A|^A)' | cut -c 4-)
	modified=$(git status --porcelain | grep -E '(^ M|^M)' | cut -c 4-)
	deleted=$(git status --porcelain | grep -E '(^ D|^D)' | cut -c 4-)
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

#move to git root directory
cd $(git rev-parse --show-toplevel)

#add all changes
git add .
cd -

#check commit message
message=$1
while true; do
	clear
	echo -e $WHITE"Message : \"$message\""
	echo -e $YELLOW"is it right? (y/n)"$WHITE
	read answer

	answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
	if [ "$answer" == "y" ]; then
		clear
		break
	elif [ "$answer" == "n" ]; then
		clear
		echo -e $YELLOW"Input commit message you want to change."$WHITE
		read message
	else
		echo "Invalid input. please enter y or n."
	fi
done

#set commit message
echo -e $YELLOW"Committed files : "
echo -e $GREEN"@___Added___@"
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
echo -e "@-----------@\n" $RESET
echo -e -n $WHITE"Commit : "
git commit -m "$message" | sed -n '2p'


#get current working branch
echo -e -n $WHITE"Push : "
git push $(git remote | sed -n '1p') $(git branch | grep \* | awk '{ print $2 }')