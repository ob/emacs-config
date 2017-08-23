#!/bin/sh

msg_status() {
	echo "\033[0;32m-- $1\033[0m"
}

msg_error() {
	echo "\033[0;31m-- $1\033[0m"
}

command -v brew >/dev/null 2>&1 || {
    msg_status "Installing HomeBrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

msg_status "Installing Emacs"
brew tap railwaycat/emacsmacport
brew install emacs-mac
brew linkapps emacs-mac

msg_status "Installing necessary fonts"
brew tap caskroom/fonts
brew cask install font-inconsolata font-hack


msg_status "Installing necessary brew packages"
brew install global htop jq

msg_status "Cloning emacs-config"
test -d ~/.emacs.d && mv ~/.emacs.d ~/.emacs.d.`date +%Y-%m-%d`.old
git clone git@github.com:ob/emacs-config.git ~/.emacs.d

msg_status "Linking config files"
ln -s ~/.emacs.d/config-files/emacs_bash.sh ~/.emacs_bash

msg_status "Opening Emacs to finish installation"
open /Applications/Emacs.app