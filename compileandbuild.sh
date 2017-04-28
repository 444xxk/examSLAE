echo "Usage: $0 targetasm";
echo "This script build assembly, extract bytecode, insert bytecode into wrapper, build wrapper"; 
echo "Building ASM..."; 
nasm -f elf32 $1 -o $1.o  
echo "dumping bytecode from target file..." ; 
shell=$(objdump -d ./$1.o | grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g');
echo "shellcode is $shell"; 
echo "copying to wrapper shellcode.c" ; 
 # todo 
echo "compiling the wrapper ..." ; 
#gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
