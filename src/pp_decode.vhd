-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 - 2015 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pp_types.all;
use work.pp_constants.all;
use work.pp_csr.all;

--! @brief Instruction decode unit.
entity pp_decode is
	generic(
		RESET_ADDRESS : std_logic_vector(31 downto 0);
		PROCESSOR_ID  : std_logic_vector(31 downto 0)
	);
	port(
		clk    : in std_logic;
		reset  : in std_logic;

		flush : in std_logic;
		stall : in std_logic;

		-- Instruction input:
		instruction_data    : in std_logic_vector(31 downto 0);
		instruction_address : in std_logic_vector(31 downto 0);
		instruction_ready   : in std_logic;
		instruction_count   : in std_logic;

		-- Register addresses:
		rs1_addr, rs2_addr, rd_addr : out register_address;
		csr_addr : out csr_address;

		-- Shamt value for shift operations:
		shamt  : out std_logic_vector(4 downto 0);
		funct3 : out std_logic_vector(2 downto 0);

		-- Immediate value for immediate instructions:
		immediate : out std_logic_vector(31 downto 0);

		-- Control signals:
		rd_write          : out std_logic;
		branch            : out branch_type;
		alu_x_src         : out alu_operand_source;
		alu_y_src         : out alu_operand_source;
		alu_op            : out alu_operation;
		mem_op            : out memory_operation_type;
		mem_size          : out memory_operation_size;
		count_instruction : out std_logic;
		rob_table1_empty  : in std_logic;
		
		-- Instruction address:
		pc : out std_logic_vector(31 downto 0);
		
		-- CSR control signals:
		csr_write   		: out csr_write_mode;
		csr_use_imm 		: out std_logic;
		stall_csr 			: out std_logic;
		count_instruction_csr 	: out std_logic;

		-- Exception output signals:
		decode_exception       : out std_logic;
		decode_exception_cause : out csr_exception_cause
	);

end entity pp_decode;

architecture behaviour of pp_decode is

	-- Signals used for the instruction decoded
	signal instruction     		: std_logic_vector(31 downto 0);
	signal immediate_value 		: std_logic_vector(31 downto 0);
	-- Signal used to store the previous instruction
	signal prev_instruction     : std_logic_vector(31 downto 0);
	signal prev_pc 				: std_logic_vector(31 downto 0);
	-- FSM for the Decode stage
	type fsm_states is (normal_execution, rob_empty, csr_execution);
    signal state: fsm_states;
	-- Signal used to detect if the next instruction is a CSR one
	signal next_csr_instr : std_logic;

begin

	immediate <= immediate_value;

	-- Extract register addresses from the instruction word:
	rs1_addr <= instruction(19 downto 15);
	rs2_addr <= instruction(24 downto 20);
	rd_addr  <= instruction(11 downto  7);

	-- Extract the shamt value from the instruction word:
	shamt    <= instruction(24 downto 20);

	-- Extract the value specifying which comparison to do in branch instructions:
	funct3 <= instruction(14 downto 12);

	-- Extract the immediate value from the instruction word:
	immediate_decoder: entity work.pp_imm_decoder
		port map(
			instruction => instruction(31 downto 2),
			immediate => immediate_value
		);

	decode_csr_addr: process(immediate_value)
	begin
		if immediate_value(11 downto 0) = CSR_EPC_MRET then
			csr_addr <= CSR_MEPC;
		else
			csr_addr <= immediate_value(11 downto 0);
		end if;
	end process decode_csr_addr;

	control_unit: entity work.pp_control_unit
		port map(
			opcode => instruction(6 downto 2),
			funct3 => instruction(14 downto 12),
			funct7 => instruction(31 downto 25),
			funct12 => instruction(31 downto 20),
			rd_write => rd_write,
			branch => branch,
			alu_x_src => alu_x_src,
			alu_y_src => alu_y_src,
			alu_op => alu_op,
			mem_op => mem_op,
			mem_size => mem_size,
			decode_exception => decode_exception,
			decode_exception_cause => decode_exception_cause,
			csr_write => csr_write,
			csr_imm => csr_use_imm
		);

	-- Identify if the next instruction is a CSR one
	detect_csr: entity work.pp_detect_csr
		port map(
			opcode => instruction_data(6 downto 2),
			funct3 => instruction_data(14 downto 12),
			csr_instr => next_csr_instr
		);

	-- FSM for the Decode stage
	decoder_managing: process (clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				instruction <= RISCV_NOP;
				pc <= RESET_ADDRESS;
				prev_instruction <= RISCV_NOP;
				prev_pc <= RESET_ADDRESS;
				count_instruction <= '0';
				count_instruction_csr <= '0';
				state <= normal_execution;
				stall_csr <= '0';
			elsif flush = '1' then
				instruction <= RISCV_NOP;
				count_instruction <= '0';
				count_instruction_csr <= '0';
				state <= normal_execution;
				stall_csr <= '0';
			else
				case state is
					when normal_execution =>
						if stall = '1' or instruction_ready = '0' then
							count_instruction <= '0';
							count_instruction_csr <= '0';
						else
							-- Instruction decoded
							instruction <= instruction_data;
							pc <= instruction_address;
							-- Store the instruction 
							prev_instruction <= instruction_data;
							prev_pc <= instruction_address;
							-- Next State evaluation
							if next_csr_instr = '1' then
								if rob_table1_empty = '0' then
									-- The ROB has to be emptied
									state <= rob_empty;
									stall_csr <= '1';
									instruction <= RISCV_NOP;
									count_instruction <= '0';
									count_instruction_csr <= '0';
								else
									-- CSR can be directly executed because ROB empty
									state <= normal_execution;
									count_instruction <= '0';
									count_instruction_csr <= '1';
								end if;
							else
								-- No CSR instruction detected 
								stall_csr <= '0';
								state <= normal_execution;
								count_instruction <= instruction_count;
								count_instruction_csr <= '0';
							end if;
						end if;
					
					when rob_empty =>
						stall_csr <= '1';
						count_instruction <= '0';
						count_instruction_csr <= '0';
						-- Next state evaluation
						if rob_table1_empty = '0' then
							-- Continue to wait the ROB
							state <= rob_empty;
						else
							-- ROB is empty, it's possible to execute CSR instr
							state <= csr_execution;
							count_instruction <= '0';
							count_instruction_csr <= '1';
							instruction <= prev_instruction;
							pc <= prev_pc;
						end if;

					when csr_execution =>
						-- CSR is in execution, return to normality 
						state <= normal_execution;
						instruction <= instruction_data;
						count_instruction <= instruction_count;
						pc <= instruction_address;
						count_instruction_csr <= '0';
						stall_csr <= '0';

					when others => 
				end case;
			end if;
		end if;
	end process decoder_managing;


end architecture behaviour;
