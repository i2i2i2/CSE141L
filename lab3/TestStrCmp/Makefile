COMPILER = ../Compiler/compiler.js

compile: instr

instr: StringMatch.as
	$(COMPILER) StringMatch.as

build: ../CPU.vvp

../CPU.vvp: $(wildcard ../CPU/*.sv)
	@make -C .. build

mem: ../Bin/mem
	cp ../Bin/mem .

../bin/mem: ../PySimulation/MemGen.py
	@make -C .. mem
