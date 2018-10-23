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

if [ -d ~/.emacs.d ]
then
  if [ -d ~/.emacs.d/.git ]
  then
    (cd ~/.emacs.d && git pull --tags)
  else
    mv ~/.emacs.d ~/.emacs.d.`date +%Y-%m-%d`-$$.old
    git clone git@github.com:ob/emacs-config.git ~/.emacs.d
  fi
else
  git clone git@github.com:ob/emacs-config.git ~/.emacs.d
fi

msg_status "Linking config files"
(
    cd  $HOME;
    for file in .emacs.d/config-files/*
    do
        dotFile=~/.$(basename $file)
        test -L $dotFile && rm -f $dotFile
        test -e $dotFile && mv $dotFile $dotFile.$$.old
        echo "Linking $dotFile -> $file"
        ln -s "$file" $dotFile
    done
)

msg_status "Opening Emacs to finish installation"
# whitelist the Emacs app.
xattr -d -r com.apple.quarantine
open /Applications/Emacs.app
