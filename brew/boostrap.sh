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

brew install direnv
brew install yarn
brew install postgresql@14

# Node version manager
brew install nvm

# Ruby version manager
brew install chruby
brew install ruby-install

# Flutter version manager
brew tap leoafarias/fvm
brew install fvm

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

# Docker
brew install docker-compose

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

brew install --cask bitwarden
brew install --cask discord

brew install --cask spotify
brew install --cask steam
brew install --cask epic-games