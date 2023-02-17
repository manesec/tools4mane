#! /bin/bash

sudo apt update
sudo apt-get install python-dev python-pip python3-dev python3-pip vim
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb -O /tmp/nvim-linux64.deb
sudo dpkg -i /tmp/nvim-linux64.deb
mkdir -p ~/.config/nvim
sudo pip3 install debugpy
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/neovim/init.lua -O  ~/.config/nvim/init.lua
