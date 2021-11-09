#!/bin/bash

github_repository="https://github.com/TomiVidal99/nvim_config.git"

# change to the home directory por relative paths
cd ~

# create the paths
mkdir -p ~/.config/nvim
cd ~/.config/nvim

#  clone the config repo
git clone $github_repository .

# install neovim Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# dependencies for the nvim plugs
yarn global add neovim
pip3 install neovim 
gem install neovim
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin

# fuzzy finder dependency for plugin
sudo pacman -S the_silver_searcher

# error debugger dependency
sudo yay -S --noconfirm ctags

nvim +PlugInstall
