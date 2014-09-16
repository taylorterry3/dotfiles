#!/bin/sh

# makes symlinks in home dir to dotfiles dir.

ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.bashrc_private ~/.bashrc_private
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.Rprofile ~/.Rprofile

