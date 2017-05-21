#! /usr/local/bin/python
#*****************************************************************************
# File Name:    CORDIC.py
# Author:       Chenxu Jiang
#               DingCheng Hu
# Date:         May 20, 2017
# Description:  Correct CORDIC solution
#*****************************************************************************
import os

def padding0(str, num):
    for i in range(len(str), num):
        str = '0' + str
    return str

# open ref file
mem = open(os.path.realpath('.') + '/Bin/mem', 'r')
mem_t = mem.read()
mem.close()
mem = mem_t.split('\n')

# pre-process str segment
strSeg = mem[32:96]
strSeg = list(map(lambda str: padding0(bin(int(str, 16))[2:], 8), strSeg))
strSeg = "".join(strSeg)

pattern = padding0(bin(int(mem[8][1], 16))[2:], 8)[4:]

# counting
count = 0
for i in range(0, 509):
    if (pattern == strSeg[i:i+4]):
        count += 1

count = padding0(hex(count)[2:], 2)[-2:]

# store
mem[9] = count

# write to file
sol_mem = open(os.path.realpath('.') + '/TestStrCmp/ref_mem', 'w+')
sol_mem.write('\n'.join(mem))
sol_mem.close()
