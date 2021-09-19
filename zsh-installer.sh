#!/bin/bash

# Version 1.1
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

ZSHRC="$HOME/.zshrc"
mkdir -p ~/.zsh/config/

echo -e "\033[32mConfiguring default .zshrc...\033[0m"
wget https://raw.githubusercontent.com/specarino/zsh/main/default_zshrc -P ~/.zsh/config
cat ~/.zsh/config/default_zshrc > $ZSHRC

echo -e "\033[32mCloning the necessary plugins...\033[0m"
git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/zsh-history-substring-search

echo -e "\033[32mAdding the plugins to the .zshrc...\033[0m"
echo '' >> $ZSHRC
wget https://raw.githubusercontent.com/specarino/zsh/main/specarino_config -P ~/.zsh/config
cat ~/.zsh/config/specarino_config >> $ZSHRC

echo -e "\033[32mCleaning up some temporary files...\033[0m"
rm -r ~/.zsh/config

echo -e "\033[32mGrabbing uninstaller script...\033[0m"
wget https://raw.githubusercontent.com/specarino/zsh/main/zsh-uninstaller.sh -P ~/.zsh
chmod +x ~/.zsh/zsh-uninstaller.sh

echo -e "\033[32m.zshrc configured!\033[0m"
echo -e "\n\033[34mWelcome to your zsh shell $USER! Uninstaller script available in ~/.zsh\033[0m\n"
exec zsh
