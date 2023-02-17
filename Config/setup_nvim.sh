#! /bin/bash
echo [*] apt updating ...
sudo apt update

echo [*] apt installing ...
sudo apt-get install -y python-dev python-pip python3-dev python3-pip vim 

echo [*] getting and setting neovim ...
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb -O /tmp/nvim-linux64.deb
sudo dpkg -i /tmp/nvim-linux64.deb
mkdir -p ~/.config/nvim
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/neovim/init.lua -O  ~/.config/nvim/init.lua

echo [*] install python env ...
sudo pip3 install debugpy
sudo apt install -y python3-venv
