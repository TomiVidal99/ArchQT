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
gem install

# fuzzy finder dependency for plugin
pacman -S the_silver_searcher --noconfirm --needed

# error debugger dependency
yay -S ctags --noconfirm 

nvim +PlugInstall +CocInstall coc-eslint
