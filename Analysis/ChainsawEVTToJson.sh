#! /bin/bash

DUMPDIR=../C/Windows/System32/winevt/logs/
SAVEDIR=dump_json

mkdir $SAVEDIR

for f in $DUMPDIR* ;
	do 
	echo Dumping $f ... ;
    echo Save in "$SAVEDIR/$(basename $f) ..."	
	./chainsaw_x86_64-unknown-linux-gnu dump "$f" --jsonl -o "$SAVEDIR/$(basename $f)"
done
