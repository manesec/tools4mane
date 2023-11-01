#! /bin/bash

echo "Zsh setup program, by Tools4mane ..."

echo "[*] Setting up zsh ..."
mkdir -p "$HOME/.zsh"
wget 

echo "[*] Installing Plugin ..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
mkdir -p "$HOME/"