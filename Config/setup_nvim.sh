#! /bin/bash
echo [*] apt updating ...
sudo apt update

echo [*] apt installing ...
sudo apt-get install -y python3-dev python3-pip python3-dev python3-pip vim libfuse2

echo [*] getting and setting neovim ...
rm /tmp/nvim.appimage > /dev/null
wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O /tmp/nvim.appimage
sudo cp /tmp/nvim.appimage /bin/nvim
sudo chmod +x /bin/nvim

rm -rf ~/.config/nvim
mkdir -p ~/.config/nvim
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/neovim/init.lua -O  ~/.config/nvim/init.lua

echo [*] install python and npm env  ...
sudo pip3 install debugpy
sudo apt install -y python3-venv npm
