#!/usr/bin/env bash

echo "update brew"
# brew update
brew upgrade

echo "install ag"
brew install ag
echo "install autoconf"
brew install autoconf
echo "install automake"
brew install automake
echo "install docker"
brew install docker
brew install docker-machine
echo "install git"
brew install git
echo "install vim"
brew install macvim --override-system-vim --with-cscope --with-lua
brew linkapps macvim
echo "install zsh"
brew install zsh

brew cleanup
echo "done brew cleanup"
