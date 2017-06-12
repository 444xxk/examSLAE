#!/usr/bin/env python

import sys 

"""
    Copyright (C) 2012 Bo Zhu http://about.bozhu.me

"""


def KSA(key):
    keylength = len(key)

    S = range(256)

    j = 0
    for i in range(256):
        j = (j + S[i] + key[i % keylength]) % 256
        S[i], S[j] = S[j], S[i]  # swap

    return S



def PRGA(S):
    i = 0
    j = 0
    while True:
        i = (i + 1) % 256
        j = (j + S[i]) % 256
        S[i], S[j] = S[j], S[i]  # swap

        K = S[(S[i] + S[j]) % 256]
        yield K


def RC4(key):
    S = KSA(key)
    print("debug first byte of S struct")
    print(S[0])
#    for p in S: print p 
    return PRGA(S)


if __name__ == '__main__':
    # test vectors are from http://en.wikipedia.org/wiki/RC4
	
    print("RC4 encoder / decoder tester") 

    # ciphertext should be BBF316E8D940AF0AD3
    key = 'supersecret!'
    print("RC4 key is " + key)

	#plaintext = 'Plaintext'
    plaintext = sys.argv[1]
    print(type(plaintext)) 
 
    
    
    # ciphertext should be 1021BF0420
    #key = 'Wiki'
    #plaintext = 'pedia'

    # ciphertext should be 45A01F645FC35B383552544B9BF5
    #key = 'Secret'
    #plaintext = 'Attack at dawn'

    def convert_key(s):
        return [ord(c) for c in s]
    key = convert_key(key)

    keystream = RC4(key)

    import sys
    for c in plaintext:
        sys.stdout.write("%02X" % (ord(c) ^ keystream.next()))
    print


