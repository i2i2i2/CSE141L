

compile: compile-CORDIC compile-StrCmp compile-Division compile-Custom

compile-CORDIC:
	@make -C TestCORDIC compile

compile-StrCmp:
	@make -C TestStrCmp compile

compile-Division:
	@make -C TestDivision compile

compile-Custom:
	@make -C TestCustom compile

build: Bin/CPU.vvp

Bin/CPU.vvp: $(wildcard CPU/*.sv)
	iverilog -I CPU/ALU \
		-I CPU/DataMem \
		-I CPU/InstrDecode \
		-I CPU/InstrFetch \
		-I CPU/Regs \
		-o Bin/CPU.vvp \
		CPU/SingleCycleCPU.sv

mem: Bin/mem
	cp Bin/mem TestCORDIC
	cp Bin/mem TestStrCmp
	cp Bin/mem TestCustom
	cp Bin/mem TestDivision

Bin/mem: PySimulation/MemGen.py
	PySimulation/MemGen.py
