#!/bin/bash

if [ -z "$1" ]; then
	echo "You should enter commit message to first argument."
	exit 1
fi

#check git status
while true; do
	clear
	git status
	echo "Do you want to push all changes to current branch? (y/n)"
	read answer

	answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
	if [ "$answer" == "y" ]; then
		echo "Continuing..."
		break
	elif [ "$answer" == "n" ]; then
		echo "Exiting..."
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

#check commit message
message=$1
while true; do
	clear
	echo "Message : \"$message\""
	echo "is it right? (y/n)"
	read answer

	answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"
	if [ "$answer" == "y" ]; then
		echo "Continuing..."
		break
	elif [ "$answer" == "n" ]; then
		echo "Input commit message you want to change."
		read message
	else
		echo "Invalid input. please enter y or n."
	fi
done

#set commit message
git commit -m "$message"

#get current working branch
git push $(git remote) $(git branch | grep \* | awk '{ print $2 }')