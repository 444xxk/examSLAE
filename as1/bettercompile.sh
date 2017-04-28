#!/bin/bash

echo "[+] Backup original file" 
cp $1.nasm .$1.nasm

if [ $1 eq ".nasm" ]; then echo "do not provide extension please" ; exit; fi 

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

echo '[+] Done!'



