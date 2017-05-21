##############################################################################
# Compile Assembly                                                           #
##############################################################################
compile: compile-CORDIC compile-StrCmp compile-Division compile-Custom

compile-CORDIC: TestCORDIC/instr

TestCORDIC/instr: TestCORDIC/CORDIC.as
	@make -C TestCORDIC compile

compile-StrCmp: TestStrCmp/instr

TestStrCmp/instr: StringMatch.as
	@make -C TestStrCmp compile

compile-Division: TestDivision/instr

TestDivision/instr: TestDivision/Division.as
	@make -C TestDivision compile

compile-Custom: TestCustom/instr

TestCustom/instr: TestCustom/test.as
	@make -C TestCustom compile

##############################################################################
# Build CPU                                                                  #
##############################################################################
build: Bin/CPU.vvp

Bin/CPU.vvp: $(wildcard CPU/*.sv)
	iverilog -I CPU/ALU \
		-I CPU/DataMem \
		-I CPU/InstrDecode \
		-I CPU/InstrFetch \
		-I CPU/Regs \
		-o Bin/CPU.vvp \
		CPU/SingleCycleCPU.sv

##############################################################################
# Create Test memory                                                         #
##############################################################################
mem: Bin/mem

Bin/mem:
	PySimulation/MemGen.py

##############################################################################
# Create ref solution                                                        #
##############################################################################
ref: ref-CORDIC ref-StrCmp ref-Division

ref-CORDIC: TestCORDIC/ref_mem

TestCORDIC/ref_mem: Bin/mem
	PySimulation/CORDIC.py

ref-StrCmp: TestStrCmp/ref_mem

TestStrCmp/ref_mem: Bin/mem
	PySimulation/StrCmp.py

ref-Division: TestDivision/ref_mem

TestDivision/ref_mem: Bin/mem
	PySimulation/Division.py
