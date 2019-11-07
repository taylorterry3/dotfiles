#!/bin/sh

# makes symlinks in home dir to dotfiles dir.

ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
ln -s ~/dotfiles/.profile ~/.profile
ln -s ~/dotfiles/.Rprofile ~/.Rprofile
ln -s ~/dotfiles/.screenrc ~/.screenrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
