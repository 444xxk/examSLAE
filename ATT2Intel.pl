perl -e 'print "{shellcode}"' > shellcode
ndisasm -b 32 shellcode | sed -e 's/^.\{,28\}//'
