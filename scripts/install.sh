#!/bin/sh

set -Eeuo pipefail

msg_status() {
	printf "\033[0;32m-- $1\033[0m\n"
}

msg_error() {
	printf "\033[0;31m-- $1\033[0m\n"
}

command -v brew >/dev/null 2>&1 || {
    msg_status "Installing HomeBrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

msg_status "Installing Emacs"
brew tap railwaycat/emacsmacport
brew cask install emacs-mac

msg_status "Installing necessary fonts"
brew tap caskroom/fonts
brew cask install font-inconsolata font-hack

msg_status "Installing necessary brew packages"
brew install global htop jq ripgrep

msg_status "Cloning emacs-config"
test -d ~/.emacs.d && mv ~/.emacs.d ~/.emacs.d.`date +%Y-%m-%d`.old
git clone git@github.com:ob/emacs-config.git ~/.emacs.d

msg_status "Linking config files"
(
  cd ~/.emacs.d/config-files/ ;
  for file in *
  do
    if [ $file == "gitconfig" ]; then
        cat $file >> ~/.$file
    elif [ ! -f ~/.$file ]; then
        ln -s "$file" ~/."$file" 
    fi
  done
)

msg_status "Opening Emacs to finish installation"
# whitelist the Emacs app.
xattr -d -r com.apple.quarantine
open /Applications/Emacs.app
