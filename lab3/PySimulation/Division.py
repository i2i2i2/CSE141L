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

# get Dividend and divisior
dividend = 256 * int(mem[127], 16)
dividend += int(mem[128], 16)
divisor = int(mem[129], 16)

# get quotient
quotient = dividend // divisor
quotient = padding0(hex(quotient)[2:], 4)

# store
mem[125] = quotient[0:2]
mem[126] = quotient[2:4]

# add seperator
for i in range(0, 16):
    mem.insert(17 * i, "// 0x000000" + hex(i)[2:] + "0")

# write to file
sol_mem = open(os.path.realpath('.') + '/Division/ref_mem', 'w+')
sol_mem.write('\n'.join(mem))
sol_mem.close()
