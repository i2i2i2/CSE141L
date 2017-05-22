COMPILER = ../Compiler/compiler.js

compile: instr

instr: StringMatch.as
	$(COMPILER) StringMatch.as

build: ../Bin/CPU.vvp

../Bin/CPU.vvp: $(wildcard ../CPU/*.sv) $(wildcard ../CPU/DataMem/*.sv) $(wildcard ../CPU/ALU/*.sv) \
		$(wildcard ../CPU/Regs/*.sv) $(wildcard ../CPU/InstrFetch/*.sv) $(wildcard ../CPU/InstrDecode*.sv)
	@make -C .. build

mem: ../Bin/mem
	cp ../Bin/mem .

../Bin/mem: ../PySimulation/MemGen.py
	@make -C .. mem

ref: ref_mem

ref_mem: ../PySimulation/StrCmp.py
	@make -C .. TestStrCmp/ref_mem

run: cpu.vcd
	open -a Scansion cpu.vcd

cpu.vcd: build mem
	vvp ../Bin/CPU.vvp ../Bin/mem
