#!/bin/bash

# Version 1.1
# Updated 19th September 2021

echo -e "\033[0;31mDisclaimer: This uninstaller will remove all traces of zsh.\033[0m"
echo -e "\033[0;31mPlease read the script before executing it to check for conflict.\033[0m"
read -p "Type confirm if you wish to continue: " input
if [ ! "$input" = "confirm" ]
then
    exit
fi

echo -e "\033[32mRemoving zsh configs...\033[0m"
rm -r ~/.zsh/
rm ~/.zcompdump*
rm ~/.zsh_history*
rm ~/.zshrc*

echo -e "\033[0;32mPlease enter your sudo password (if prompted).\033[0m\n"
readPassword() {
    read -s -p "[sudo] password for $USER: " PASSWORD
    until (echo $PASSWORD | sudo -S echo '' 2>/dev/null)
    do
        echo -e '\nWrong password, try again.'
        read -s -p "[sudo] password for $USER: " PASSWORD
    done
}

echo -e "\033[32mRemoving zsh packages...\033[0m"
sudo apt-get remove zsh zsh-common

echo -e "\033[32mSetting bash as default shell...\033[0m"
sudo chsh -s $(which bash) $USER

echo -e "\n\033[34mzsh uninstalled!\033[0m\n"
