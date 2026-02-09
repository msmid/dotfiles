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
brew install font-hack-nerd-font
brew install tmux
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

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
# NOTE! git-lfs is installed manually from binaries because `brew install`` has clash with exec paths of git
# brew install git-lfs

brew install direnv
brew install yarn
brew install postgresql@14

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

# Ruby
brew install imagemagick
brew install libxml2
brew install libxslt
brew install libffi

# Java
brew install tomcat@9

# Web
brew install php
brew install composer

# Native Development
brew install cocoapods

# Tools
brew install docker-compose
brew install p7zip
# CLI-based non-interactive downloader
brew install wget
# CLI Markdown renderer
brew install mdless
# Famous command line file manager
brew install midnight-commander


# VPN
brew install openconnect
brew install vpn-slice
brew install wireguard-tools

#
# Casks
#
brew install --cask raycast
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
brew install --cask cyberduck
brew install --cask commander-one

brew install --cask bitwarden
brew install --cask discord
brew install --cask google-drive

brew install --cask spotify
brew install --cask steam
brew install --cask epic-games
brew install --cask battle-net