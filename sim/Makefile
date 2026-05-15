GHDL=/usr/local/bin/ghdl
A_FLAGS = --std=08 --ieee=synopsys
M_FLAGS = --std=08 --ieee=synopsys 

LD_FILE = \
	../tests.ld

SIM_GENERICS = \
    -gIMEM_FILENAME="imem_testfile.hex" \
    -gDMEM_FILENAME="dmem_testfile.hex"

SIM_TEST = \
    -gIMEM_FILENAME="$(TEST)-imem.hex" \
    -gDMEM_FILENAME="$(DMEM_VAL)"

TEST ?= simple

SPECIAL_TESTS := sw sh sb lw lh lb lhu lbu
ifeq ($(filter $(TEST),$(SPECIAL_TESTS)),$(TEST))
    DMEM_VAL = $(TEST)-dmem.hex
else
    DMEM_VAL = dmem_testfile.hex
endif

TOOLCHAIN_PREFIX ?= riscv32-unknown-elf
TARGET_CFLAGS += -march=rv32i_zicsr -Wall -O0
TARGET_LDFLAGS +=

# --- File Sorgente ---
PACKAGES_FILES := \
    ../src/pp_types.vhd \
    ../src/pp_constants.vhd \
    ../src/pp_utilities.vhd \
    ../src/pp_csr.vhd 

SOURCE_FILES := \
    ../src/pp_counter.vhd \
    ../src/pp_csr_unit.vhd \
    ../src/pp_register_file.vhd \
    ../src/pp_fetch.vhd \
    ../src/pp_alu_control_unit.vhd \
    ../src/pp_imm_decoder.vhd \
    ../src/pp_control_unit.vhd \
    ../src/pp_detect_csr.vhd \
    ../src/pp_decode.vhd \
    ../src/pp_alu_mux.vhd \
    ../src/pp_comparator.vhd \
    ../src/pp_alu.vhd \
    ../src/pp_csr_alu.vhd \
    ../src/pp_execute.vhd \
    ../src/pp_memory.vhd \
    ../src/pp_writeback.vhd \
	../src/pp_rob.vhd \
    ../src/pp_core.vhd 

SOURCE_SOC_FILES := \
	../src/pp_wb_adapter.vhd \
	../src/pp_wb_arbiter.vhd \
	../src/pp_icache.vhd \
	../src/pp_potato.vhd \
	../soc/pp_soc_memory.vhd

TESTBENCH_FILE := \
    ../testbenches/tb_processor.vhd

TESTBENCH_SOC_FILE := \
	../testbenches/tb_soc.vhd

CORE_GTKWAVE_SCRIPT := \
	./gtkscript_core.tcl

SOC_GTKWAVE_SCRIPT := \
	./gtkscript_soc.tcl

.PHONY: all analyse_packages analyse_processor compile_test run_testbench run_test check_syntax clean

#.DEFAULT_GOAL := run_testbench
.DEFAULT_GOAL := run_soc_test

analyse_packages: 
	@echo "--- 1. Analyzing packages (VHDL-2008) ---"
	@set -e; \
	for pkg in $(PACKAGES_FILES); do \
		echo "Analyze: $$pkg"; \
		$(GHDL) -a $(A_FLAGS) $$pkg; \
	done

analyse_processor: analyse_packages 
	@echo "--- 2. Analyzing components ---"
	@set -e; \
	for component in $(SOURCE_FILES); do \
		echo "Analyze: $$component"; \
		$(GHDL) -a $(A_FLAGS) $$component; \
	done

analyse_soc: analyse_processor
	@echo "--- 2b. Analyzing soc ---"
	@set -e; \
	for component in $(SOURCE_SOC_FILES); do \
		echo "Analyze: $$component"; \
		$(GHDL) -a $(A_FLAGS) $$component; \
	done

compile_test: analyse_processor
	@echo "--- 3. Assembly compiling ---"
	@$(TOOLCHAIN_PREFIX)-gcc -c $(TARGET_CFLAGS) -DPOTATO_TEST_ASSEMBLY -Iriscv-tests -o test.o test.s 
	@$(TOOLCHAIN_PREFIX)-ld $(TARGET_LDFLAGS) -T $(LD_FILE) test.o -o test.elf
	@touch imem_testfile.hex dmem_testfile.hex
	@../scripts/extract_hex.sh test.elf imem_testfile.hex dmem_testfile.hex 

run_testbench: compile_test
	@echo "--- 4. Analyzing Testbench ---"
	@$(GHDL) -a $(A_FLAGS) $(TESTBENCH_FILE)
	
	@echo "--- 5. Elaborating Design (mcode) ---"
	@$(GHDL) -e $(M_FLAGS) tb_processor

	@echo "--- 6. Running Simulation & Generating Waveform ---"
	@$(GHDL) -r $(M_FLAGS) tb_processor $(SIM_GENERICS) --ieee-asserts=disable --wave=tb_processor.ghw
	@echo "--- Simulation Finished ---"
	@gtkwave -S $(CORE_GTKWAVE_SCRIPT) tb_processor.ghw &

run_test: analyse_processor
	@cp ../tests-build/$(TEST)-imem.hex . || (echo "ERROR: Impossible to copy the file"; exit 1)
	@-cp ../tests-build/$(TEST)-dmem.hex . || touch $(DMEM_VAL)

	@echo "--- 4. Analyzing Testbench ---"
	@$(GHDL) -a $(A_FLAGS) $(TESTBENCH_FILE)
	
	@echo "--- 5. Elaborating Design (mcode) ---"
	@$(GHDL) -e $(M_FLAGS) tb_processor
	
	@echo "--- 6. Running Simulation & Generating Waveform ---"
	@$(GHDL) -r $(M_FLAGS) tb_processor $(SIM_TEST) --ieee-asserts=disable --wave=tb_processor.ghw
	@echo "--- Simulation Finished ---"
	@gtkwave -S $(CORE_GTKWAVE_SCRIPT) tb_processor.ghw &

run_soc_test: analyse_soc
	@cp ../tests-build/$(TEST)-imem.hex . || (echo "ERROR: Impossible to copy the file"; exit 1)
	@-cp ../tests-build/$(TEST)-dmem.hex . || touch $(DMEM_VAL)

	@echo "--- 4. Analyzing Testbench ---"
	@$(GHDL) -a $(A_FLAGS) $(TESTBENCH_SOC_FILE)
	
	@echo "--- 5. Elaborating Design (mcode) ---"
	@$(GHDL) -e $(M_FLAGS) tb_soc
	
	@echo "--- 6. Running Simulation & Generating Waveform ---"
	@$(GHDL) -r $(M_FLAGS) tb_soc $(SIM_TEST) --ieee-asserts=disable --wave=tb_soc.ghw
	@echo "--- Simulation Finished ---"
	@gtkwave -S $(SOC_GTKWAVE_SCRIPT) tb_soc.ghw &

clean:
	@echo "Cleaning build artifacts..."
	@ghdl --clean
	@rm -f tb_processor tb_soc *.o *.cf e~*.o *.elf *.o *.hex *.ghw

check_syntax: analyse_processor 
	@echo "Checking syntax..."
	@set -e; \
	for f in $(PACKAGES_FILES) $(SOURCE_FILES) $(TESTBENCH_FILE); do \
		echo "Syntax check: $$f"; \
		$(GHDL) -s $(A_FLAGS) $$f; \
	done
	@echo "Syntax check complete."