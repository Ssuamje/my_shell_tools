GIT="Ssuamje/my_git_tools.git"
REPO="my_git_tools"
FILE="fast_commit_push.sh"
FILE_HIDDEN=".fast_commit_push.sh"
MY_ALIAS="gfc"

git clone git@github.com:$GIT

#make file hidden
mv $REPO/$FILE $HOME
cd $HOME
mv $FILE $FILE_HIDDEN
cd -
rm -rf $REPO

SRC="$HOME/.zshrc"

if [ "$(uname)" != "Darwin" ]; then
	SRC="$HOME/.bashrc"
	if [[ -f "$HOME/.zshrc" ]]; then
		SRC="$HOME/.zshrc"
	fi
fi

if [ $(cat $SRC | grep "$FILE" | wc -l) -eq 0 ]
then
	echo -e "\nalias $MY_ALIAS=\"bash $HOME/$FILE_HIDDEN\"" >> "$SRC"
fi

exec "$SHELL"