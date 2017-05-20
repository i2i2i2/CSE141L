#! /usr/local/bin/python
#*****************************************************************************
#  File Name:    MemGen.py
#  Author:       Chenxu Jiang
#                DingCheng Hu
#  Date:         May 20, 2017
#  Description:
#*****************************************************************************
from random import randint
import os

##
# int to 8-bit 2's complement hex
# @param    integer to convert
# @return   hex string of 2's complement
##
def int2hex(num):
    num += 256
    return hex(num)[-2:] + "\n"

##
# random number
# @return   hex of random 8-bit number
##
def randomNum():
    return int2hex(randint(-128, 127))

##
# random positive number
# @return   hex of random positive 8-bit number
##
def randomPosNum():
    return int2hex(randint(0, 127))

mem = ""

# x msw lsw, y msw lsw
mem += randomPosNum()
mem += randomNum()
mem += randomPosNum()
mem += randomNum()

#random fill position 5 to 127
for i in range(5, 128):
    mem += randomNum()

# dividend msw, lsw, divisior
mem += randomPosNum()
mem += randomNum()
mem += randomPosNum()

# fill the rest
for i in range(131, 257):
    mem += randomNum()

memFile = open(os.path.realpath('.') + '/Bin/mem', 'w+')
memFile.write(mem)
memFile.close()
