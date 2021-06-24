#!/bin/bash

set -Eeuo pipefail

msg_status() {
  printf "\033[0;32m-- $1\033[0m\n"
}

msg_error() {
  printf "\033[0;31m-- $1\033[0m\n"
}

install_emacs_Darwin() {
  command -v brew >/dev/null 2>&1 || {
    msg_status "Installing HomeBrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  }

  msg_status "Installing Emacs"
  brew tap railwaycat/emacsmacport/emacs-mac
  brew install --cask emacs-mac

  msg_status "Installing necessary fonts"
  brew tap homebrew/cask-fonts
  brew install font-fira-code font-inconsolata font-hack

  msg_status "Installing necessary brew packages"
  brew install htop jq ripgrep
}

install_emacs_Linux() {
  sudo apt install -y emacs
}

clone_emacs_config_repo() {
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
}

link_config_files() {
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
}

run_emacs_Darwin() {
  msg_status "Opening Emacs to finish installation"
  # whitelist the Emacs app.
  xattr -d -r com.apple.quarantine
  open /Applications/Emacs.app
}

run_emacs_Linux() {
  emacs
}

###### MAIN ######

OS=$(uname -s)
msg_status "Preparing $OS install"
install_emacs_$OS
clone_emacs_config_repo
link_config_files
run_emacs_$OS
