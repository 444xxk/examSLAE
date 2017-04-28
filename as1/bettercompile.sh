#!/bin/bash

echo $1 

if [[  $1 == *".nasm"* ]]; then echo "do not provide extension please" ; exit 0; fi 

echo "[+] Backup original file" 
cp $1.nasm .$1.nasm

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

echo '[+] Done!'



