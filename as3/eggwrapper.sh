#!/bin/bash
echo "Usage: $0 eggcode shellcodefile.nasm"
eggcode="$1";
cwd=$(pwd);

echo "this script will output the selected egg append it to the shellcode selected" ;

echo "egg: $1";

objdump -d ./"$2" | grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g';
