#!/bin/sh

#-- GDB env setup for manesec :P
#-- Github: Tools4mane https://github.com/manesec/Tools4mane

# 1. auto install pwndbg, gef and peda
# 2. pwndbg support for tmux
# 3. better color for gef.
# 4. install gep
# 5. (optional) add support for ghidra

## Vars
support_ghidra=0

## Asking for support ghidea, root is no support
if [ "$EUID" -ne 0 ] ; then
  while true; do
      read -p "[Experimental] Do you want to support ghidra decomplie? (y/n): " answer
      case $answer in
          [Yy]* ) support_ghidra=1; break;;
          [Nn]* ) support_ghidra=0; break;;
          * ) echo "Please answer yes (y) or no (n).";;
      esac
  done
fi

## set for non-interactive
export DEBIAN_FRONTEND=noninteractive

## make sure sudo command installed in the system
need_package="sudo python3 python3-pip git wget gdb wget ipython3 tmux python3-six"

if [ "$EUID" -eq 0 ] ; then
  echo "[*] Installing Base Packages ..."
  DEBIAN_FRONTEND=noninteractive apt update
  DEBIAN_FRONTEND=noninteractive apt install -y $need_package
else
  sudo DEBIAN_FRONTEND=noninteractive apt update
  sudo DEBIAN_FRONTEND=noninteractive apt install -y $need_package
fi

sudo pip3 install pygments

## fix different python3 version
echo "[*] Installing python3 for GDB ..."
PYVER=$(gdb -batch -q --nx -ex 'pi import platform; print(".".join(platform.python_version_tuple()[:2]))')
sudo apt install -y "python$PYVER-full"

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

echo "[*] Installing PEDA ..."
cd "$HOME/.gdb-plugins"
git clone https://github.com/punixcorn/peda.git  ~/.gdb-plugins/peda

echo "[*] Installing splitmind for tmux support ..."
cd "$HOME/.gdb-plugins"
git clone https://github.com/jerdna-regeiz/splitmind splitmind

echo "[*] Installing dashboard ..."
rm -f "$HOME/.gdbinit"
wget -O "$HOME/.gdbinit" https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit

## Support Ghidra
if [ "$support_ghidra" -eq 1 ]; then
  echo "[*] Installing ghidra ..."
  sudo apt install -y ghidra
  echo "[*] Installing radare2 ..."
  sudo apt remove -y radare2
  git clone https://github.com/radareorg/radare2 ~/.gdb-plugins/radare2
  sudo bash ~/.gdb-plugins/radare2/sys/install.sh
  echo "[*] Installing r2ghidra ..."
  sudo r2pm -cig r2ghidra
  echo "[*] Installing r2pipe for pwndbg ..."
  bash -c "source ~/.gdb-plugins/pwndbg/.venv/bin/activate ; python$PYVER -m pip install r2pipe"
fi


## Base config
echo "[*] Writing config ..."
cat  << EOF >> "$HOME/.gdbinit"

echo \n=============================================================
echo \n                 [[ tools4mane - by manesec ]]
echo \n            https://github.com/manesec/tools4mane
echo \n                Type: "help-mane" to get help.
echo \n=============================================================  \n\n

# help command
define help-mane
echo [*] Current Support Commands:  \n
echo invoke-pwndbg -- Initializes PwnDBG. \n
echo invoke-pwndbg-ghidra -- Initializes PwnDBG with ghidra decompile support. \n
echo invoke-gef -- Initializes GEF. \n
echo invoke-peda -- Initializes PEDA. \n
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

# show-stack
define show-stack

set \$stacklength =  \$rbp - \$rsp

printf "\$rbp: " 
x/xg \$rbp
printf "\$rsp: " 
x/xg \$rsp
printf " --> Stack Length = %d \n\n", \$stacklength

hexdump \$rsp \$stacklength
printf "                            ===============  rbp  ===============\n"
hexdump \$rbp 64

if (\$stacklength < 1000 ) && (\$stacklength > 0)
    printf "\n[*] Stack for 64 value ... \n"
    printf "==========================  rsp  =========================\n"
    
	set \$display64 = \$stacklength / 8
	eval "x/%dxg \$rsp\n", \$display64
    printf "==========================  rbp  =========================\n"
    x/16xg \$rbp
end

end
document show-stack
show the stack about rsp and rbp.
end

# invoke-pwndbg
define invoke-pwndbg
source ~/.gdb-plugins/pwndbg/gdbinit.py
source ~/.gdb-plugins/splitmind/gdbinit.py

# set ida-enabled off
# set ida-rpc-host 192.168.31.161
# set ida-rpc-port 31337

python
import splitmind
(splitmind.Mind()
  .tell_splitter(show_titles=True)
  .tell_splitter(set_title="Main")
  .right(display="backtrace", size="25%")
  #.above(of="main", cmd='tty; tail -f /dev/null', clearing=False, display="Input / Output", size="80%", banner="top")
  #.tell_splitter(set_title='Input / Output')
  .above(of="main",display="disasm", size="80%", banner="top")
  .show("code", on="disasm", banner="none")
  .above(display="stack", size="35%")
  .below(of="backtrace", cmd="ipython3", size="80%")
  .above(display="legend", size="70%")
  .show("regs", on="legend")
).build(nobanner=True)
end

set context-clear-screen on
set context-disasm-lines 15
set context-stack-lines 10

end
document invoke-pwndbg
Initializes PwnDBG
end

# invoke-gef
define invoke-gef
source ~/.gdb-plugins/gef.py
tmux-setup
end
document invoke-gef
Initializes GEF (GDB Enhanced Features)
end

# invoke-peda
define invoke-peda
source ~/.gdb-plugins/peda/peda.py
end
document invoke-peda
Initializes PEDA - Python Exploit Development Assistance for GDB
end

# set disassembly-flavor
set disassembly-flavor intel
set disassemble-next-line off

EOF

## Config for support ghidra
if [ "$support_ghidra" -eq 1 ]; then
cat  << EOF >> "$HOME/.gdbinit"
# invoke-pwndbg-ghidra
define invoke-pwndbg-ghidra
source ~/.gdb-plugins/pwndbg/gdbinit.py
source ~/.gdb-plugins/splitmind/gdbinit.py

# set ida-enabled off
# set ida-rpc-host 192.168.31.161
# set ida-rpc-port 31337

python
import splitmind
(splitmind.Mind()
  .tell_splitter(show_titles=True)
  .tell_splitter(set_title="Main")
  .right(display="backtrace", size="25%")
  .above(of="main",display="ghidra", size="80%", banner="top")
  .tell_splitter(set_title='ghidra')
  .right(display="disasm", size="60%", banner="top")
  .show("code", on="disasm", banner="none")
  .above(display="stack", size="35%")
  .below(of="backtrace", cmd="ipython3", size="85%")
  .above(display="legend", size="70%")
  .show("regs", on="legend")
).build(nobanner=True)
end

set context-ghidra if-no-source
set context-clear-screen on
set context-disasm-lines 15
set context-stack-lines 10

end
document invoke-pwndbg-ghidra
Initializes PwnDBG with ghidra decompile support.
end

EOF
else
cat  << EOF >> "$HOME/.gdbinit"
# invoke-pwndbg-ghidra
define invoke-pwndbg-ghidra
echo No support, please re-run tools4mane install script. \n
end
document invoke-pwndbg-ghidra
No support, please re-run tools4mane install script.
end

EOF
fi

## finally
echo "[*] Installing GEP for Enhanced Prompt ..."
git clone --depth 1 https://github.com/lebr0nli/GEP.git ~/.gdb-plugins/GEP
bash ~/.gdb-plugins/GEP/install.sh 

echo "[!] DONE! start gdb and type 'help-mane' to get help."