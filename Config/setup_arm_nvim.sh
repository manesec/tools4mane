#! /bin/bash
echo [*] apt updating ...
sudo apt update

echo [*] apt installing ...
sudo apt-get install -y python3-dev python3-dev python3-pip vim 

echo [*] setting neovim ...
mkdir -p ~/.config/nvim
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/neovim/init.lua -O  ~/.config/nvim/init.lua

echo [*] install python env ...
sudo pip3 install debugpy
sudo apt install -y python3-venv npm
