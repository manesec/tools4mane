# gdb - setup.sh script

Gdb setup config by [@manesec](https://github.com/manesec/).

**Note:** PLEASE use `tmux` to get a better experience.
**Note:** It only work for new version of kali linux.

## Features

+ support for pwndbg, gef, peda.
+ support tmux for pwndbg.
+ better color for gef.
+ GDB Enhanced Prompt.
+ [Experimental] support for ghidra decomplie (no support for root).

## How to Install ?

**Please make a backup of `.gdbinit` before running the script, it will overwrite your `.gdbinit`.**

```
wget https://github.com/manesec/tools4mane/raw/main/Config/gdb/setup.sh
bash setup.sh
```

and wait.

## Screenshot

**invoke-pwndbg**

![invoke-pwndbg](img/invoke-pwndbg.png)

**invoke-pwndbg-ghidra**

![invoke-pwndbg-ghidra](img/invoke-pwndbg-ghidra.png)

**invoke-gef**

![invoke-gef](img/invoke-gef.png)

**invoke-peda**

![invoke-peda](img/invoke-peda.png)


## Support Command

```
>>> help-mane
[*] Current Support Commands:  
invoke-pwndbg -- Initializes PwnDBG. 
invoke-pwndbg-ghidra -- Initializes PwnDBG with ghidra decompile support. 
invoke-gef -- Initializes GEF. 
invoke-peda -- Initializes PEDA. 
invoke-peda-arm -- Initializes PEDA for arm. 
invoke-peda-intel -- Initializes PEDA for intel. 
show-stack -- Show the stack related rsp and rbp. 
toggle-eflags -- Toggle eflags helper. 
```


## FAQ

### Question: Ghidra did not show correctly

If ghidra window show on GDB: `r2pipe or rzpipe not available, but required for r2/rz->ghidra bridge`, it mean some python version was different and library install incorrectly.

You can paste the code to terminal to quick fix it or install newer version of kali.

```bash
PYVER=$(gdb -batch -q --nx -ex 'pi import platform; print(".".join(platform.python_version_tuple()[:2]))')
"python$PYVER" -m pip install r2pipe --break-system-packages
```

### Question: How to debug root program

if you want to debug some root program, you can :

```
$ sudo gdbserver :1234 someprogram
```

and runas user:
```
$ gdb

>>> target remote 127.0.0.1:1234
>>> invoke-pwndbg
```

or using `suid` with some program.
