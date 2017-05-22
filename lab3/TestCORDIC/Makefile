COMPILER = ../Compiler/compiler.js

all: sol_mem ref_mem

diff: sol_mem ref_mem
	diff sol_mem ref_mem

compile: instr

instr: CORDIC.as
	$(COMPILER) CORDIC.as

build: ../Bin/CPU.vvp

../Bin/CPU.vvp: $(wildcard ../CPU/*.sv) $(wildcard ../CPU/*/*.sv)
	@make -C .. build

mem: ../Bin/mem
	cp ../Bin/mem .

../Bin/mem: ../PySimulation/MemGen.py
	@make -C .. mem

ref: ref_mem

ref_mem: ../PySimulation/CORDIC.py mem
	@make -C .. TestCORDIC/ref_mem

run: cpu.vcd sol_mem
	open -a Scansion cpu.vcd

cpu.vcd sol_mem: ../Bin/CPU.vvp mem instr
	vvp ../Bin/CPU.vvp &> /dev/null

newMem:
	@make -C .. newMem

newTest:
	make newMem
	make diff

clean:
	rm *.vcd instr branch *mem ../Bin/*

new:
	make clean
	make all
