COMPILER=../Compiler/compiler.js
DIR= $(notdir $(CURDIR:%/=%))

all: sol_mem ref_mem

##############################################################################
# Compile Assembly                                                           #
##############################################################################
compile: instr

instr: $(DIR).as
	$(COMPILER) $(DIR).as

##############################################################################
# Build CPU                                                                  #
##############################################################################
build: ../Bin/CPU.vvp

../Bin/CPU.vvp: $(wildcard ../CPU/*.sv) $(wildcard ../CPU/*/*.sv)
	@make -C .. build

##############################################################################
# Create memory                                                              #
##############################################################################
mem: ../Bin/mem
	cp ../Bin/mem .

../Bin/mem: ../PySimulation/MemGen.py
	@make -C .. mem

##############################################################################
# Create ref solution                                                        #
##############################################################################
ref: ref_mem

ref_mem: ../PySimulation/$(DIR).py mem
	@make -C .. $(DIR)/ref_mem

##############################################################################
# Run the simulation                                                         #
##############################################################################
run: cpu.vcd sol_mem
	open -a Scansion cpu.vcd

cpu.vcd sol_mem: ../Bin/CPU.vvp mem instr
	vvp ../Bin/CPU.vvp &> /dev/null

##############################################################################
# Run Test                                                                   #
##############################################################################
newTest:
	make newMem
	make diff

newMem:
	@make -C .. newMem

diff: sol_mem ref_mem
	diff sol_mem ref_mem

##############################################################################
# Build Everything new                                                       #
##############################################################################
clean:
	rm *.vcd instr branch *mem ../Bin/*

new:
	make clean
	make all
