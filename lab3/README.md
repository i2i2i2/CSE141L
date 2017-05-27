/*****************************************************************************
  File Name:    README.md
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         May 26, 2017
*****************************************************************************/



In this lab, we implemented the compiler for our architecture, Hexac, which is designed during the Lab 1. 

We include the assembly code (input) in CORDIC.as, Division.as and StrCmp.as, which was written in lab 1.
These three files respectively implement the programs of CORDIC algorithm, division algorithm and String 
matcnh functionality. The compiler/assembler for our assembly code is written in compiler.js, which 
translates the assembly language into machine code.

In the main directory, there is a Makefile to compile the programs. For each implementation of CORDIC,
Division, and StrCmp, we include separate Makefiles to compile the program. In the folder of these 
implementations, we also have a sample machine code of instruction in hexadecimal called instr which 
is translated by our compiler. For each program, we also have memory access recorded in our file. More
than that, there is a lookup table in each implementation to handle branch instruction. By the way, 
the Custom implementation is used to do a basic test. 

The top-level Verilog Model of our design, instantiating the ALU, fetch (program counter) unit,
instruction memory, register file, data memory, and control decoder is included in the CPU file.
For further information about our Verilog Modules, schematic and timing diagrams, please refer to our 
Lab 2 report. 

In the PySimulation, we wrote the python simulation of the three programs to ensure the correctness 
of our design. They are written in python with the same algorithm to produce the correct solution for
CORDIC, Division and String Match.
