-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 - 2015 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pp_types.all;
use work.pp_constants.all;
use work.pp_utilities.all;
use work.pp_csr.all;

--! @brief The Potato Processor is a simple processor core for use in FPGAs.
entity pp_core is
	generic(
		PROCESSOR_ID           : std_logic_vector(31 downto 0) := x"00000000"; --! Processor ID.
		RESET_ADDRESS          : std_logic_vector(31 downto 0) := x"00000000"; --! Address of the first instruction to execute.
		MTIME_DIVIDER          : positive := 5;                                --! Divider for the clock driving the MTIME counter
		TIME_DIVIDER           : positive := 5;                                --! Divider for the clock dirivng the TIME counter
		MAIN_TABLE			   : positive := 16;								   --! Length of the ROB's Main Table
		THREAD_TABLE		   : positive := 1								   --! Length of the ROB's THREAD Table
	);
	port(
		-- Control inputs:
		clk       : in std_logic; --! Processor clock
		reset     : in std_logic; --! Reset signal

		-- Instruction memory interface:
		imem_address : out std_logic_vector(31 downto 0); --! Address of the next instruction
		imem_data_in : in  std_logic_vector(31 downto 0); --! Instruction input
		imem_req     : out std_logic;
		imem_ack     : in  std_logic;

		-- Data memory interface:
		dmem_address   : out std_logic_vector(31 downto 0);  --! Data address
		dmem_data_in   : in  std_logic_vector(31 downto 0);  --! Input from the data memory
		dmem_data_out  : out std_logic_vector(31 downto 0);  --! Ouptut to the data memory
		dmem_data_size : out std_logic_vector( 1 downto 0);  --! Size of the data, 1 = 8 bits, 2 = 16 bits, 0 = 32 bits. 
		dmem_read_req  : out std_logic;                      --! Data memory read request
		dmem_read_ack  : in  std_logic;                      --! Data memory read acknowledge
		dmem_write_req : out std_logic;                      --! Data memory write request
		dmem_write_ack : in  std_logic;                      --! Data memory write acknowledge

		-- Test interface:
		test_context_out : out test_context;                 --! Test context output.

		-- External interrupt input:
		irq : in std_logic_vector(7 downto 0) --! IRQ inputs.
	);
end entity pp_core;

architecture behaviour of pp_core is

	-- Flush signals:
	signal flush_if, flush_id, flush_ex, flush_mem, flush_wb : std_logic;

	-- Stall signals:
	signal stall_if, stall_id, stall_ex, stall_mem, stall_wb, id_stall_csr : std_logic;
	signal stall_rob, rob_stall_fetch_decode : std_logic;

	-- Signals used to determine if an instruction should be counted by the instret counter:
	signal if_count_instruction, id_count_instruction  : std_logic;
	signal ex_count_instruction, mem_count_instruction : std_logic;
	signal wb_count_instruction : std_logic;

	-- Signals used to determine if an instruction is a CSR 
	signal ex_count_instruction_csr, mem_count_instruction_csr : std_logic;
	signal wb_count_instruction_csr : std_logic;

	-- CSR read port signals:
	signal csr_read_data      : std_logic_vector(31 downto 0);
	signal csr_read_address, csr_read_address_p : csr_address;

	-- Status register outputs:
	signal mtvec   : std_logic_vector(31 downto 0);
	signal mie     : std_logic_vector(31 downto 0);
	signal ie, ie1 : std_logic;

	-- Internal interrupt signals:
	signal software_interrupt, timer_interrupt : std_logic;

	-- Branch targets:
	signal exception_target, branch_target : std_logic_vector(31 downto 0);
	signal branch_taken, exception_taken   : std_logic;

	-- Register file read ports:
	signal rf_rs1_data, rf_rs2_data     : std_logic_vector(31 downto 0);

	-- Register file write ports:
	signal rd_addr	  : register_address;
	signal rd_write   : std_logic;
	signal rd_data    : std_logic_vector(31 downto 0);

	-- Data memory signals:
	signal sg_dmem_address  : std_logic_vector(31 downto 0);
	signal dmem_address_p   : std_logic_vector(31 downto 0);
	signal dmem_data_size_p : std_logic_vector(1 downto 0);
	signal dmem_data_out_p  : std_logic_vector(31 downto 0);
	signal dmem_read_req_p  : std_logic;
	signal dmem_write_req_p : std_logic;
	signal stall_mem_p 		: std_logic;
	signal ack_p		   	: std_logic;

	-- Fetch stage signals:
	signal if_instruction, if_pc : std_logic_vector(31 downto 0);
	signal if_instruction_ready  : std_logic;

	-- Decode stage signals:
	signal id_funct3          : std_logic_vector(2 downto 0);
	signal id_rd_address      : register_address;
	signal id_rd_write        : std_logic;
	signal id_rs1_address     : register_address;
	signal id_rs2_address     : register_address;
	signal id_csr_address     : csr_address;
	signal id_csr_write       : csr_write_mode;
	signal id_csr_use_immediate : std_logic;
	signal id_shamt           : std_logic_vector(4 downto 0);
	signal id_immediate       : std_logic_vector(31 downto 0);
	signal id_branch          : branch_type;
	signal id_alu_x_src, id_alu_y_src : alu_operand_source;
	signal id_alu_op          : alu_operation;
	signal id_mem_op          : memory_operation_type;
	signal id_mem_size        : memory_operation_size;
	signal id_pc              : std_logic_vector(31 downto 0);
	signal id_exception       : std_logic;
	signal id_exception_cause : csr_exception_cause;
	signal id_count_instruction_csr : std_logic;

	-- ROB stage signals:
	signal rob_alu_x_addr 	: register_address;
	signal rob_alu_y_addr 	: register_address;
	signal rob_rd_addr 		: register_address;
	signal rob_rd_write 	: std_logic;
	signal rob_result 		: std_logic_vector(31 downto 0);
	signal rob_num  		: integer range 0 to MAIN_TABLE;
	signal rob_alu_op 		: alu_operation;
	signal rob_alu_x_src 	: alu_operand_source;
	signal rob_alu_y_src 	: alu_operand_source;
	signal rob_immediate 	: std_logic_vector(31 downto 0);
	signal rob_shamt 		: std_logic_vector(4 downto 0);
	signal rob_mem_op		: memory_operation_type;
	signal rob_mem_size		: memory_operation_size;
	signal rob_branch		: branch_type;
	signal rob_funct3		: std_logic_vector(2 downto 0);
	signal rob_pc 			: std_logic_vector(31 downto 0);
	signal rob_table_empty  : std_logic;

	-- Multiplexer for Register File signals:
	signal mux_rf_rs1_addr : register_address;
	signal mux_rf_rs2_addr : register_address;
	signal mux_rf_rd_addr  : register_address;
	signal mux_rf_rd_data  : std_logic_vector(31 downto 0);
	signal mux_rf_rd_write : std_logic;

	-- Multiplexer for Execute signals:
	signal mux_exe_rs1_address  : register_address;
	signal mux_exe_rs2_address  : register_address;
	signal mux_exe_alu_x_src    : alu_operand_source;
	signal mux_exe_alu_y_src    : alu_operand_source;
	signal mux_exe_rd_write	    : std_logic;
	signal mux_exe_rd_addr	    : register_address;
	signal mux_exe_alu_op	    : alu_operation;

	-- Execute stage signals:
	signal ex_dmem_address   : std_logic_vector(31 downto 0);
	signal ex_dmem_data_size : std_logic_vector(1 downto 0);
	signal ex_dmem_data_out  : std_logic_vector(31 downto 0);
	signal ex_dmem_read_req  : std_logic;
	signal ex_dmem_write_req : std_logic;
	signal ex_rd_address     : register_address;
	signal ex_rd_data        : std_logic_vector(31 downto 0);
	signal ex_rd_write       : std_logic;
	signal ex_pc             : std_logic_vector(31 downto 0);
	signal ex_csr_address    : csr_address;
	signal ex_csr_write      : csr_write_mode;
	signal ex_csr_data       : std_logic_vector(31 downto 0);
	signal ex_branch         : branch_type;
	signal ex_mem_op         : memory_operation_type;
	signal ex_mem_size       : memory_operation_size;
	signal ex_num 			 : integer range 0 to MAIN_TABLE;
	signal ex_jump_taken	 : std_logic;
	signal ex_jump_target  	 : std_logic_vector(31 downto 0);
	signal ex_exception_context 	: csr_exception_context;
	signal to_exe_count_instruction : std_logic;
	

	-- Memory stage signals:
	signal mem_rd_write    : std_logic;
	signal mem_rd_address  : register_address;
	signal mem_rd_data     : std_logic_vector(31 downto 0);
	signal mem_csr_address : csr_address;
	signal mem_csr_write   : csr_write_mode;
	signal mem_csr_data    : std_logic_vector(31 downto 0);
	signal mem_mem_op      : memory_operation_type;
	signal mem_op_num 	   : integer range 0 to MAIN_TABLE;
	signal mem_jump_taken  : std_logic;
	signal mem_jump_target : std_logic_vector(31 downto 0);
	signal mem_exception         : std_logic;
	signal mem_exception_context : csr_exception_context;

	-- Writeback signals:
	signal wb_rd_address  : register_address;
	signal wb_rd_data     : std_logic_vector(31 downto 0);
	signal wb_rd_write    : std_logic;
	signal wb_csr_address : csr_address;
	signal wb_csr_write   : csr_write_mode;
	signal wb_csr_data    : std_logic_vector(31 downto 0);
	signal wb_exception         : std_logic;
	signal wb_exception_context : csr_exception_context;
	signal wb_dmem_address  : std_logic_vector(31 downto 0);
	signal wb_num 			: integer range 0 to MAIN_TABLE;
	signal wb_jump_taken 	: std_logic;
	signal wb_jump_target	: std_logic_vector(31 downto 0);

begin

	stall_id <= rob_stall_fetch_decode;
	stall_if <= rob_stall_fetch_decode or id_stall_csr;
	stall_ex <= stall_mem;
	stall_mem <= to_std_logic(memop_is_load(mem_mem_op) and dmem_read_ack = '0')
		or to_std_logic(mem_mem_op = MEMOP_TYPE_STORE and dmem_write_ack = '0');
	stall_wb <= stall_mem;
	stall_rob <= stall_mem;

	flush_if  <= (branch_taken or exception_taken) and not stall_if;
	flush_id  <= (branch_taken or exception_taken) and not stall_id;
	flush_ex  <= (branch_taken or exception_taken) and not stall_ex;
	flush_mem <= (branch_taken or exception_taken) and not stall_mem;
	flush_wb  <= (branch_taken or exception_taken) and not stall_wb;

	------- Control and status module -------
	csr_unit: entity work.pp_csr_unit
			generic map(
				PROCESSOR_ID  => PROCESSOR_ID,
				MTIME_DIVIDER => MTIME_DIVIDER,
				TIME_DIVIDER  => TIME_DIVIDER
			) port map(
				clk 					=> clk,
				reset 					=> reset,
				irq 					=> irq,
				count_instruction 		=> wb_count_instruction,
				count_instruction_csr 	=> wb_count_instruction_csr,
				test_context_out 		=> test_context_out,
				read_address 			=> csr_read_address,
				read_data_out 			=> csr_read_data,
				write_address 			=> wb_csr_address,
				write_data_in 			=> wb_csr_data,
				write_mode 				=> wb_csr_write,
				exception_context 		=> wb_exception_context,
				exception_context_write => wb_exception,
				mie_out 				=> mie,
				mtvec_out	 			=> mtvec,
				ie_out 					=> ie,
				ie1_out 				=> ie1,
				software_interrupt_out 	=> software_interrupt,
				timer_interrupt_out 	=> timer_interrupt
			);

	csr_read_address <= id_csr_address when stall_ex = '0' else csr_read_address_p;
	store_previous_csr_addr: process(clk, stall_ex)
	begin
		if rising_edge(clk) and stall_ex = '0' then
			csr_read_address_p <= id_csr_address;
		end if;
	end process store_previous_csr_addr;

	------- Instruction Fetch (IF) Stage -------
	fetch: entity work.pp_fetch
		generic map(
			RESET_ADDRESS => RESET_ADDRESS
		) port map(
			clk 				=> clk,
			reset 				=> reset,
			imem_address 		=> imem_address,
			imem_data_in 		=> imem_data_in,
			imem_req 			=> imem_req,
			imem_ack 			=> imem_ack,
			stall 				=> stall_if,
			flush 				=> flush_if,
			branch 				=> branch_taken,
			exception 			=> exception_taken,
			branch_target 		=> branch_target,
			evec 				=> exception_target,
			instruction_data 	=> if_instruction,
			instruction_address => if_pc,
			instruction_ready 	=> if_instruction_ready
		);
	if_count_instruction <= if_instruction_ready;

	------- Instruction Decode (ID) Stage -------
	decode: entity work.pp_decode
		generic map(
			RESET_ADDRESS => RESET_ADDRESS,
			PROCESSOR_ID  => PROCESSOR_ID
		) port map(
			clk 					=> clk,
			reset 					=> reset, 
			flush 					=> flush_id,
			stall 					=> stall_id,
			instruction_data 		=> if_instruction,
			instruction_address 	=> if_pc,
			instruction_ready 		=> if_instruction_ready,
			instruction_count 		=> if_count_instruction,
			funct3 					=> id_funct3,
			rs1_addr 				=> id_rs1_address,
			rs2_addr 				=> id_rs2_address,
			rd_addr 				=> id_rd_address,
			csr_addr 				=> id_csr_address,
			shamt 					=> id_shamt,
			immediate 				=> id_immediate,
			rd_write 				=> id_rd_write,
			branch 					=> id_branch,
			alu_x_src 				=> id_alu_x_src,
			alu_y_src 				=> id_alu_y_src,
			alu_op 					=> id_alu_op,
			mem_op 					=> id_mem_op,
			mem_size 				=> id_mem_size,
			count_instruction	 	=> id_count_instruction,
			count_instruction_csr 	=> id_count_instruction_csr,
			pc	 					=> id_pc,
			csr_write 				=> id_csr_write,
			csr_use_imm 			=> id_csr_use_immediate,
			stall_csr 				=> id_stall_csr,
			rob_table1_empty 		=> rob_table_empty,
			decode_exception 		=> id_exception,
			decode_exception_cause 	=> id_exception_cause
		);

		------- Register file -------
	regfile: entity work.pp_register_file
		port map(
			clk  	 => clk,
			rs1_addr => mux_rf_rs1_addr,
			rs2_addr => mux_rf_rs2_addr,
			rs1_data => rf_rs1_data,
			rs2_data => rf_rs2_data,
			rd_addr  => mux_rf_rd_addr,
			rd_data  => mux_rf_rd_data,
			rd_write => mux_rf_rd_write
		);
		
	mux_rf_rs1_addr <= rob_alu_x_addr  when id_count_instruction_csr = '0' else id_rs1_address;
	mux_rf_rs2_addr <= rob_alu_y_addr  when id_count_instruction_csr = '0' else id_rs2_address;
	mux_rf_rd_addr  <= rob_rd_addr  when wb_count_instruction_csr = '0' else wb_rd_address;
	mux_rf_rd_data  <= rob_result   when wb_count_instruction_csr = '0' else wb_rd_data;
	mux_rf_rd_write <= rob_rd_write when wb_count_instruction_csr = '0' else wb_rd_write;	

	------- Reorder Buffer (ROB) Stage -------

	--! Reorder Buffer Declaration
	reorder_buffer: entity work.rob 
        generic map(
	    	NUM_INSTRUCTIONS => MAIN_TABLE
	    ) port map (
            clk             		=> clk,
            reset             		=> reset,
			stall					=> stall_rob,
			count_instruction		=> id_count_instruction,
			pc_in					=> id_pc,
            alu_op_in        		=> id_alu_op,
			alu_x_src_in			=> id_alu_x_src,
			alu_x_addr_in			=> id_rs1_address,
			alu_y_src_in			=> id_alu_y_src,
			alu_y_addr_in			=> id_rs2_address,
			rd_addr_in				=> id_rd_address,
			rd_write_in				=> id_rd_write,
			immediate_in			=> id_immediate,
			shamt_in				=> id_shamt,
			mem_op_in  				=> id_mem_op,
			mem_size_in				=> id_mem_size,
			branch_in 				=> id_branch,
			funct3_in 				=> id_funct3,
            execution_num  			=> rob_num,
			execution_alu_op 		=> rob_alu_op,
			execution_alu_x_src 	=> rob_alu_x_src,
			execution_alu_x_addr 	=> rob_alu_x_addr,
			execution_alu_y_src 	=> rob_alu_y_src,
			execution_alu_y_addr 	=> rob_alu_y_addr,
			execution_immediate 	=> rob_immediate,
			execution_shamt 		=> rob_shamt,
        	execution_mem_op        => rob_mem_op,
        	execution_mem_size      => rob_mem_size,
			execution_pc 			=> rob_pc,
			execution_branch 		=> rob_branch,
			execution_funct3 		=> rob_funct3,
			completed_count_instr 	=> wb_count_instruction,
            completed_num  			=> wb_num,
			completed_res			=> wb_rd_data,
			completed_jump_taken 	=> wb_jump_taken,
			completed_jump_target 	=> wb_jump_target,
			commit_rd_addr 			=> rob_rd_addr,
			commit_rd_write 		=> rob_rd_write,
			commit_res 				=> rob_result,
			commit_jump_target 		=> branch_target,
			commit_jump_taken 		=> branch_taken,
			commit_num 				=> open, -- Testing signals
			commit_op				=> open, -- Testing signals 
			commit_x_src 			=> open, -- Testing signals
        	commit_y_src 			=> open, -- Testing signals
			commit_mem_op			=> open, -- Testing signals
			commit_mem_size			=> open, -- Testing signals		
			fetch_enable			=> rob_stall_fetch_decode,
			rob_empty 				=> rob_table_empty
	    );

	to_exe_count_instruction <= '1' when rob_num /= MAIN_TABLE or id_count_instruction_csr = '1' else '0';

	------- Execute (EX) Stage -------
	execute: entity work.pp_execute
		generic map(
	    	LENGTH_MAIN => MAIN_TABLE
		) port map(
			clk 						=> clk,
			reset 						=> reset,
			stall 						=> stall_ex,
			flush 						=> flush_ex,
			irq 						=> irq,
			software_interrupt 			=> software_interrupt,
			timer_interrupt 			=> timer_interrupt,
			dmem_address 				=> ex_dmem_address,
			dmem_data_size	 			=> ex_dmem_data_size,
			dmem_data_out 				=> ex_dmem_data_out,
			dmem_read_req 				=> ex_dmem_read_req,
			dmem_write_req 				=> ex_dmem_write_req,
			rs1_addr_in 				=> mux_exe_rs1_address,
			rs2_addr_in 				=> mux_exe_rs2_address,
			rd_addr_in 					=> mux_exe_rd_addr,
			rd_addr_out 				=> ex_rd_address,
			rs1_data_in 				=> rf_rs1_data,
			rs2_data_in 				=> rf_rs2_data,
			shamt_in 					=> rob_shamt,
			immediate_in 				=> rob_immediate,
			funct3_in 					=> rob_funct3,
			pc_in 						=> rob_pc,
			pc_out 						=> ex_pc,
			csr_addr_in 				=> csr_read_address,
			csr_addr_out 				=> ex_csr_address,
			csr_write_in 				=> id_csr_write,
			csr_write_out 				=> ex_csr_write,
			csr_value_in 				=> csr_read_data,
			csr_value_out 				=> ex_csr_data,
			csr_use_immediate_in 		=> id_csr_use_immediate,
			alu_op_in 					=> mux_exe_alu_op,
			rob_op_num_in				=> rob_num,
			exe_op_num_out				=> ex_num,
			alu_x_src_in 				=> mux_exe_alu_x_src,
			alu_y_src_in 				=> mux_exe_alu_y_src,
			rd_write_in 				=> mux_exe_rd_write,
			rd_write_out 				=> ex_rd_write,
			rd_data_out 				=> ex_rd_data,
			branch_in 					=> rob_branch,
			branch_out		 			=> ex_branch,
			mem_op_in 					=> rob_mem_op,
			mem_op_out 					=> ex_mem_op,
			mem_size_in 				=> rob_mem_size,
			mem_size_out 				=> ex_mem_size,
			count_instruction_in 		=> to_exe_count_instruction, 
			count_instruction_out 		=> ex_count_instruction,
			count_instruction_csr_in 	=> id_count_instruction_csr, 
			count_instruction_csr_out 	=> ex_count_instruction_csr,
			ie_in 						=> ie,
			ie1_in 						=> ie1,
			mie_in 						=> mie,
			mtvec_in 					=> mtvec,
			mtvec_out 					=> exception_target,
			decode_exception_in 		=> id_exception,
			decode_exception_cause_in 	=> id_exception_cause,
			exception_out 				=> exception_taken,
			exception_context_out 		=> ex_exception_context,
			jump_out 					=> ex_jump_taken,
			jump_target_out 			=> ex_jump_target,
			mem_rd_write 				=> mem_rd_write,
			mem_rd_addr 				=> mem_rd_address,
			mem_rd_value 				=> mem_rd_data,
			mem_csr_addr 				=> mem_csr_address,
			mem_csr_data				=> mem_csr_data,
			mem_csr_write 				=> mem_csr_write,
			mem_exception 				=> mem_exception,
			mem_count_instr_csr			=> mem_count_instruction_csr,
			wb_rd_write 				=> wb_rd_write,
			wb_rd_addr 					=> wb_rd_address,
			wb_rd_value 				=> wb_rd_data,
			wb_csr_addr 				=> wb_csr_address,
			wb_csr_data 				=> wb_csr_data,
			wb_csr_write 				=> wb_csr_write,
			wb_exception 				=> wb_exception,
			wb_count_instr_csr			=> wb_count_instruction_csr,
			mem_mem_op 					=> mem_mem_op
		);

	mux_exe_rs1_address <= rob_alu_x_addr when id_count_instruction_csr = '0' else id_rs1_address;
	mux_exe_rs2_address <= rob_alu_y_addr when id_count_instruction_csr = '0' else id_rs2_address;
	mux_exe_alu_x_src 	<= rob_alu_x_src when id_count_instruction_csr = '0' else id_alu_x_src;
	mux_exe_alu_y_src 	<= rob_alu_y_src when id_count_instruction_csr = '0' else id_alu_y_src;
	mux_exe_rd_write 	<= '0' when id_count_instruction_csr = '0' else id_rd_write;
	mux_exe_rd_addr 	<= (others => '0') when id_count_instruction_csr = '0' else id_rd_address;
	mux_exe_alu_op 		<= rob_alu_op when id_count_instruction_csr = '0' else id_alu_op;

	dmem_address 	<= dmem_address_p   when (stall_mem = '0' and stall_mem_p = '1') or stall_mem = '1' else ex_dmem_address;
	sg_dmem_address <= dmem_address_p   when (stall_mem = '0' and stall_mem_p = '1') or stall_mem = '1' else ex_dmem_address;
	dmem_data_size 	<= dmem_data_size_p when (stall_mem = '0' and stall_mem_p = '1') or stall_mem = '1' else ex_dmem_data_size;
	dmem_data_out 	<= dmem_data_out_p  when (stall_mem = '0' and stall_mem_p = '1') or stall_mem = '1' else ex_dmem_data_out;
	dmem_read_req 	<= dmem_read_req_p  when (stall_mem = '0' and stall_mem_p = '1') or stall_mem = '1' else ex_dmem_read_req;
	dmem_write_req	<= dmem_write_req_p when (stall_mem = '0' and stall_mem_p = '1') or stall_mem = '1' else ex_dmem_write_req;

	store_previous_stall_mem: process(clk, stall_mem)
	begin
		if rising_edge(clk) then
			stall_mem_p <= stall_mem;
			ack_p <= dmem_read_ack;
		end if;
	end process store_previous_stall_mem;

	store_previous_dmem_address: process(clk, stall_mem)
	begin
		if rising_edge(clk) and stall_mem = '0' then
			dmem_address_p   <= ex_dmem_address;
			dmem_data_size_p <= ex_dmem_data_size;
			dmem_data_out_p  <= ex_dmem_data_out;
			dmem_read_req_p  <= ex_dmem_read_req;
			dmem_write_req_p <= ex_dmem_write_req;
		end if;
	end process store_previous_dmem_address;

	
	------- Memory (MEM) Stage -------
	memory: entity work.pp_memory
		generic map(
	    	LENGTH_MAIN => MAIN_TABLE
		) port map(
			clk 					=> clk,
			reset 					=> reset,
			flush					=> flush_mem,
			stall 					=> stall_mem,
			dmem_data_in 			=> dmem_data_in,
			dmem_read_ack 			=> dmem_read_ack,
			dmem_write_ack 			=> dmem_write_ack,
			pc 						=> ex_pc,
			jump_taken_in			=> ex_jump_taken, 
			jump_target_in			=> ex_jump_target,
			jump_taken_out			=> mem_jump_taken, 
			jump_target_out			=> mem_jump_target,
			rd_write_in 			=> ex_rd_write,
			rd_write_out 			=> mem_rd_write,
			rd_data_in 				=> ex_rd_data,
			rd_data_out 			=> mem_rd_data,
			rd_addr_in 				=> ex_rd_address,
			rd_addr_out 			=> mem_rd_address,
			branch 					=> ex_branch,
			mem_op_num 				=> ex_num,
			wb_op_num 				=> mem_op_num,
			mem_op_in 				=> ex_mem_op,
			mem_op_out 				=> mem_mem_op,
			mem_size_in 			=> ex_mem_size,
			count_instr_in  		=> ex_count_instruction,
			count_instr_out 		=> mem_count_instruction,
			count_instr_csr_in  	=> ex_count_instruction_csr,
			count_instr_csr_out 	=> mem_count_instruction_csr,
			exception_in 			=> exception_taken,
			exception_out 			=> mem_exception, 
			exception_context_in 	=> ex_exception_context,
			exception_context_out 	=> mem_exception_context,
			csr_addr_in 			=> ex_csr_address,
			csr_addr_out 			=> mem_csr_address,
			csr_write_in 			=> ex_csr_write,
			csr_write_out 			=> mem_csr_write,
			csr_data_in 			=> ex_csr_data,
			csr_data_out 			=> mem_csr_data
		);

	------- Writeback (WB) Stage -------
	writeback: entity work.pp_writeback
		generic map(
	    	LENGTH_MAIN => MAIN_TABLE
		) port map (
			clk 				=> clk,
			reset	 			=> reset,
			flush				=> flush_wb,
			stall 				=> stall_wb,
			count_instr_in 		=> mem_count_instruction,
			count_instr_out 	=> wb_count_instruction,
			count_instr_csr_in 	=> mem_count_instruction_csr,
			count_instr_csr_out => wb_count_instruction_csr,
			exception_ctx_in 	=> mem_exception_context,
			exception_ctx_out 	=> wb_exception_context,
			exception_in  		=> mem_exception,
			exception_out 		=> wb_exception,
			csr_write_in  		=> mem_csr_write,
			csr_write_out 		=> wb_csr_write,
			csr_data_in  		=> mem_csr_data,
			csr_data_out 		=> wb_csr_data,
			csr_addr_in  		=> mem_csr_address,
			csr_addr_out 		=> wb_csr_address,
			rd_addr_in   		=> mem_rd_address,
			rd_addr_out  		=> wb_rd_address,
			rd_write_in  		=> mem_rd_write,
			rd_write_out 		=> wb_rd_write,
			rd_data_in  		=> mem_rd_data,
			rd_data_out 		=> wb_rd_data,
			op_num_in   		=> mem_op_num,
			op_num_out  		=> wb_num,
			jump_taken_in		=> mem_jump_taken, 
			jump_target_in		=> mem_jump_target,
			jump_taken_out		=> wb_jump_taken, 
			jump_target_out		=> wb_jump_target,
			dmem_addr_in		=> sg_dmem_address,
			dmem_addr_out 		=> wb_dmem_address
		);

end architecture behaviour;
 
