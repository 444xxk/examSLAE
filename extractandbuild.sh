
echo "Usage: $0 target";

if [ $# -eq 0 ]; then echo "NO ARGUMENT GIVEN, EXITING ..."; exit; fi 

# echo "This script build assembly, extract bytecode, insert bytecode into wrapper, build wrapper"; 
# echo "[x] Building ASM..."; 
# nasm -f elf32 $1 -o $1.o  

echo "[x] dumping bytecode from target file..." ; 
shell=$(objdump -d ./$1 | grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g');

echo "[x] the shellcode bytecode is $shell"; 

shell_escape=$(echo $shell | sed 's/\\/#CS/g';)

echo "[x] escaped bytecode for sed replace is $shell_escape"; 

echo "[x] copying bytecode to wrapper shellcode.c" ; 
sed  "s/EDITME/$shell_escape/" shellcode_template.c  > shellcode_build.c 
echo "[x] sed first pass done" ; 
sed -i 's/#CS/\\/g' shellcode_build.c; 
cat shellcode_build.c;
echo "[x] sed second pass done" ; 


echo "[x] compiling the wrapper ..." ; 
gcc -fno-stack-protector -z execstack shellcode_build.c -o shellcode;

echo "please start with ./shellcode" ; 
