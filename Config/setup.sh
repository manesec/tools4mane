#! /bin/bash
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/tmux.conf -O ~/.tmux.conf
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/vimrc -O ~/.vimrc
mkdir -p ~/.config/nvim
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/neovim/init.lua -O  ~/.config/nvim/init.lua
echo Done.
