#! /bin/bash
sudo apt install -y fzf jq
mkdir -p ~/.tmux/plugins/

echo "[Tmux] Cloning mane-tmux-macros ... "
git clone https://github.com/manesec/mane-tmux-macros ~/mane-tmux-macros

echo "[Tmux] Cloning tmux-text-macros ... "
git clone https://github.com/manesec/tmux-command-macros.git ~/.tmux/plugins/tmux-command-macros

echo "[Tmux] Installing config ... "
wget https://raw.githubusercontent.com/manesec/tools4mane/main/Config/tmux/tmuxWithMacros.conf -O ~/.tmux.conf
