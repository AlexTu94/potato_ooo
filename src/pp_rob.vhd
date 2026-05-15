library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pp_types.all;

--! Custom Reorder Buffer used to manage a out of order processor
entity rob is
    generic(
		NUM_INSTRUCTIONS : natural := 8 --! Number of instructions holded in the table
	);
	port(
        --! Control signals
        clk          : in std_logic;       --! Clock
        reset        : in std_logic;       --! Reset low active
        stall        : in std_logic;       --! Execution Stall
        count_instruction : in std_logic;  --! Enable to fetch the instruction
        fetch_enable : out std_logic;      --! Stall the fetch in case of full table 
        rob_empty    : out std_logic;      --! Assert if the table is empty 
        --! Instruction decoded
        pc_in          : in std_logic_vector(31 downto 0); --! Instruction Address
        alu_op_in      : in alu_operation;                 --! ALU operation
        alu_x_src_in   : in alu_operand_source;            --! Type of resource for rs1
        alu_x_addr_in  : in std_logic_vector(4 downto 0);  --! Register address of rs1
        alu_y_src_in   : in alu_operand_source;            --! Type of resource for rs2
        alu_y_addr_in  : in std_logic_vector(4 downto 0);  --! Register address of rs2
        rd_addr_in     : in std_logic_vector(4 downto 0);  --! Destination Register
        rd_write_in    : in std_logic;                     --! Define if the instruction write in the rf
        immediate_in   : in std_logic_vector(31 downto 0); --! Immediate value
        shamt_in       : in std_logic_vector(4 downto 0);  --! Shamt value
        mem_op_in      : in memory_operation_type;         --! Memory operation 
		mem_size_in    : in memory_operation_size;         --! Size of memory operation
        branch_in      : in branch_type;                   --! Type of jump operation
        funct3_in      : in std_logic_vector(2 downto 0);  --! Type of branch
        --! Instruction executed
        execution_num          : out integer range 0 to NUM_INSTRUCTIONS; --! Identify the table's row in execution 
        execution_alu_op       : out alu_operation;                 --! Identify the operation to be executed
        execution_alu_x_src    : out alu_operand_source;            --! Identity the operation resource
        execution_alu_x_addr   : out std_logic_vector(4 downto 0);  --! Identify the source register rs1
        execution_alu_y_src    : out alu_operand_source;            --! Identity the operation resource
        execution_alu_y_addr   : out std_logic_vector(4 downto 0);  --! Identify the source register rs2
        execution_immediate    : out std_logic_vector(31 downto 0); --! Identify the immediate
        execution_shamt        : out std_logic_vector(4 downto 0);  --! Identify the shamt
        execution_mem_op       : out memory_operation_type;         --! Identify the memory operation
        execution_mem_size     : out memory_operation_size;         --! Identify the memory size
        execution_pc           : out std_logic_vector(31 downto 0); --! Identify the program counter
        execution_branch       : out branch_type;                   --! Identify the branch operation
        execution_funct3       : out std_logic_vector(2 downto 0);  --! Identify the branch type
        --! Instruction completed
        completed_count_instr  : in std_logic;
        completed_num          : in integer range 0 to NUM_INSTRUCTIONS;  --! Identify the table's row with completed operation
        completed_res          : in std_logic_vector(31 downto 0);  --! Identify the result obtained by the completed operation
        completed_jump_taken   : in std_logic;                      --! Identify if the jump is taken
        completed_jump_target  : in std_logic_vector(31 downto 0);  --! Identify the jump target
        --! Instruction committed
        commit_rd_addr         : out std_logic_vector(4 downto 0);  --! Identify the destination register committed
        commit_rd_write        : out std_logic;                     --! Identify if the result has to be saved in the rf
        commit_res             : out std_logic_vector(31 downto 0); --! Identify the result 
        commit_jump_taken      : out std_logic;                     --! Identify if it's a jump instruction
        commit_jump_target     : out std_logic_vector(31 downto 0); --! Identify the next program counter
        commit_num             : out integer range 0 to NUM_INSTRUCTIONS; --! Testing signals
        commit_op              : out alu_operation;                       --! Testing signals        
        commit_x_src           : out alu_operand_source;                  --! Testing signals
        commit_y_src           : out alu_operand_source;                  --! Testing signals 
        commit_mem_op          : out memory_operation_type;               --! Testing signals
        commit_mem_size        : out memory_operation_size                --! Testing signals
	);
end entity rob;

architecture behaviour of rob is

    --! Composition of the table types
    -- The last line is used as fixed NOP operation
    type one_bit_field   is array(0 to NUM_INSTRUCTIONS)  of std_logic;
    type alu_op_field    is array(0 to NUM_INSTRUCTIONS)  of alu_operation;
    type alu_src_field   is array(0 to NUM_INSTRUCTIONS)  of alu_operand_source;
    type five_bits_field is array(0 to NUM_INSTRUCTIONS)  of std_logic_vector(4 downto 0);
    type thirtyone_bits_fields is array(0 to NUM_INSTRUCTIONS)  of std_logic_vector(31 downto 0);
    type mem_op_field    is array(0 to NUM_INSTRUCTIONS)  of memory_operation_type;
    type mem_size_field  is array(0 to NUM_INSTRUCTIONS)  of memory_operation_size;
    type funct3_field    is array(0 to NUM_INSTRUCTIONS)  of std_logic_vector(2 downto 0);
    type branches_field  is array(0 to NUM_INSTRUCTIONS)  of branch_type;

    --! Composition of the table
    signal uses       : one_bit_field;
    signal comm       : one_bit_field;
    signal exec       : one_bit_field;
    signal alu_op     : alu_op_field;
    signal p1         : one_bit_field;
    signal alu_x_src  : alu_src_field;
    signal alu_x_addr : five_bits_field;
    signal p2         : one_bit_field;    
    signal alu_y_src  : alu_src_field;
    signal alu_y_addr : five_bits_field;
    signal rd         : five_bits_field;
    signal rd_write   : one_bit_field;
    signal imm        : thirtyone_bits_fields;
    signal shamt      : five_bits_field;
    signal res        : thirtyone_bits_fields;
    signal mem_op     : mem_op_field;
    signal mem_size   : mem_size_field;
    signal pc         : thirtyone_bits_fields;
    signal funct3     : funct3_field;
    signal branch     : branches_field;
    signal jump_taken : one_bit_field;   
    
    --! Pointer to the table's first free row
    signal pntr_start      : natural range 0 to NUM_INSTRUCTIONS-1;
    --! Pointers to manage the operation in execution
    signal pntr_exec       : natural range 0 to NUM_INSTRUCTIONS;
    signal pntr_nextexec   : natural range 0 to NUM_INSTRUCTIONS;
    signal pntr_exec_prev  : natural range 0 to NUM_INSTRUCTIONS;
    --! Pointers used to manage the instruction to be committed
    signal pntr_end        : natural range 0 to NUM_INSTRUCTIONS-1;
    signal pntr_nextend    : natural range 0 to NUM_INSTRUCTIONS-1;

    --! Internal control signals
    signal committing : boolean;         --! Signal used to manage the flags when an instruction has been committed
    signal multiple_load_op : std_logic; --! Signal used to manage properly the execution for multiple mem operations
    signal flush : std_logic;            --! Signal used to manage the flush
    signal reset_internal  : std_logic;  --! Signal used to manage the reset

begin

    --! Reset occours in case of external request or internal flush
    reset_internal <= reset or flush;

    --! Process to change the pointers from next to actual
    sequential_process: process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal = '1' then
                pntr_exec <= NUM_INSTRUCTIONS;
                pntr_end  <= 0;
            elsif stall = '0' then
                --! Constant behaviour   
                if multiple_load_op='0' then
                    pntr_exec <= pntr_nextexec;
                end if;
                pntr_end <= pntr_nextend;
            end if;
        end if;
    end process sequential_process;
      
    --! Evaluation of full_table flags
    fulltable_evaluation: process (clk)
        -- Variable used to count the numero of free rows
        variable uses0_count : natural range 0 to NUM_INSTRUCTIONS;
    begin
        if rising_edge(clk) then 
            if reset_internal='1' then
                uses0_count := 0;
                fetch_enable <= '0';
            else
                uses0_count := 0;
                for i in 0 to NUM_INSTRUCTIONS-1 loop
                    if uses(i)='0' then
                        uses0_count := uses0_count + 1;
                    end if;
                end loop;
                -- Stop the fetch when there are two empty spaces
                if uses0_count<3 then
                    fetch_enable <= '1';
                else          
                    fetch_enable <= '0';
                end if; 
            end if;
        end if;
    end process fulltable_evaluation;

    --! Evaluation of the main table to be empty
    rob_empty <= '1' when uses(0 to NUM_INSTRUCTIONS-1) = (0 to NUM_INSTRUCTIONS-1 => '0') else '0';

    --! Managing of the starting pointer (pntr_start)
    nextstart_pntrs_evaluation: process (clk)
        variable index : natural range 0 to NUM_INSTRUCTIONS;
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                pntr_start <= 0;
            else     
                --! Increase the pointer
                index := pntr_start+1;
                if index=NUM_INSTRUCTIONS then
                    index := 0; 
                end if;
                --! Check if the instruction is valid
                if count_instruction='1' then
                    pntr_start <= index;
                end if;    
            end if;
        end if;
    end process nextstart_pntrs_evaluation;

    --! Loads the instructions in the table
    input_instrs_managing: process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                --! Set the whole table as NOP
                alu_op     <= (others => ALU_NOP);
                alu_x_src  <= (others => ALU_SRC_NULL);
                alu_x_addr <= (others => (others => '0'));
                alu_y_src  <= (others => ALU_SRC_NULL);
                alu_y_addr <= (others => (others => '0'));
                rd         <= (others => (others => '0'));
                rd_write   <= (others => '0');
                imm        <= (others => (others => '0'));
                shamt      <= (others => (others => '0'));
                mem_op     <= (others => MEMOP_TYPE_NONE);
                mem_size   <= (others => MEMOP_SIZE_WORD);
                funct3     <= (others => (others => '0'));
                branch     <= (others => BRANCH_NONE);
            else
                --! Save the instruction in case it's valid
                if count_instruction='1' then
                    alu_op(pntr_start)     <= alu_op_in;
                    alu_x_src(pntr_start)  <= alu_x_src_in;
                    alu_x_addr(pntr_start) <= alu_x_addr_in;
                    alu_y_src(pntr_start)  <= alu_y_src_in;
                    alu_y_addr(pntr_start) <= alu_y_addr_in;
                    rd(pntr_start)         <= rd_addr_in;
                    rd_write(pntr_start)   <= rd_write_in;
                    imm(pntr_start)        <= immediate_in;
                    shamt(pntr_start)      <= shamt_in;
                    mem_op(pntr_start)     <= mem_op_in;
                    mem_size(pntr_start)   <= mem_size_in;
                    branch(pntr_start)     <= branch_in;
                    funct3(pntr_start)     <= funct3_in;
                end if;
                --! Reset the row in case of committing
                if committing then
                    alu_op(pntr_end)     <= ALU_NOP;
                    alu_x_src(pntr_end)  <= ALU_SRC_NULL;
                    alu_x_addr(pntr_end) <= (others => '0');
                    alu_y_src(pntr_end)  <= ALU_SRC_NULL;
                    alu_y_addr(pntr_end) <= (others => '0');
                    rd(pntr_end)         <= (others => '0');
                    rd_write(pntr_end)   <= '0';
                    imm(pntr_end)        <= (others => '0');
                    shamt(pntr_end)      <= (others => '0');
                    mem_op(pntr_end)     <= MEMOP_TYPE_NONE;
                    mem_size(pntr_end)   <= MEMOP_SIZE_WORD;
                    branch(pntr_end)     <= BRANCH_NONE;
                    funct3(pntr_end)     <= (others => '0');
                end if;            
            end if;
        end if;
    end process input_instrs_managing;

    --! Managing of the program counter field (pc)
    pc_values_managing : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                pc <= (others => (others => '0'));
            else
                --! Save the instruction in case it's valid
                if count_instruction='1' then
                    pc(pntr_start) <= pc_in;
                end if;
                --! Reset the row in case of committing
                if committing then
                    pc(pntr_end) <= (others => '0');
                end if;
                --! Save the completed instruction in case it's valid
                if completed_num/=NUM_INSTRUCTIONS and completed_count_instr='1' then
                    pc(completed_num) <= completed_jump_target;
                end if;
            end if;
        end if;
    end process pc_values_managing;

    --! Set properly the USES flag
    uses_flag_managing : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                uses <= (others => '0');
                --! The last row of tables is fixed to have a NOP r0, r0, r0
                uses(NUM_INSTRUCTIONS) <= '1'; 
            else
                --! Save the instruction in case it's valid
                if count_instruction='1' then
                    uses(pntr_start) <= '1';
                end if;
                --! Reset the row in case of committing
                if committing then
                    uses(pntr_end) <= '0';
                end if;  
            end if;
        end if;
    end process uses_flag_managing;

    --! Managing of RAW hazards setting properly the P1 and P2 flags
    p1p2_flags_managing : process (clk)
        variable current_index   : natural range 0 to NUM_INSTRUCTIONS;
        variable precedent_index : natural range 0 to NUM_INSTRUCTIONS;
        variable hazard_src1     : boolean;
        variable hazard_src2     : boolean;
        variable hazard_mem      : boolean;
        variable is_nop          : boolean;
        variable is_immediate    : boolean;
        variable is_store        : boolean;
        variable is_load         : boolean; 
        variable var_p1          : one_bit_field; 
        variable var_p2          : one_bit_field;
    begin
        if rising_edge(clk) then    
            if reset_internal='1' then
                p1 <= (others => '0');
                p2 <= (others => '0');
            else
                --! By default the instructions are not committable 
                var_p1 := (others => '0');
                var_p2 := (others => '0');
                --! The last raw is ever committable
                var_p1(pntr_end) := '1';
                var_p2(pntr_end) := '1'; 
                --! Start to check RAW after the last row
                if pntr_end=NUM_INSTRUCTIONS-1 then
                    current_index := 0;
                else
                    current_index := pntr_end+1;
                end if; 
                --! Check of the whole table
                for k in 1 to NUM_INSTRUCTIONS-1 loop 
                    --! Reset the RAW flags
                    hazard_src1 := false;
                    hazard_src2 := false;
                    hazard_mem  := false;
                    --! Check the case of a NOP instructions
                    is_nop := (alu_op(current_index)=ALU_ADD or alu_op(current_index)=ALU_NOP) and (rd(current_index)="00000" and alu_x_addr(current_index)="00000" 
                                and (alu_y_addr(current_index)="00000" or alu_y_src(current_index)=ALU_SRC_IMM));
                    --! Check the case of immediate instructions (it works for Load and Store operations too)
                    is_immediate := (alu_y_src(current_index)=ALU_SRC_IMM or alu_y_src(current_index)=ALU_SRC_SHAMT);
                    --! Check per Memory Hazard
                    is_store := (mem_op(current_index)=MEMOP_TYPE_STORE);
                    is_load  := (mem_op(current_index)=MEMOP_TYPE_LOAD);
                    --! Nested loop to check RAW hazards
                    precedent_index := pntr_end;
                    for j in 0 to k-1 loop 
                        --! Hazard in src1
                        if  alu_x_addr(current_index)=rd(precedent_index)then
                            hazard_src1 := true;
                        end if;
                        --! Hazard in src2
                        if  alu_y_addr(current_index)=rd(precedent_index) then
                            hazard_src2 := true;
                        end if;
                        --! Memory hazard
                        if (alu_x_addr(current_index) = alu_x_addr(precedent_index)) and 
                                (imm(current_index) = imm(precedent_index)) then
                            hazard_mem := true;
                        end if;
                        --! Index increments
                        if precedent_index=NUM_INSTRUCTIONS-1 then 
                            precedent_index := 0; 
                        else  
                            precedent_index := precedent_index + 1; 
                        end if; 
                    end loop;
                    --! Save the results
                    if is_nop or hazard_src1 then
                        var_p1(current_index) := '0';
                    else
                        var_p1(current_index) := '1';
                    end if;
                    if is_immediate and (not is_store) then
                        var_p2(current_index) := '1';
                    else
                        if is_nop or hazard_src2 then
                            var_p2(current_index) := '0';
                        else
                            var_p2(current_index) := '1';
                        end if;
                    end if;
                    --! Memory hazard
                    if is_load and hazard_mem then
                        var_p1(current_index) := '0';
                        var_p2(current_index) := '0';
                    end if;
                    --! Index increments
                    if current_index=NUM_INSTRUCTIONS-1 then 
                        current_index := 0; 
                    else  
                        current_index := current_index + 1; 
                    end if; 
                end loop; 
                --! Reset the row in case of committing
                if committing then
                    var_p1(pntr_end) := '0';
                    var_p2(pntr_end) := '0';
                end if;
                p1 <= var_p1;
                p2 <= var_p2;
            end if;                
        end if;
    end process p1p2_flags_managing;

    --! Evaluation of the next instruction to execute (pntr_nextexec) 
    output_instrs_evaluation : process (clk)
        variable index_instr   : natural range 0 to NUM_INSTRUCTIONS;
        variable current_index : natural range 0 to NUM_INSTRUCTIONS;
        variable found       : natural range 0 to 2;
        variable is_curr_mem : boolean;
        variable mem_blocked : boolean; --! Used to avoid O-o-O memory operations
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                --! Pointing the NOP operation
                pntr_nextexec  <= NUM_INSTRUCTIONS;
            elsif stall='0' and multiple_load_op='0' then
                --! Search an instructions to execute starting from pntr_end
                index_instr  := NUM_INSTRUCTIONS; --! NOP by default
                current_index := pntr_end;        --! Starting from the last row
                mem_blocked   := false;           
                for k in 0 to NUM_INSTRUCTIONS-1 loop
                    --! Check if the instruction has to be checked
                    if (current_index/=pntr_exec) and 
                       (current_index/=pntr_nextexec) and 
                       (uses(current_index)='1') and 
                       (exec(current_index)='0') then
                        --! Check if it's a memory operation
                        is_curr_mem := (mem_op(current_index) = MEMOP_TYPE_STORE) or (mem_op(current_index) = MEMOP_TYPE_LOAD) 
                                        or (mem_op(current_index) = MEMOP_TYPE_LOAD_UNSIGNED);
                        --! Check if it could be executed
                        if (p1(current_index)='1') and (p2(current_index)='1') then
                            --! Check if there aren't two consecutive MEM operations
                            if is_curr_mem then
                                if not mem_blocked then
                                    index_instr := current_index;
                                    exit;
                                end if;
                            else
                                index_instr := current_index;
                                exit;
                            end if;
                        else
                            --! Block the execution of two consecutive MEM operations
                            if is_curr_mem then
                                mem_blocked := true;
                            end if;
                        end if;
                    end if;
                    --! Increase the index
                    if current_index=NUM_INSTRUCTIONS-1 then 
                        current_index := 0; 
                    else  
                        current_index := current_index + 1; 
                    end if; 
                end loop;
                pntr_nextexec <= index_instr;
            end if;                
        end if;
    end process output_instrs_evaluation; 

    --! Set properly the EXEC flag
    exec_flag_managing : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                exec <= (others => '0');
            elsif stall='0' then
                --! Executes the instruction in case it's valid
                if pntr_exec/=NUM_INSTRUCTIONS then
                    exec(pntr_exec) <= '1'; 
                end if;
                --! Reset the row in case of committing
                if committing then
                    exec(pntr_end) <= '0';
                end if;
            end if;
        end if;
    end process exec_flag_managing;

    --! Control the case of multiple mem operations to have a coherent execution with the core
    check_multiple_loads_op : process (clk)
        variable multiple_load : integer;
        variable clk_waiting   : integer;
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                multiple_load := 0;
                multiple_load_op <= '0';
                clk_waiting := 0;
            elsif stall='0' then
                if multiple_load<1 then
                    if pntr_exec/=pntr_exec_prev then
                        -- Two Load consegutive
                        if (mem_op(pntr_exec)=MEMOP_TYPE_LOAD or mem_op(pntr_exec)=MEMOP_TYPE_LOAD_UNSIGNED) and 
                                (mem_op(pntr_nextexec)=MEMOP_TYPE_LOAD or mem_op(pntr_nextexec)=MEMOP_TYPE_LOAD_UNSIGNED) then 
                            multiple_load := multiple_load + 1;
                        -- Two Store consegutive
                        elsif mem_op(pntr_exec)=MEMOP_TYPE_STORE and 
                                mem_op(pntr_nextexec)=MEMOP_TYPE_STORE then 
                            multiple_load := multiple_load + 1;
                        -- Store and Load
                        elsif mem_op(pntr_exec)=MEMOP_TYPE_STORE and 
                                (mem_op(pntr_nextexec)=MEMOP_TYPE_LOAD or mem_op(pntr_nextexec)=MEMOP_TYPE_LOAD_UNSIGNED) then
                            multiple_load := multiple_load + 1;
                        -- Load and Store
                        elsif (mem_op(pntr_exec)=MEMOP_TYPE_LOAD or mem_op(pntr_exec)=MEMOP_TYPE_LOAD_UNSIGNED) and 
                                 mem_op(pntr_nextexec)=MEMOP_TYPE_STORE then 
                            multiple_load := multiple_load + 1;
                        end if;
                    end if;
                else 
                    if clk_waiting<1 then
                        clk_waiting := clk_waiting + 1;
                        multiple_load_op <= '1';
                    else 
                        clk_waiting := 0;
                        multiple_load_op <= '0';
                        multiple_load := 0;
                    end if;
                end if;
            end if;
        end if;
    end process check_multiple_loads_op;

    --! Output the instructions that have to be executed
    execution_output : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                execution_num          <= NUM_INSTRUCTIONS;
                execution_alu_op       <= ALU_INVALID;
                execution_alu_x_src    <= ALU_SRC_NULL;
                execution_alu_x_addr   <= (others => '0');
                execution_alu_y_src    <= ALU_SRC_NULL;
                execution_alu_y_addr   <= (others => '0');
                execution_immediate    <= (others => '0');
                execution_shamt        <= (others => '0');
                execution_mem_op       <= MEMOP_TYPE_NONE;
                execution_mem_size     <= MEMOP_SIZE_BYTE;
                execution_pc           <= (others => '0'); 
                execution_branch       <= BRANCH_NONE;
                execution_funct3       <= (others => '0');
                pntr_exec_prev <= NUM_INSTRUCTIONS;
            elsif stall='0' then
                --! Executes the instruction in case it's valid
                if pntr_exec/=pntr_exec_prev then
                        execution_num          <= pntr_exec;
                        execution_alu_op       <= alu_op(pntr_exec);
                        execution_alu_x_src    <= alu_x_src(pntr_exec);
                        execution_alu_x_addr   <= alu_x_addr(pntr_exec);
                        execution_alu_y_src    <= alu_y_src(pntr_exec);
                        execution_alu_y_addr   <= alu_y_addr(pntr_exec);
                        execution_immediate    <= imm(pntr_exec);
                        execution_shamt        <= shamt(pntr_exec);
                        execution_mem_op       <= mem_op(pntr_exec);
                        execution_mem_size     <= mem_size(pntr_exec);
                        execution_pc           <= pc(pntr_exec); 
                        execution_branch       <= branch(pntr_exec);
                        execution_funct3       <= funct3(pntr_exec);
                else
                        execution_num          <= NUM_INSTRUCTIONS;
                        execution_alu_op       <= alu_op(pntr_exec);
                        execution_alu_x_src    <= alu_x_src(pntr_exec);
                        execution_alu_x_addr   <= alu_x_addr(pntr_exec);
                        execution_alu_y_src    <= alu_y_src(pntr_exec);
                        execution_alu_y_addr   <= alu_y_addr(pntr_exec);
                        execution_immediate    <= imm(pntr_exec);
                        execution_shamt        <= shamt(pntr_exec);
                        execution_mem_op       <= MEMOP_TYPE_NONE;
                        execution_mem_size     <= mem_size(pntr_exec);
                        execution_pc           <= pc(pntr_exec); 
                        execution_branch       <= BRANCH_NONE;
                        execution_funct3       <= funct3(pntr_exec);
                end if;
                pntr_exec_prev <= pntr_exec;
            end if;
        end if;
    end process execution_output;

    --! Loads the result of completed instructions in the table
    input_completed_instr_managing : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                res <= (others => (others => '0'));
            elsif stall='0' then
                --! Save the instruction in case it's valid 
                if completed_num/=NUM_INSTRUCTIONS and completed_count_instr='1' then
                    res(completed_num) <= completed_res;
                end if;
            end if;
        end if;
    end process input_completed_instr_managing;

    --! Set properly the JUMP_TAKEN flag
    jump_taken_flag_managing : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                jump_taken <= (others => '0');
            elsif stall='0' then
                --! Save the instruction in case it's valid 
                if completed_num/=NUM_INSTRUCTIONS and completed_count_instr='1' then
                    jump_taken(completed_num) <= completed_jump_taken;
                end if;
                --! Reset the row in case of committing
                if committing then
                    jump_taken(pntr_end) <= '0';
                end if;
            end if;
        end if;
    end process jump_taken_flag_managing;

    --! Set properly the committable instructions (comm)
    comm_flag_managing : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                comm <= (others => '0');
            elsif stall='0' then
                --! Makes the instruction commitable in case it's valid 
                if completed_num/=NUM_INSTRUCTIONS and completed_count_instr='1' then
                    comm(completed_num) <= '1';
                end if;
                --! Reset the row in case of committing
                if committing then
                    comm(pntr_end) <= '0';
                end if;
            end if;
        end if;
    end process comm_flag_managing;

    --! Managing of the ending pointer (pntr_end) and committing flag (committing)
    pntr_nextend_evaluation: process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                pntr_nextend <= 0;
                committing <= false;
            elsif stall='0' then    
                --! Check if the instruction is committable
                if (comm(pntr_end)='1' and committing=false) or (comm(pntr_end)='1' and comm(pntr_nextend)='1') or (completed_num=pntr_end) then
                    if pntr_nextend=NUM_INSTRUCTIONS-1 then
                        pntr_nextend <= 0;
                    else
                        pntr_nextend <= pntr_nextend+1;
                    end if;
                    --! Raise the committing flag
                    committing <= true;
                else 
                    committing <= false;
                end if;
            end if;
        end if;
    end process pntr_nextend_evaluation;

    --! Output the committable instruction
    commit_output : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                commit_num         <= NUM_INSTRUCTIONS;
                commit_op          <= ALU_INVALID;
                commit_rd_addr     <= (others => '0');
                commit_rd_write    <= '0';
                commit_res         <= (others => '0');
                commit_jump_taken  <= '0';
                commit_jump_target <= (others => '0');
                commit_x_src       <= ALU_SRC_NULL;
                commit_y_src       <= ALU_SRC_NULL;
                commit_mem_op      <= MEMOP_TYPE_NONE;
                commit_mem_size    <= MEMOP_SIZE_BYTE;
            elsif stall='0' then
                --! Committ the instruction in case if valid otherwise send a NOP
                if committing then
                    commit_num         <= pntr_end;
                    commit_op          <= alu_op(pntr_end);
                    commit_rd_addr     <= rd(pntr_end);
                    commit_rd_write    <= rd_write(pntr_end);
                    commit_res         <= res(pntr_end);
                    commit_jump_taken  <= jump_taken(pntr_end);
                    commit_jump_target <= pc(pntr_end);
                    commit_x_src       <= alu_x_src(pntr_end);
                    commit_y_src       <= alu_y_src(pntr_end);
                    commit_mem_op      <= mem_op(pntr_end);
                    commit_mem_size    <= mem_size(pntr_end);
                else
                    commit_num         <= NUM_INSTRUCTIONS;
                    commit_op          <= ALU_NOP;
                    commit_rd_addr     <= (others => '0');
                    commit_rd_write    <= '0';
                    commit_res         <= (others => '0');
                    commit_jump_taken  <= '0';
                    commit_jump_target <= (others => '0');
                    commit_x_src       <= ALU_SRC_NULL;
                    commit_y_src       <= ALU_SRC_NULL;
                    commit_mem_op      <= MEMOP_TYPE_NONE;
                    commit_mem_size    <= MEMOP_SIZE_BYTE;
                end if;
            end if;
        end if;
    end process commit_output;

    --! Generation of the flush signal in case of jump taken
    flush_generation : process (clk)
    begin
        if rising_edge(clk) then
            if reset_internal='1' then
                flush <= '0';
            else
                if committing then
                    flush <= jump_taken(pntr_end);
                end if;
            end if;
        end if;
    end process flush_generation;

end architecture behaviour;