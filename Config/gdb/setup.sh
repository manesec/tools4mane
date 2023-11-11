#!/bin/sh

#-- GDB env setup for manesec :P
#-- Github: Tools4mane https://github.com/manesec/Tools4mane

# 1. auto install pwndbg and gef
# 2. add gdbui, start with command: `gdbgui`
# 3. pwndbg support for tmux
# 4. better color for gef.

# type `gdb` and `invoke-pwndbg` to start pwndbg 
# or `invoke-gef` to start gef

echo "[*] Downloading gdb ..."
sudo apt install -y gdb wget ipython3
sudo pip install gdbgui --upgrade
sudo pip install pygments

mkdir -p "$HOME/.gdb-plugins"
cd "$HOME/.gdb-plugins"
rm -f "$HOME/.gdbinit"

echo "[*] Installing pwndbg ..."
cd "$HOME/.gdb-plugins"
git clone https://github.com/pwndbg/pwndbg
cd pwndbg
./setup.sh

echo "[*] Installing GEF ..."
cd "$HOME/.gdb-plugins"
wget -O "$HOME/.gdb-plugins/gef.py" https://raw.githubusercontent.com/hugsy/gef/main/gef.py

echo "[*] Installing splitmind for tmux support ..."
cd "$HOME/.gdb-plugins"
git clone https://github.com/jerdna-regeiz/splitmind splitmind

echo "[*] Installing dashboard ..."
rm -f "$HOME/.gdbinit"
wget -O "$HOME/.gdbinit" https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit


cat  <<  EOF >> "$HOME/.gdbinit"

echo \n=============================================================
echo \n                 [[ tools4mane - by manesec ]]
echo \n            https://github.com/manesec/tools4mane
echo \n                Type: "help-mane" to get help.
echo \n=============================================================  \n\n

# help command
define help-mane
echo [*] Current Support Commands:  \n
echo invoke-pwndbg -- Initializes PwnDBG \n
echo invoke-gef -- Initializes GEF \n
end
document help-mane
Get help from tools4mane.
end

# invoke-pwndbg
define invoke-pwndbg
source ~/.gdb-plugins/pwndbg/gdbinit.py
source ~/.gdb-plugins/splitmind/gdbinit.py

python
import splitmind
(splitmind.Mind()
  .tell_splitter(show_titles=True)
  .tell_splitter(set_title="Main")
  .right(display="backtrace", size="25%")
  .above(of="main", cmd='tty; tail -f /dev/null', clearing=False, display="Input / Output", size="80%", banner="top")
  .tell_splitter(set_title='Input / Output')
  .right(display="disasm", size="80%", banner="top")
  .show("code", on="disasm", banner="none")
  .above(display="stack", size="35%")
  .below(of="backtrace", cmd="ipython3", size="85%")
  .above(display="legend", size="70%")
  .show("regs", on="legend")
).build(nobanner=True)
end

end
document invoke-pwndbg
Initializes PwnDBG
end

# invoke-gef
define invoke-gef
source ~/.gdb-plugins/gef.py
end
document invoke-gef
Initializes GEF (GDB Enhanced Features)
end

EOF

echo "[!] DONE! start gdb and type 'help-mane' to get help."

