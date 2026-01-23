#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

#
# Install command-line tools using Homebrew.
#

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install a modern version of Bash.
brew install bash
brew install bash-completion2
brew install wget
brew install wireguard-tools
# NOTE! git-lfs is installed manually from binaries because `brew install`` has clash with exec paths of git
# brew install git-lfs

brew install direnv
brew install yarn
brew install postgresql@14
brew install midnight-commander

# Node version manager
brew install nvm

# Ruby version manager
brew install rbenv
brew install ruby-build

# Flutter version manager
brew tap leoafarias/fvm
brew install fvm

# Python version manager
brew install pyenv

# Java versions manager
# using sdkman

# Required by flink-backend project
brew install libxml2
brew install libxslt
brew install libffi
brew install cocoapods
brew install imagemagick

# Java
brew install tomcat@9

# Web
brew install php
brew install composer

# Docker
brew install docker-compose

# Tools
brew install p7zip
brew install gsed
brew install openconnect
brew install vpn-slice
brew install mdless

#
# Casks
#

brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask fork
brew install --cask dbeaver-community
brew install --cask android-studio
brew install --cask android-ndk
brew install --cask android-sdk
brew install --cask docker
brew install --cask chromedriver
brew install --cask google-cloud-sdk
brew install --cask eloston-chromium
brew install --cask mongodb-compass
brew install --cask raycast
brew install --cask cyberduck
brew install --cask commander-one

brew install --cask bitwarden
brew install --cask discord
brew install --cask google-drive
brew install --cask sketch

brew install --cask spotify
brew install --cask steam
brew install --cask epic-games
brew install --cask battle-net