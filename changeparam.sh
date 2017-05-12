#!/bin/bash


echo "Usage $0 target.nasm changedparam newparamvalue" 
# 		$1 		$2      	$3 

echo "This shell script allows you to change any parameter in shellcode using sed"; 
echo "Example: $0 simpleshell.nasm port 55555"; 


currentvalue=$(grep "define $2" $1 | cut -d ' ' -f3)

sed "0,/$currentvalue/{s/$currentvalue/$3/}" $1
