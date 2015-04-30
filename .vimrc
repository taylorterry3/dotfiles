set nocompatible

set backspace=2
set shiftwidth=4
set expandtab
set tabstop=4
set autoindent
set softtabstop=4 "Multiple spaces are seen as tabstops so <BS> deletes the four together"

set number

execute pathogen#infect()

syntax enable
set background=dark
let g:solarized_termcolors=256
colorscheme solarized 
