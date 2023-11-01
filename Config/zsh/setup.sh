#! /bin/bash
echo "Zsh setup program, power by Tools4mane ..."

echo "[*] Checking curl "
if ! command -v curl &> /dev/null
then
    echo "[*] curl could not be found, trying to use APT to install it."
    sudo apt update && sudo apt install -y curl
fi

echo "[*] Clearning up zsh ..."
rm -rf $HOME/.oh-my-zsh 2> /dev/null

echo "[*] Setting up zsh ..."
sudo apt install -y zsh-autosuggestions zsh-syntax-highlighting zsh

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

echo "[*] Installing oh-my-zsh ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "[*] Install Plugin ..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

echo "[*] Making config ..."
rm ~/.zshrc
curl "https://raw.githubusercontent.com/manesec/tools4mane/main/Config/zsh/zshrc" -o ~/.zshrc
echo ""
echo "OK! Type 'zsh' to use zsh like bash!"
echo ""