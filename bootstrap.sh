#!/usr/bin/env bash

cd ~
mkdir Tools
cd Tools
git clone https://github.com/rzachary/tw_dots

# Vim Plug Directory
mkdir -p ~/.vim/plugged

ln -s ~/Tools/tw_dots/.aws/ ~/.aws
ln -s ~/Tools/tw_dots/.config/ ~/.config
ln -s ~/Tools/tw_dots/.tmux.conf ~/.tmux.conf
ln -s ~/Tools/tw_dots/.zshenv ~/.zshenv
ln -s ~/Tools/tw_dots/.zprofile ~/.zprofile
ln -s ~/Tools/tw_dots/.bin/ ~/.bin
ln -s ~/Tools/tw_dots/.gitconfig ~/.gitconfig

cd ~/Tools/tw_dots/
git clone https://github.com/arcticicestudio/nord-dircolors.git

cd ~/Tools/tw_dots/.config/
git clone https://github.com/arcticicestudio/nord-tmux.git

ln -sr "$PWD/src/dir_colors" ~/.dir_colors

./install.sh