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

# read vars
x = 256 * int(mem[0], 16)
x += int(mem[1], 16)
y = 256 * int(mem[2], 16)
y += int(mem[3], 16)

# print x
# print y

# start process
angle = 0
for i in range(0, 12):
    ytemp = y
    if y >= 0:
        y -= x // (2**i)
        x += ytemp // (2**i)
        angle += pow(2, 11 - i)
    else:
        y += x // (2**i)
        x -= ytemp // (2**i)
        angle -= pow(2, 11 - i)
    # print padding0(hex(x + 65536)[2:], 4)[-4:] + " " + str(x)
    # print padding0(hex(y + 65536)[2:], 4)[-4:] + " " + str(y)
    # print padding0(hex(angle << 4)[2:], 4)
    # print padding0(hex(x // (2**(i + 1)) + 65536)[2:], 4)[-4:]
    # print padding0(hex(y // (2**(i + 1)) + 65536)[2:], 4)[-4:]
    # print i

# turn to hex
# print x
# print y
# print angle
x = padding0(hex(x)[2:], 4)
y = padding0(hex(y)[2:], 4)
angle = padding0(hex((angle << 4) + 65536)[2:], 4)[-4:]


# modify sol_mem
mem[4] = x[0:2]
mem[5] = x[2:4]
mem[6] = angle[0:2]
mem[7] = angle[2:4]

# add seperator
for i in range(0, 16):
    mem.insert(17 * i, "// 0x000000" + hex(i)[2:] + "0")

# write to file
sol_mem = open(os.path.realpath('.') + '/CORDIC/ref_mem', 'w+')
sol_mem.write('\n'.join(mem))
sol_mem.close()
