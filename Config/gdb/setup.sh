#!/bin/sh

#-- GDB env setup for manesec :P
#-- Github: Tools4mane https://github.com/manesec/Tools4mane

# 1. auto install pwndbg and gef
# 2. add gdbui, start with command: `gdbgui`
# 3. pwndbg support for tmux
# 4. better color for gef.

# type `gdb` and `invoke-pwndbg` to start pwndbg 
# or `invoke-gef` to start gef


export DEBIAN_FRONTEND=noninteractive

## make sure sudo command installed in the system
if [ "$EUID" -eq 0 ] ; then
  echo "[*] Installing Base Packages ..."
  apt install -y sudo python3 python3-pip git wget
fi

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
echo invoke-pwndbg -- Initializes PwnDBG. \n
echo invoke-gef -- Initializes GEF. \n
echo toggle-eflags -- Toggle eflags helper. \n
end
document help-mane
Get help from tools4mane.
end

# eflag command helper
set \$CF=0
set \$PF=2
set \$AF=4
set \$ZF=6
set \$SF=7
set \$IF=9
set \$DF=10
set \$OF=11
define toggle-eflags
set \$CF=0
set \$PF=2
set \$AF=4
set \$ZF=6
set \$SF=7
set \$IF=9
set \$DF=10
set \$OF=11
if (\$arg0 == 0 )
  set \$eflags ^= (1 << 0)
end
if (\$arg0 == 2 )
  set \$eflags ^= (1 << 2)
end
if (\$arg0 == 4 )
  set \$eflags ^= (1 << 4)
end
if (\$arg0 == 6 )
  set \$eflags ^= (1 << 6)
end
if (\$arg0 == 7 )
  set \$eflags ^= (1 << 7)
end
if (\$arg0 == 9 )
  set \$eflags ^= (1 << 9)
end
if (\$arg0 == 10 )
  set \$eflags ^= (1 << 10)
end 
if (\$arg0 == 11 )
  set \$eflags ^= (1 << 11)
end
info registers eflags
end
document toggle-eflags
toggle-eflags < flag_number / flag_variable > -- used to toggle single eflags.

flag_number: 
\$CF = 0    \$PF = 2    \$AF = 4     \$ZF = 6
\$SF = 7    \$IF = 9    \$DF = 10    \$OF = 11

example:
toggle-eflags 0  --  toggle CF
toggle-eflags \$CF  --  toggle CF
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

