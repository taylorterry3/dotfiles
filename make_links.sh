#!/bin/sh

# makes symlinks in home dir to dotfiles dir.

ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.screenrc ~/.screenrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
# ln -s ~/dotfiles/.bashrc_private ~/.bashrc_private
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.Rprofile ~/.Rprofile
ln -s ~/dotfiles/.curlrc ~/.curlrc
ln -s ~/Google\ Drive gdrive

# check if on OSX and use .profile if so
OS=`uname`
if [ $OS = "Darwin" ]; then
	ln -s ~/dotfiles/.profile ~/.profile
fi
