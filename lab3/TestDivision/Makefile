COMPILER = ../Compiler/compiler.js

compile: instr

instr: Division.as
	$(COMPILER) Division.as

build: ../Bin/CPU.vvp

../Bin/CPU.vvp: $(wildcard ../CPU/*.sv)
	@make -C .. build

mem: ../Bin/mem
	cp ../Bin/mem .

../Bin/mem: ../PySimulation/MemGen.py
	@make -C .. mem

ref: ref_mem

ref_mem: ../PySimulation/Division.py
	@make -C .. TestDivision/ref_mem

run: cpu.vcd
	open -a Scansion cpu.vcd

cpu.vcd: ../Bin/CPU.vvp ../Bin/mem
	vvp ../Bin/CPU.vvp ../Bin/mem
