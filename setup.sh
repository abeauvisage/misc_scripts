#!/bin/bash
SCRIPTNAME=$(readlink -f "$0")
SCRIPTDIR=$(dirname "$SCRIPTNAME")
HOSTNAME=$(hostname)

## install oh-my-zsh ##
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

## create local rc file from hostname ##
LOCALRC="shell/${HOSTNAME}rc"

if [ ! -f "$SCRIPTDIR/$LOCALRC" ]; then
	touch $SCRIPTDIR/$LOCALRC
	echo "$LOCALRC" >> "$SCRIPTDIR/.gitignore"
fi

echo "source $SCRIPTDIR/$LOCALRC" > "$SCRIPTDIR/shell/.include"

rm ~/.zshrc
ln -s "$SCRIPTDIR/shell/zshrc" ~/.zshrc

## vim config ##

if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
	curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

NVIMDIR="$HOME/.config/nvim"
INITVIM="$NVIMDIR/init.vim"

if [ ! -f "$INITVIM" ]; then
	if [ -d "$NVIMDIR" ]; then
		ln -s "$SCRIPTDIR/init.vim" $INITVIM
	else
		mkdir $NVIMDIR
		ln -s "$SCRIPTDIR/init.vim" $INITVIM
	fi
fi

source $HOME/.zshrc
