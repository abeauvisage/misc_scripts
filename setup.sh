#!/bin/zsh
SCRIPTNAME=$(readlink -f "$0")
SCRIPTDIR=$(dirname "$SCRIPTNAME")
HOSTNAME=$(hostname)

## install oh-my-zsh ##
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

## Required zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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

# Bash insulter
if [ ! -d "$HOME/.bash-insulter" ]; then
    git clone https://github.com/hkbakke/bash-insulter.git $HOME/.bash-insulter
fi
sudo cp $HOME/.bash-insulter/src/bash.command-not-found /etc/

## Global gitignore ##

echo "/build/\n/.clangd" > ~/.gitignore
git config --global core.excludesFile '~/.gitignore'
