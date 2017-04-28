
echo "Usage: $0 targetasm";

if [ $# -eq 0 ]; then echo "NO ARGUMENT GIVEN, EXITING ..."; exit; fi 

echo "This script build assembly, extract bytecode, insert bytecode into wrapper, build wrapper"; 
echo "Building ASM..."; 
nasm -f elf32 $1 -o $1.o  

echo "dumping bytecode from target file..." ; 
shell=$(objdump -d ./$1.o | grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g');

echo "the shellcode bytecode is $shell"; 

shell_escape=$(echo $shell | sed 's/\\/#CS/g';)

echo "escaped bytecode for sed replace is $shell_escape"; 

echo "copying bytecode to wrapper shellcode.c" ; 
sed  "s/EDITME/$shell_escape/" shellcode_template.c  > shellcode_build.c 
echo "sed first pass done" ; 
sed -i 's/#CS/\\/g' shellcode_build.c; 
echo "sed second pass done" ; 


echo "compiling the wrapper ..." ; 
gcc -fno-stack-protector -z execstack shellcode_build.c -o shellcode;

