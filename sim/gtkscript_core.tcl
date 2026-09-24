gtkwave::/Edit/Highlight_All
gtkwave::/Edit/Delete
gtkwave::/Edit/UnHighlight_All


set sg_generic [list]
lappend sg_generic "tb_processor.clk"
lappend sg_generic "tb_processor.reset"
gtkwave::addSignalsFromList $sg_generic
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Stalls"
set sg_stalls [list]
lappend sg_stalls "tb_processor.uut.stall_if"
lappend sg_stalls "tb_processor.uut.stall_id"
#lappend sg_stalls "tb_processor.uut.stall_rob_core"
#lappend sg_stalls "tb_processor.uut.stall_csr"
lappend sg_stalls "tb_processor.uut.stall_ex"
lappend sg_stalls "tb_processor.uut.stall_mem"
lappend sg_stalls "tb_processor.uut.stall_wb"
lappend sg_stalls "tb_processor.uut.stall_rob"
gtkwave::addSignalsFromList $sg_stalls 
gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Fetch_In"
#set sg_fetch [list]
#set sg_fetch_dec [list]
#lappend sg_fetch_dec "tb_processor.uut.fetch.imem_data_in"
#lappend sg_fetch "tb_processor.uut.fetch.imem_ack"
#lappend sg_fetch "tb_processor.uut.fetch.stall"
#lappend sg_fetch "tb_processor.uut.fetch.flush"
#lappend sg_fetch "tb_processor.uut.fetch.branch"
#lappend sg_fetch "tb_processor.uut.fetch.exception"
#lappend sg_fetch_dec "tb_processor.uut.fetch.branch_target"
#lappend sg_fetch "tb_processor.uut.fetch.evec"
#gtkwave::addSignalsFromList $sg_fetch_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_fetch_dec
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_fetch
#gtkwave::highlightSignalsFromList $sg_fetch
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Fetch_Out"
#set sg_fetch [list]
#set sg_fetch_dec [list]
#lappend sg_fetch_dec "tb_processor.uut.fetch.imem_address"
#lappend sg_fetch "tb_processor.uut.fetch.imem_req"
#lappend sg_fetch "tb_processor.uut.fetch.instruction_data"
#lappend sg_fetch_dec "tb_processor.uut.fetch.instruction_address"
#lappend sg_fetch "tb_processor.uut.fetch.instruction_ready"
#gtkwave::addSignalsFromList $sg_fetch_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_fetch_dec
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_fetch
#gtkwave::highlightSignalsFromList $sg_fetch
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Decoder_IN"
set sg_dec_in [list]
#lappend sg_dec_in "tb_processor.uut.decode.flush"
#lappend sg_dec_in "tb_processor.uut.decode.stall"
#lappend sg_dec_in "tb_processor.uut.decode.instruction_data"
lappend sg_dec_in "tb_processor.uut.decode.instruction_address"
#lappend sg_dec_in "tb_processor.uut.decode.instruction_ready"
#lappend sg_dec_in "tb_processor.uut.decode.instruction_count"
#lappend sg_dec_in "tb_processor.uut.decode.rob_table1_empty"
gtkwave::addSignalsFromList $sg_dec_in 
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All

#gtkwave::addCommentTracesFromList "Decoder"
#set sg_dec_in [list]
#lappend sg_dec_in "tb_processor.uut.decode.state"
#lappend sg_dec_in "tb_processor.uut.decode.instruction"
#lappend sg_dec_in "tb_processor.uut.decode.pc"
#lappend sg_dec_in "tb_processor.uut.decode.prev_instruction"
#lappend sg_dec_in "tb_processor.uut.decode.prev_pc"
#lappend sg_dec_in "tb_processor.uut.decode.next_csr_instr"
#gtkwave::addSignalsFromList $sg_dec_in 
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All

gtkwave::addCommentTracesFromList "Decoder_OUT" 
set sg_dec_out [list]
lappend sg_dec_out "tb_processor.uut.decode.pc"
lappend sg_dec_out "tb_processor.uut.decode.count_instruction"
#lappend sg_dec_out "tb_processor.uut.decode.count_instruction_csr"
lappend sg_dec_out "tb_processor.uut.decode.rd_addr"
lappend sg_dec_out "tb_processor.uut.decode.rs1_addr"
lappend sg_dec_out "tb_processor.uut.decode.rs2_addr"
#lappend sg_dec_out "tb_processor.uut.decode.shamt"
#lappend sg_dec_out "tb_processor.uut.decode.funct3"
lappend sg_dec_out "tb_processor.uut.decode.immediate"
#lappend sg_dec_out "tb_processor.uut.decode.rd_write"
#lappend sg_dec_out "tb_processor.uut.decode.branch"
#lappend sg_dec_out "tb_processor.uut.decode.alu_x_src"
#lappend sg_dec_out "tb_processor.uut.decode.alu_y_src"
#lappend sg_dec_out "tb_processor.uut.decode.alu_op"
lappend sg_dec_out "tb_processor.uut.decode.mem_op"
lappend sg_dec_out "tb_processor.uut.decode.mem_size"
#lappend sg_dec_out "tb_processor.uut.decode.csr_addr"
#lappend sg_dec_out "tb_processor.uut.decode.csr_write"
#lappend sg_dec_out "tb_processor.uut.decode.csr_use_imm"
#lappend sg_dec_out "tb_processor.uut.decode.stall_csr"
#lappend sg_dec_out "tb_processor.uut.decode.decode_exception"
#lappend sg_dec_out "tb_processor.uut.decode.decode_exception_cause"
gtkwave::addSignalsFromList $sg_dec_out
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "CSR_In"
#set sg_csr [list]
#lappend sg_csr "tb_processor.uut.csr_unit.count_instruction"
#lappend sg_csr "tb_processor.uut.csr_unit.count_instruction_csr"
#lappend sg_csr "tb_processor.uut.csr_unit.read_address"
#lappend sg_csr "tb_processor.uut.csr_unit.write_address"
#lappend sg_csr "tb_processor.uut.csr_unit.write_data_in"
#lappend sg_csr "tb_processor.uut.csr_unit.write_mode"
#lappend sg_csr "tb_processor.uut.csr_unit.exception_context"
#lappend sg_csr "tb_processor.uut.csr_unit.exception_context_write"
#gtkwave::addSignalsFromList $sg_csr
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "CSR_Out"
#set sg_csr [list]
#lappend sg_csr "tb_processor.uut.csr_unit.test_context_out"
#lappend sg_csr "tb_processor.uut.csr_unit.read_data_out"
#lappend sg_csr "tb_processor.uut.csr_unit.software_interrupt_out"
#lappend sg_csr "tb_processor.uut.csr_unit.timer_interrupt_out"
#lappend sg_csr "tb_processor.uut.csr_unit.mie_out"
#lappend sg_csr "tb_processor.uut.csr_unit.mtvec_out"
#lappend sg_csr "tb_processor.uut.csr_unit.ie_out"
#lappend sg_csr "tb_processor.uut.csr_unit.ie1_out"
#gtkwave::addSignalsFromList $sg_csr
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "ROB_Generic"
set sg_rob_generic [list]
#lappend sg_rob_generic "tb_processor.uut.reorder_buffer.stall"
lappend sg_rob_generic "tb_processor.uut.reorder_buffer.count_instruction"
#lappend sg_rob_generic "tb_processor.uut.reorder_buffer.count_instruction2"
lappend sg_rob_generic "tb_processor.uut.reorder_buffer.fetch_enable"
#lappend sg_rob_generic "tb_processor.uut.reorder_buffer.fetch2_enable"
lappend sg_rob_generic "tb_processor.uut.reorder_buffer.table_empty"
gtkwave::addSignalsFromList $sg_rob_generic
gtkwave::highlightSignalsFromList $sg_rob_generic
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "ROB_DataIn1"
#set sg_rob_datain [list]
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.pc_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.alu_op_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.alu_x_src_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.alu_x_addr_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.alu_y_src_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.alu_y_addr_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.rd_addr_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.rd_write_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.immediate_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.shamt_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.mem_op_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.mem_size_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.branch_1"
#lappend sg_rob_datain "tb_processor.uut.reorder_buffer.funct3_1"
#gtkwave::addSignalsFromList $sg_rob_datain
#gtkwave::highlightSignalsFromList $sg_rob_datain
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "ROB_Pointers"
set sg_pointers [list]
#lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_start"
#lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_start2"
lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_exec"
lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_nextexec"
#lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_exec2"
#lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_nextexec2"
lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_end"
#lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_nextend"
#lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_end2"
#lappend sg_pointers "tb_processor.uut.reorder_buffer.pntr_nextend2"
lappend sg_pointers "tb_processor.uut.reorder_buffer.multiple_load_op"
gtkwave::addSignalsFromList $sg_pointers
gtkwave::highlightSignalsFromList $sg_pointers
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "ROB_Table"
set sg_rob_table [list]
set sg_rob_table_bin [list]
set sg_rob_table_dec [list]
lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.uses"
#lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.p1"
#lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.p2"
#lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.exec"
#lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.comm"
#lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.branch"
#lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.jump_taken"
#lappend sg_rob_table     "tb_processor.uut.reorder_buffer.alu_op"
#lappend sg_rob_table     "tb_processor.uut.reorder_buffer.alu_x_src"
#lappend sg_rob_table     "tb_processor.uut.reorder_buffer.alu_y_src"
#lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.rd_write"
#lappend sg_rob_table     "tb_processor.uut.reorder_buffer.mem_op"
#lappend sg_rob_table     "tb_processor.uut.reorder_buffer.mem_size"
gtkwave::addSignalsFromList $sg_rob_table_bin
gtkwave::highlightSignalsFromList $sg_rob_table_bin
gtkwave::/Edit/Data_Format/Binary
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_rob_table
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
#set NUM_LINE_TABLES 8
#for {set i 0} {$i < $NUM_LINE_TABLES} {incr i} {
#    set sg_rob_table_dec {}
#    lappend sg_rob_table "tb_processor.uut.reorder_buffer.pc\[$i\]"
#    lappend sg_rob_table_dec "tb_processor.uut.reorder_buffer.alu_x_addr\[$i\]"
#    lappend sg_rob_table_dec "tb_processor.uut.reorder_buffer.alu_y_addr\[$i\]"
#    lappend sg_rob_table_dec "tb_processor.uut.reorder_buffer.rd\[$i\]"
#    lappend sg_rob_table_dec "tb_processor.uut.reorder_buffer.imm\[$i\]"
#    lappend sg_rob_table_dec "tb_processor.uut.reorder_buffer.shamt\[$i\]"
#    lappend sg_rob_table_dec "tb_processor.uut.reorder_buffer.res\[$i\]"
#    lappend sg_rob_table_bin "tb_processor.uut.reorder_buffer.funct3\[$i\]"
#    gtkwave::addSignalsFromList $sg_rob_table_dec
#    gtkwave::highlightSignalsFromList $sg_rob_table_dec
#    gtkwave::/Edit/Data_Format/Decimal
#    gtkwave::/Edit/UnHighlight_All
#}


#gtkwave::addCommentTracesFromList "ROB_Execution"
#set sg_execution [list]
#set sg_execution_dec [list]
#lappend sg_execution "tb_processor.uut.reorder_buffer.execution_num"
#lappend sg_execution     "tb_processor.uut.reorder_buffer.execution_alu_op"
#lappend sg_execution     "tb_processor.uut.reorder_buffer.execution1_alu_x_src"
#lappend sg_execution_dec "tb_processor.uut.reorder_buffer.execution1_alu_x_addr"
#lappend sg_execution     "tb_processor.uut.reorder_buffer.execution1_alu_y_src"
#lappend sg_execution_dec "tb_processor.uut.reorder_buffer.execution1_alu_y_addr"
#lappend sg_execution_dec "tb_processor.uut.reorder_buffer.execution1_immediate"
#lappend sg_execution_dec "tb_processor.uut.reorder_buffer.execution1_shamt"
#lappend sg_execution     "tb_processor.uut.reorder_buffer.execution1_mem_op"
#lappend sg_execution     "tb_processor.uut.reorder_buffer.execution1_mem_size"
#lappend sg_execution_dec "tb_processor.uut.reorder_buffer.execution1_pc"
#lappend sg_execution     "tb_processor.uut.reorder_buffer.execution1_branch"
#lappend sg_execution     "tb_processor.uut.reorder_buffer.execution1_funct3"
#gtkwave::addSignalsFromList $sg_execution_dec
#gtkwave::highlightSignalsFromList $sg_execution_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_execution
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Reg_File"
#set sg_reg_file [list]
#lappend sg_reg_file "tb_processor.uut.regfile.rd_write"
#lappend sg_reg_file "tb_processor.uut.regfile.rd_addr"
#lappend sg_reg_file "tb_processor.uut.regfile.rd_data"
#lappend sg_reg_file "tb_processor.uut.regfile.rs1_addr"
#lappend sg_reg_file "tb_processor.uut.regfile.rs1_data"
#lappend sg_reg_file "tb_processor.uut.regfile.rs2_addr"
#lappend sg_reg_file "tb_processor.uut.regfile.rs2_data"
#gtkwave::addSignalsFromList $sg_reg_file
#gtkwave::highlightSignalsFromList $sg_reg_file
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Execute_In"
#set sg_execute [list]
#set sg_execute_dec [list]
#lappend sg_execute "tb_processor.uut.execute.stall"
#lappend sg_execute "tb_processor.uut.execute.flush"
#lappend sg_execute "tb_processor.uut.execute.software_interrupt"
#lappend sg_execute "tb_processor.uut.execute.timer_interrupt"
#lappend sg_execute "tb_processor.uut.execute.rob_op_num_in"
#lappend sg_execute "tb_processor.uut.execute.alu_op_in"
#lappend sg_execute "tb_processor.uut.execute.rd_write_in"
#lappend sg_execute "tb_processor.uut.execute.rd_addr_in"
#lappend sg_execute "tb_processor.uut.execute.alu_x_src_in"
#lappend sg_execute "tb_processor.uut.execute.rs1_addr_in"
#lappend sg_execute "tb_processor.uut.execute.rs1_data_in"
#lappend sg_execute "tb_processor.uut.execute.alu_y_src_in"
#lappend sg_execute "tb_processor.uut.execute.rs2_addr_in"
#lappend sg_execute "tb_processor.uut.execute.rs2_data_in"
#lappend sg_execute "tb_processor.uut.execute.shamt_in"
#lappend sg_execute "tb_processor.uut.execute.immediate_in"
#lappend sg_execute "tb_processor.uut.execute.pc_in"
#lappend sg_execute "tb_processor.uut.execute.funct3_in"
#lappend sg_execute "tb_processor.uut.execute.csr_addr_in"
#lappend sg_execute "tb_processor.uut.execute.csr_write_in"
#lappend sg_execute "tb_processor.uut.execute.csr_value_in"
#lappend sg_execute "tb_processor.uut.execute.csr_use_immediate_in"
#lappend sg_execute "tb_processor.uut.execute.branch_in"
#lappend sg_execute "tb_processor.uut.execute.mem_op_in"
#lappend sg_execute "tb_processor.uut.execute.mem_size_in"
#lappend sg_execute "tb_processor.uut.execute.count_instruction_in"
#lappend sg_execute "tb_processor.uut.execute.ie_in"
#lappend sg_execute "tb_processor.uut.execute.ie1_in"
#lappend sg_execute "tb_processor.uut.execute.mie_in"
#lappend sg_execute "tb_processor.uut.execute.mtvec_in"
#lappend sg_execute "tb_processor.uut.execute.decode_exception_in"
#lappend sg_execute "tb_processor.uut.execute.decode_exception_cause_in"
#lappend sg_execute "tb_processor.uut.execute.mem_rd_write"
#lappend sg_execute "tb_processor.uut.execute.mem_rd_addr"
#lappend sg_execute "tb_processor.uut.execute.mem_rd_value"
#lappend sg_execute "tb_processor.uut.execute.mem_csr_addr"
#lappend sg_execute "tb_processor.uut.execute.mem_csr_write"
#lappend sg_execute "tb_processor.uut.execute.mem_exception"
#lappend sg_execute "tb_processor.uut.execute.wb_rd_write"
#lappend sg_execute "tb_processor.uut.execute.wb_rd_addr"
#lappend sg_execute "tb_processor.uut.execute.wb_rd_value"
#lappend sg_execute "tb_processor.uut.execute.wb_csr_addr"
#lappend sg_execute "tb_processor.uut.execute.wb_csr_write"
#lappend sg_execute "tb_processor.uut.execute.wb_exception"
#lappend sg_execute "tb_processor.uut.execute.mem_mem_op"
#gtkwave::addSignalsFromList $sg_execute
#gtkwave::highlightSignalsFromList $sg_execute
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_execute_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_execute_dec
#gtkwave::/Edit/UnHighlight_All



#gtkwave::addCommentTracesFromList "Execute_forwarding"
#set sg_execute [list]
#set sg_execute_dec [list]
#lappend sg_execute "tb_processor.uut.execute.csr_write"
#lappend sg_execute "tb_processor.uut.execute.csr_addr"
#lappend sg_execute "tb_processor.uut.execute.csr_value_in"
#lappend sg_execute "tb_processor.uut.execute.mem_count_instr"
#lappend sg_execute "tb_processor.uut.execute.mem_csr_write"
#lappend sg_execute "tb_processor.uut.execute.mem_csr_addr"
#lappend sg_execute "tb_processor.uut.execute.mem_csr_data"
#lappend sg_execute "tb_processor.uut.execute.wb_count_instr"
#lappend sg_execute "tb_processor.uut.execute.wb_csr_write"
#lappend sg_execute "tb_processor.uut.execute.wb_csr_addr"
#lappend sg_execute "tb_processor.uut.execute.wb_csr_data"
#lappend sg_execute "tb_processor.uut.execute.csr_value"
#gtkwave::addSignalsFromList $sg_execute
#gtkwave::highlightSignalsFromList $sg_execute
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_execute_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_execute_dec
#gtkwave::/Edit/UnHighlight_All

#gtkwave::addCommentTracesFromList "ALU"
#set sg_alu_dec [list]
#lappend sg_alu_dec "tb_processor.uut.execute.alu_instance.operation"
#lappend sg_alu_dec "tb_processor.uut.execute.alu_instance.x"
#lappend sg_alu_dec "tb_processor.uut.execute.alu_instance.y"
#lappend sg_alu_dec "tb_processor.uut.execute.alu_instance.result"
#gtkwave::addSignalsFromList $sg_alu_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_alu_dec
#gtkwave::/Edit/UnHighlight_All

#gtkwave::addCommentTracesFromList "CSR_ALU"
#set sg_csr_alu_dec [list]
#lappend sg_csr_alu_dec "tb_processor.uut.execute.csr_alu_instance.x"
#lappend sg_csr_alu_dec "tb_processor.uut.execute.csr_alu_instance.y"
#lappend sg_csr_alu_dec "tb_processor.uut.execute.csr_alu_instance.result"
#lappend sg_csr_alu_dec "tb_processor.uut.execute.csr_alu_instance.immediate"
#lappend sg_csr_alu_dec "tb_processor.uut.execute.csr_alu_instance.use_immediate"
#lappend sg_csr_alu_dec "tb_processor.uut.execute.csr_alu_instance.write_mode"
#gtkwave::addSignalsFromList $sg_csr_alu_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_csr_alu_dec
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Execute_Out"
#set sg_execute [list]
#set sg_execute_dec [list]
#lappend sg_execute "tb_processor.uut.execute.count_instruction_out"
#lappend sg_execute "tb_processor.uut.execute.exe_op_num_out"
#lappend sg_execute "tb_processor.uut.execute.alu_op_out"
#lappend sg_execute "tb_processor.uut.execute.rd_write_out"
#lappend sg_execute "tb_processor.uut.execute.rd_addr_out"
#lappend sg_execute "tb_processor.uut.execute.rd_data_out"
#lappend sg_execute "tb_processor.uut.execute.mem_op_out"
#lappend sg_execute "tb_processor.uut.execute.mem_size_out"
#lappend sg_execute "tb_processor.uut.execute.dmem_address"
#lappend sg_execute "tb_processor.uut.execute.dmem_data_out"
#lappend sg_execute "tb_processor.uut.execute.dmem_data_size"
#lappend sg_execute "tb_processor.uut.execute.dmem_read_req"
#lappend sg_execute "tb_processor.uut.execute.dmem_write_req"
#lappend sg_execute "tb_processor.uut.execute.prev_dmem_address"
#lappend sg_execute "tb_processor.uut.execute.branch_out"
#lappend sg_execute "tb_processor.uut.execute.jump_out"
#lappend sg_execute "tb_processor.uut.execute.jump_target_out"
#lappend sg_execute "tb_processor.uut.execute.pc_out"
#lappend sg_execute "tb_processor.uut.execute.csr_addr_out"
#lappend sg_execute "tb_processor.uut.execute.csr_write_out"
#lappend sg_execute "tb_processor.uut.execute.csr_value_out"
#lappend sg_execute "tb_processor.uut.execute.mtvec_out"
#lappend sg_execute "tb_processor.uut.execute.exception_out"
#lappend sg_execute "tb_processor.uut.execute.exception_context_out"
#lappend sg_execute "tb_processor.uut.execute.hazard_detected"
#gtkwave::addSignalsFromList $sg_execute
#gtkwave::highlightSignalsFromList $sg_execute
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_execute_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_execute_dec
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Memory_In"
#set sg_mem_stage [list]
#set sg_mem_stage_dec [list]
#lappend sg_mem_stage "tb_processor.uut.memory.stall"
#lappend sg_mem_stage "tb_processor.uut.memory.count_instr_in"
#lappend sg_mem_stage "tb_processor.uut.memory.mem_op_num"
#lappend sg_mem_stage "tb_processor.uut.memory.mem_op_in"
#lappend sg_mem_stage "tb_processor.uut.memory.mem_size_in"
#lappend sg_mem_stage "tb_processor.uut.memory.dmem_read_ack"
#lappend sg_mem_stage "tb_processor.uut.memory.dmem_write_ack"
#lappend sg_mem_stage "tb_processor.uut.memory.dmem_data_in"
#lappend sg_mem_stage "tb_processor.uut.memory.rd_data_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.pc"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.rd_write_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.rd_addr_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.branch"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.alu_op_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.jump_taken_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.jump_target_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.exception_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.exception_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.csr_addr_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.csr_write_in"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.csr_data_in"
#gtkwave::addSignalsFromList $sg_mem_stage
#gtkwave::highlightSignalsFromList $sg_mem_stage
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_mem_stage_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_mem_stage_dec
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Memory_Ext"
set sg_mem_ext [list]
lappend sg_mem_ext "tb_processor.uut.execute.prev_alu_result"
lappend sg_mem_ext "tb_processor.dmem_address"
#lappend sg_mem_ext "tb_processor.dmem_data_in"
#lappend sg_mem_ext "tb_processor.dmem_data_out"
#lappend sg_mem_ext "tb_processor.dmem_data_size"
lappend sg_mem_ext "tb_processor.dmem_read_req"
lappend sg_mem_ext "tb_processor.dmem_read_ack"
lappend sg_mem_ext "tb_processor.dmem_write_req"
#lappend sg_mem_ext "tb_processor.dmem_write_ack"
gtkwave::addSignalsFromList $sg_mem_ext
gtkwave::highlightSignalsFromList $sg_mem_ext
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All

#gtkwave::addCommentTracesFromList "Memory_Out"
#set sg_mem_stage [list]
#set sg_mem_stage_dec [list]
#lappend sg_mem_stage "tb_processor.uut.memory.count_instr_out"
#lappend sg_mem_stage "tb_processor.uut.memory.mem_op_out"
#lappend sg_mem_stage "tb_processor.uut.memory.rd_write_out"
#lappend sg_mem_stage "tb_processor.uut.memory.rd_addr_out"
#lappend sg_mem_stage "tb_processor.uut.memory.rd_data_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.wb_op_num"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.alu_op_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.jump_taken_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.jump_target_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.exception_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.exception_context_out"
#lappend sg_mem_stage "tb_processor.uut.memory.csr_addr_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.csr_write_out"
#lappend sg_mem_stage_dec "tb_processor.uut.memory.csr_data_out"
#gtkwave::addSignalsFromList $sg_mem_stage
#gtkwave::highlightSignalsFromList $sg_mem_stage
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_mem_stage_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_mem_stage_dec
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Writeback_Out"
#set sg_writeback [list]
#set sg_writeback_dec [list]
#lappend sg_writeback "tb_processor.uut.writeback.count_instr_out"
#lappend sg_writeback "tb_processor.uut.writeback.op_num_out"
#lappend sg_writeback "tb_processor.uut.writeback.alu_op_out"
#lappend sg_writeback "tb_processor.uut.writeback.rd_write_out"
#lappend sg_writeback "tb_processor.uut.writeback.rd_addr_out"
#lappend sg_writeback "tb_processor.uut.writeback.rd_data_out"
#lappend sg_writeback "tb_processor.uut.writeback.jump_taken_out"
#lappend sg_writeback "tb_processor.uut.writeback.jump_target_out"
#lappend sg_writeback "tb_processor.uut.writeback.exception_ctx_out"
#lappend sg_writeback "tb_processor.uut.writeback.exception_out"
#lappend sg_writeback "tb_processor.uut.writeback.csr_write_out"
#lappend sg_writeback "tb_processor.uut.writeback.csr_data_out"
#lappend sg_writeback "tb_processor.uut.writeback.csr_addr_out"
#gtkwave::addSignalsFromList $sg_writeback_dec
#gtkwave::highlightSignalsFromList $sg_writeback_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_writeback
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "ROB_Completed_In"
#set sg_completed [list]
#set sg_completed_dec [list]
#lappend sg_completed_dec "tb_processor.uut.reorder_buffer.completed_num"
#lappend sg_completed     "tb_processor.uut.reorder_buffer.completed_op"
#lappend sg_completed_dec "tb_processor.uut.reorder_buffer.completed_res"
#lappend sg_completed     "tb_processor.uut.reorder_buffer.completed_jump_taken"
#lappend sg_completed_dec "tb_processor.uut.reorder_buffer.completed_jump_target"
#gtkwave::addSignalsFromList $sg_completed_dec
#gtkwave::highlightSignalsFromList $sg_completed_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_completed
#gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "ROB_Commit_Out"
#set sg_commit [list]
#set sg_commit_dec [list]
#lappend sg_commit_dec "tb_processor.uut.reorder_buffer.committing"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_num"
#lappend sg_commit     "tb_processor.uut.reorder_buffer.commit_op"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_x_src"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_y_src"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_rd_addr"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_res"
#lappend sg_commit     "tb_processor.uut.reorder_buffer.commit_rd_write"
#lappend sg_commit     "tb_processor.uut.reorder_buffer.commit_jump_taken"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_jump_target"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_mem_op"
#lappend sg_commit "tb_processor.uut.reorder_buffer.commit_mem_size"
#gtkwave::addSignalsFromList $sg_commit_dec
#gtkwave::highlightSignalsFromList $sg_commit_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_commit
#gtkwave::/Edit/UnHighlight_All


gtkwave::/Time/Zoom/Zoom_Full