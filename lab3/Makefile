##############################################################################
# Compile Assembly                                                           #
##############################################################################
compile: compile-CORDIC compile-StrCmp compile-Division compile-Custom

compile-CORDIC: CORDIC/instr

CORDIC/instr: CORDIC/CORDIC.as
	@make -C CORDIC compile

compile-StrCmp: StrCmp/instr

StrCmp/instr: StrCmp/StrCmp.as
	@make -C StrCmp compile

compile-Division: Division/instr

Division/instr: Division/Division.as
	@make -C Division compile

compile-Custom: Custom/instr

Custom/instr: Custom/.as
	@make -C Custom compile

##############################################################################
# Build CPU                                                                  #
##############################################################################
build: Bin/CPU.vvp

Bin/CPU.vvp: $(wildcard CPU/*.sv) $(wildcard CPU/*/*.sv)
	iverilog -I CPU/ALU \
		-I CPU/DataMem \
		-I CPU/InstrDecode \
		-I CPU/InstrFetch \
		-I CPU/Regs \
		-o Bin/CPU.vvp \
		CPU/SingleCycleCPU.sv

##############################################################################
# Create memory                                                              #
##############################################################################
mem: CORDIC/mem StrCmp/mem Custom/mem Division/mem

newMem:
	rm Bin/mem
	make mem

CORDIC/mem: Bin/mem
	cp Bin/mem CORDIC

StrCmp/mem: Bin/mem
	cp Bin/mem StrCmp

Custom/mem: Bin/mem
	cp Bin/mem Custom

Division/mem: Bin/mem
	cp Bin/mem Division

Bin/mem:
	PySimulation/MemGen.py

##############################################################################
# Create ref solution                                                        #
##############################################################################
ref: ref-CORDIC ref-StrCmp ref-Division

ref-CORDIC: CORDIC/ref_mem

CORDIC/ref_mem: Bin/mem PySimulation/CORDIC.py
	PySimulation/CORDIC.py

ref-StrCmp: StrCmp/ref_mem

StrCmp/ref_mem: Bin/mem PySimulation/StrCmp.py
	PySimulation/StrCmp.py

ref-Division: Division/ref_mem

Division/ref_mem: Bin/mem PySimulation/Division.py
	PySimulation/Division.py

##############################################################################
# Run the simulation                                                         #
##############################################################################
