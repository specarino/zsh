#!/bin/bash

# Version 1.0
# Updated 19th September 2021

echo -e "\033[0;31mDisclaimer: This installer is unofficial and only works with Ubuntu/Debian.\033[0m"
read -p "Type confirm if you wish to continue: " input
if [ ! "$input" = "confirm" ]
then
    exit
fi

echo -e "\033[0;32mPlease enter your sudo password (if prompted).\033[0m\n"

readPassword() {
    read -s -p "[sudo] password for $USER: " PASSWORD
    until (echo $PASSWORD | sudo -S echo '' 2>/dev/null)
    do
        echo -e '\nWrong password, try again.'
        read -s -p "[sudo] password for $USER: " PASSWORD
    done
}

sudo apt-get update && sudo apt-get install zsh git

while true; do
    read -p "Do you wish to install zsh as the default shell? (y/n) " yn
    case $yn in
        [Yy]* ) echo $PASSWORD | sudo chsh -s $(which zsh) $USER; echo -e "\033[31mzsh set as the default shell\033[0m"; break;;
        [Nn]* ) echo -e "\033[31mzsh NOT set as the default shell\033[0m"; break;;
        * ) echo "Please answer Y or N.";;
    esac
done

sleep 1

echo -e "\033[32mConfiguring default .zshrc...\033[0m"

ZSHRC="$HOME/.zshrc"

echo '# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall' > $ZSHRC

echo -e "\033[32mCloning the necessary plugins...\033[0m"

git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/zsh-history-substring-search

echo -e "\033[32mAdding the plugins to the .zshrc...\033[0m"

echo '' >> $ZSHRC
echo '# The following lines were added by specarino

# Prompt Style
alias ll='ls -al'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
autoload -U colors && colors
PS1="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[cyan]%}%1~%{$reset_color%} %% "

# LS File Colors
alias ls='ls --color=auto'

# zsh-completions
fpath=(~/.zsh/zsh-completions/src $fpath)

# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ensure zsh-syntax-highlighting is loaded before zsh-history-substring-search
# zsh-history-substring-search
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# End of lines added by specarino' >> $ZSHRC

echo -e "\033[32m.zshrc configured!\033[0m"
echo -e "\n\033[34mWelcome to your zsh shell $USER!\033[0m\n"
exec zsh
