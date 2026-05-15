gtkwave::/Edit/Highlight_All
gtkwave::/Edit/Delete
gtkwave::/Edit/UnHighlight_All


set sg_generic [list]
lappend sg_generic "tb_soc.processor.clk"
lappend sg_generic "tb_soc.processor.reset"
gtkwave::addSignalsFromList $sg_generic
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Stalls"
set sg_stalls [list]
lappend sg_stalls "tb_soc.processor.processor.stall_if"
lappend sg_stalls "tb_soc.processor.processor.stall_id"
lappend sg_stalls "tb_soc.processor.processor.stall_rob_core"
lappend sg_stalls "tb_soc.processor.processor.stall_csr"
lappend sg_stalls "tb_soc.processor.processor.stall_ex"
lappend sg_stalls "tb_soc.processor.processor.stall_mem"
lappend sg_stalls "tb_soc.processor.processor.stall_wb"
lappend sg_stalls "tb_soc.processor.processor.stall_rob"
gtkwave::addSignalsFromList $sg_stalls 
gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "Fetch_In"
#set sg_fetch [list]
#set sg_fetch_dec [list]
#lappend sg_fetch_dec "tb_soc.processor.processor.fetch.imem_data_in"
#lappend sg_fetch "tb_soc.processor.processor.fetch.imem_ack"
#lappend sg_fetch "tb_soc.processor.processor.fetch.stall"
#lappend sg_fetch "tb_soc.processor.processor.fetch.flush"
#lappend sg_fetch "tb_soc.processor.processor.fetch.branch"
#lappend sg_fetch "tb_soc.processor.processor.fetch.exception"
#lappend sg_fetch_dec "tb_soc.processor.processor.fetch.branch_target"
#lappend sg_fetch "tb_soc.processor.processor.fetch.evec"
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
#lappend sg_fetch_dec "tb_soc.processor.processor.fetch.imem_address"
#lappend sg_fetch "tb_soc.processor.processor.fetch.imem_req"
#lappend sg_fetch "tb_soc.processor.processor.fetch.instruction_data"
#lappend sg_fetch_dec "tb_soc.processor.processor.fetch.instruction_address"
#lappend sg_fetch "tb_soc.processor.processor.fetch.instruction_ready"
#gtkwave::addSignalsFromList $sg_fetch_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_fetch_dec
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_fetch
#gtkwave::highlightSignalsFromList $sg_fetch
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Decoder_IN"
set sg_dec_in [list]
lappend sg_dec_in "tb_soc.processor.processor.decode.flush"
#lappend sg_dec_in "tb_soc.processor.processor.decode.stall"
lappend sg_dec_in "tb_soc.processor.processor.decode.instruction_data"
lappend sg_dec_in "tb_soc.processor.processor.decode.instruction_address"
lappend sg_dec_in "tb_soc.processor.processor.decode.instruction_ready"
lappend sg_dec_in "tb_soc.processor.processor.decode.instruction_count"
lappend sg_dec_in "tb_soc.processor.processor.decode.rob_table1_empty"
gtkwave::addSignalsFromList $sg_dec_in 
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All

#gtkwave::addCommentTracesFromList "Decoder"
#set sg_dec_in [list]
#lappend sg_dec_in "tb_soc.processor.processor.decode.state"
#lappend sg_dec_in "tb_soc.processor.processor.decode.instruction"
#lappend sg_dec_in "tb_soc.processor.processor.decode.pc"
#lappend sg_dec_in "tb_soc.processor.processor.decode.prev_instruction"
#lappend sg_dec_in "tb_soc.processor.processor.decode.prev_pc"
#lappend sg_dec_in "tb_soc.processor.processor.decode.next_csr_instr"
#gtkwave::addSignalsFromList $sg_dec_in 
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All

gtkwave::addCommentTracesFromList "Decoder_OUT" 
set sg_dec_out [list]
lappend sg_dec_out "tb_soc.processor.processor.decode.pc"
lappend sg_dec_out "tb_soc.processor.processor.decode.count_instruction"
lappend sg_dec_out "tb_soc.processor.processor.decode.count_instruction_csr"
lappend sg_dec_out "tb_soc.processor.processor.decode.rd_addr"
lappend sg_dec_out "tb_soc.processor.processor.decode.rs1_addr"
lappend sg_dec_out "tb_soc.processor.processor.decode.rs2_addr"
lappend sg_dec_out "tb_soc.processor.processor.decode.shamt"
lappend sg_dec_out "tb_soc.processor.processor.decode.funct3"
lappend sg_dec_out "tb_soc.processor.processor.decode.immediate"
lappend sg_dec_out "tb_soc.processor.processor.decode.rd_write"
lappend sg_dec_out "tb_soc.processor.processor.decode.branch"
lappend sg_dec_out "tb_soc.processor.processor.decode.alu_x_src"
lappend sg_dec_out "tb_soc.processor.processor.decode.alu_y_src"
lappend sg_dec_out "tb_soc.processor.processor.decode.alu_op"
lappend sg_dec_out "tb_soc.processor.processor.decode.mem_op"
lappend sg_dec_out "tb_soc.processor.processor.decode.mem_size"
lappend sg_dec_out "tb_soc.processor.processor.decode.csr_addr"
lappend sg_dec_out "tb_soc.processor.processor.decode.csr_write"
lappend sg_dec_out "tb_soc.processor.processor.decode.csr_use_imm"
#lappend sg_dec_out "tb_soc.processor.processor.decode.stall_csr"
#lappend sg_dec_out "tb_soc.processor.processor.decode.decode_exception"
#lappend sg_dec_out "tb_soc.processor.processor.decode.decode_exception_cause"
gtkwave::addSignalsFromList $sg_dec_out
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "CSR_In"
set sg_csr [list]
lappend sg_csr "tb_soc.processor.processor.csr_unit.count_instruction"
lappend sg_csr "tb_soc.processor.processor.csr_unit.count_instruction_csr"
lappend sg_csr "tb_soc.processor.processor.csr_unit.read_address"
lappend sg_csr "tb_soc.processor.processor.csr_unit.write_address"
lappend sg_csr "tb_soc.processor.processor.csr_unit.write_data_in"
lappend sg_csr "tb_soc.processor.processor.csr_unit.write_mode"
lappend sg_csr "tb_soc.processor.processor.csr_unit.exception_context"
lappend sg_csr "tb_soc.processor.processor.csr_unit.exception_context_write"
gtkwave::addSignalsFromList $sg_csr
gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "CSR_Out"
#set sg_csr [list]
#lappend sg_csr "tb_soc.processor.processor.csr_unit.test_context_out"
#lappend sg_csr "tb_soc.processor.processor.csr_unit.read_data_out"
#lappend sg_csr "tb_soc.processor.processor.csr_unit.software_interrupt_out"
#lappend sg_csr "tb_soc.processor.processor.csr_unit.timer_interrupt_out"
#lappend sg_csr "tb_soc.processor.processor.csr_unit.mie_out"
#lappend sg_csr "tb_soc.processor.processor.csr_unit.mtvec_out"
#lappend sg_csr "tb_soc.processor.processor.csr_unit.ie_out"
#lappend sg_csr "tb_soc.processor.processor.csr_unit.ie1_out"
#gtkwave::addSignalsFromList $sg_csr
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "ROB_Generic"
set sg_rob_generic [list]
lappend sg_rob_generic "tb_soc.processor.processor.reorder_buffer.stall"
lappend sg_rob_generic "tb_soc.processor.processor.reorder_buffer.count_instruction1"
#lappend sg_rob_generic "tb_soc.processor.processor.reorder_buffer.count_instruction2"
lappend sg_rob_generic "tb_soc.processor.processor.reorder_buffer.fetch1_enable"
#lappend sg_rob_generic "tb_soc.processor.processor.reorder_buffer.fetch2_enable"
lappend sg_rob_generic "tb_soc.processor.processor.reorder_buffer.table1_empty"
gtkwave::addSignalsFromList $sg_rob_generic
gtkwave::highlightSignalsFromList $sg_rob_generic
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "ROB_DataIn1"
#set sg_rob_datain [list]
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.pc_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.alu_op_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.alu_x_src_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.alu_x_addr_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.alu_y_src_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.alu_y_addr_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.rd_addr_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.rd_write_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.immediate_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.shamt_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.mem_op_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.mem_size_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.branch_1"
#lappend sg_rob_datain "tb_soc.processor.processor.reorder_buffer.funct3_1"
#gtkwave::addSignalsFromList $sg_rob_datain
#gtkwave::highlightSignalsFromList $sg_rob_datain
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "ROB_Pointers"
set sg_pointers [list]
lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_start1"
#lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_start2"
lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_exec1"
#lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_nextexec1"
#lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_exec2"
#lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_nextexec2"
lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_end1"
#lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_nextend1"
#lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_end2"
#lappend sg_pointers "tb_soc.processor.processor.reorder_buffer.pntr_nextend2"
gtkwave::addSignalsFromList $sg_pointers
gtkwave::highlightSignalsFromList $sg_pointers
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "ROB_Table"
set sg_rob_table [list]
set sg_rob_table_bin [list]
set sg_rob_table_dec [list]
lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.uses"
lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.p1"
lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.p2"
lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.exec"
lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.comm"
lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.branch"
lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.jump_taken"
lappend sg_rob_table     "tb_soc.processor.processor.reorder_buffer.alu_op"
lappend sg_rob_table     "tb_soc.processor.processor.reorder_buffer.alu_x_src"
lappend sg_rob_table     "tb_soc.processor.processor.reorder_buffer.alu_y_src"
#lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.rd_write"
lappend sg_rob_table     "tb_soc.processor.processor.reorder_buffer.mem_op"
lappend sg_rob_table     "tb_soc.processor.processor.reorder_buffer.mem_size"
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
#    lappend sg_rob_table "tb_soc.processor.processor.reorder_buffer.pc\[$i\]"
#    lappend sg_rob_table_dec "tb_soc.processor.processor.reorder_buffer.alu_x_addr\[$i\]"
#    lappend sg_rob_table_dec "tb_soc.processor.processor.reorder_buffer.alu_y_addr\[$i\]"
#    lappend sg_rob_table_dec "tb_soc.processor.processor.reorder_buffer.rd\[$i\]"
#    lappend sg_rob_table_dec "tb_soc.processor.processor.reorder_buffer.imm\[$i\]"
#    lappend sg_rob_table_dec "tb_soc.processor.processor.reorder_buffer.shamt\[$i\]"
#    lappend sg_rob_table_dec "tb_soc.processor.processor.reorder_buffer.res\[$i\]"
#    lappend sg_rob_table_bin "tb_soc.processor.processor.reorder_buffer.funct3\[$i\]"
#    gtkwave::addSignalsFromList $sg_rob_table_dec
#    gtkwave::highlightSignalsFromList $sg_rob_table_dec
#    gtkwave::/Edit/Data_Format/Decimal
#    gtkwave::/Edit/UnHighlight_All
#}


gtkwave::addCommentTracesFromList "ROB_Execution"
set sg_execution [list]
set sg_execution_dec [list]
lappend sg_execution "tb_soc.processor.processor.reorder_buffer.execution1_num"
lappend sg_execution     "tb_soc.processor.processor.reorder_buffer.execution1_alu_op"
#lappend sg_execution     "tb_soc.processor.processor.reorder_buffer.execution1_alu_x_src"
#lappend sg_execution_dec "tb_soc.processor.processor.reorder_buffer.execution1_alu_x_addr"
#lappend sg_execution     "tb_soc.processor.processor.reorder_buffer.execution1_alu_y_src"
#lappend sg_execution_dec "tb_soc.processor.processor.reorder_buffer.execution1_alu_y_addr"
#lappend sg_execution_dec "tb_soc.processor.processor.reorder_buffer.execution1_immediate"
#lappend sg_execution_dec "tb_soc.processor.processor.reorder_buffer.execution1_shamt"
#lappend sg_execution     "tb_soc.processor.processor.reorder_buffer.execution1_mem_op"
#lappend sg_execution     "tb_soc.processor.processor.reorder_buffer.execution1_mem_size"
#lappend sg_execution_dec "tb_soc.processor.processor.reorder_buffer.execution1_pc"
#lappend sg_execution     "tb_soc.processor.processor.reorder_buffer.execution1_branch"
#lappend sg_execution     "tb_soc.processor.processor.reorder_buffer.execution1_funct3"
gtkwave::addSignalsFromList $sg_execution_dec
gtkwave::highlightSignalsFromList $sg_execution_dec
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_execution
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Reg_File"
set sg_reg_file [list]
lappend sg_reg_file "tb_soc.processor.processor.regfile.rd_write"
lappend sg_reg_file "tb_soc.processor.processor.regfile.rd_addr"
lappend sg_reg_file "tb_soc.processor.processor.regfile.rd_data"
lappend sg_reg_file "tb_soc.processor.processor.regfile.rs1_addr"
lappend sg_reg_file "tb_soc.processor.processor.regfile.rs1_data"
lappend sg_reg_file "tb_soc.processor.processor.regfile.rs2_addr"
lappend sg_reg_file "tb_soc.processor.processor.regfile.rs2_data"
gtkwave::addSignalsFromList $sg_reg_file
gtkwave::highlightSignalsFromList $sg_reg_file
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Execute_In"
set sg_execute [list]
set sg_execute_dec [list]
lappend sg_execute "tb_soc.processor.processor.execute.stall"
lappend sg_execute "tb_soc.processor.processor.execute.flush"
#lappend sg_execute "tb_soc.processor.processor.execute.software_interrupt"
#lappend sg_execute "tb_soc.processor.processor.execute.timer_interrupt"
lappend sg_execute "tb_soc.processor.processor.execute.rob_op_num_in"
lappend sg_execute "tb_soc.processor.processor.execute.alu_op_in"
lappend sg_execute "tb_soc.processor.processor.execute.rd_write_in"
lappend sg_execute "tb_soc.processor.processor.execute.rd_addr_in"
lappend sg_execute "tb_soc.processor.processor.execute.alu_x_src_in"
lappend sg_execute "tb_soc.processor.processor.execute.rs1_addr_in"
lappend sg_execute "tb_soc.processor.processor.execute.rs1_data_in"
lappend sg_execute "tb_soc.processor.processor.execute.alu_y_src_in"
lappend sg_execute "tb_soc.processor.processor.execute.rs2_addr_in"
lappend sg_execute "tb_soc.processor.processor.execute.rs2_data_in"
lappend sg_execute "tb_soc.processor.processor.execute.shamt_in"
lappend sg_execute "tb_soc.processor.processor.execute.immediate_in"
lappend sg_execute "tb_soc.processor.processor.execute.pc_in"
#lappend sg_execute "tb_soc.processor.processor.execute.funct3_in"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_addr_in"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_write_in"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_value_in"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_use_immediate_in"
lappend sg_execute "tb_soc.processor.processor.execute.branch_in"
lappend sg_execute "tb_soc.processor.processor.execute.mem_op_in"
lappend sg_execute "tb_soc.processor.processor.execute.mem_size_in"
#lappend sg_execute "tb_soc.processor.processor.execute.count_instruction_in"
#lappend sg_execute "tb_soc.processor.processor.execute.ie_in"
#lappend sg_execute "tb_soc.processor.processor.execute.ie1_in"
#lappend sg_execute "tb_soc.processor.processor.execute.mie_in"
#lappend sg_execute "tb_soc.processor.processor.execute.mtvec_in"
#lappend sg_execute "tb_soc.processor.processor.execute.decode_exception_in"
#lappend sg_execute "tb_soc.processor.processor.execute.decode_exception_cause_in"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_rd_write"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_rd_addr"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_rd_value"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_csr_addr"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_csr_write"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_exception"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_rd_write"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_rd_addr"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_rd_value"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_csr_addr"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_csr_write"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_exception"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_mem_op"
gtkwave::addSignalsFromList $sg_execute
gtkwave::highlightSignalsFromList $sg_execute
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_execute_dec
gtkwave::/Edit/Data_Format/Decimal
gtkwave::highlightSignalsFromList $sg_execute_dec
gtkwave::/Edit/UnHighlight_All



#gtkwave::addCommentTracesFromList "Execute_forwarding"
#set sg_execute [list]
#set sg_execute_dec [list]
#lappend sg_execute "tb_soc.processor.processor.execute.csr_write"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_addr"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_value_in"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_count_instr"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_csr_write"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_csr_addr"
#lappend sg_execute "tb_soc.processor.processor.execute.mem_csr_data"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_count_instr"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_csr_write"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_csr_addr"
#lappend sg_execute "tb_soc.processor.processor.execute.wb_csr_data"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_value"
#gtkwave::addSignalsFromList $sg_execute
#gtkwave::highlightSignalsFromList $sg_execute
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_execute_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_execute_dec
#gtkwave::/Edit/UnHighlight_All

#gtkwave::addCommentTracesFromList "ALU"
#set sg_alu_dec [list]
#lappend sg_alu_dec "tb_soc.processor.processor.execute.alu_instance.operation"
#lappend sg_alu_dec "tb_soc.processor.processor.execute.alu_instance.x"
#lappend sg_alu_dec "tb_soc.processor.processor.execute.alu_instance.y"
#lappend sg_alu_dec "tb_soc.processor.processor.execute.alu_instance.result"
#gtkwave::addSignalsFromList $sg_alu_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_alu_dec
#gtkwave::/Edit/UnHighlight_All

#gtkwave::addCommentTracesFromList "CSR_ALU"
#set sg_csr_alu_dec [list]
#lappend sg_csr_alu_dec "tb_soc.processor.processor.execute.csr_alu_instance.x"
#lappend sg_csr_alu_dec "tb_soc.processor.processor.execute.csr_alu_instance.y"
#lappend sg_csr_alu_dec "tb_soc.processor.processor.execute.csr_alu_instance.result"
#lappend sg_csr_alu_dec "tb_soc.processor.processor.execute.csr_alu_instance.immediate"
#lappend sg_csr_alu_dec "tb_soc.processor.processor.execute.csr_alu_instance.use_immediate"
#lappend sg_csr_alu_dec "tb_soc.processor.processor.execute.csr_alu_instance.write_mode"
#gtkwave::addSignalsFromList $sg_csr_alu_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::highlightSignalsFromList $sg_csr_alu_dec
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Execute_Out"
set sg_execute [list]
set sg_execute_dec [list]
lappend sg_execute "tb_soc.processor.processor.execute.count_instruction_out"
lappend sg_execute "tb_soc.processor.processor.execute.exe_op_num_out"
lappend sg_execute "tb_soc.processor.processor.execute.alu_op_out"
lappend sg_execute "tb_soc.processor.processor.execute.rd_write_out"
lappend sg_execute "tb_soc.processor.processor.execute.rd_addr_out"
lappend sg_execute "tb_soc.processor.processor.execute.rd_data_out"
lappend sg_execute "tb_soc.processor.processor.execute.mem_op_out"
lappend sg_execute "tb_soc.processor.processor.execute.mem_size_out"
lappend sg_execute "tb_soc.processor.processor.execute.dmem_address"
lappend sg_execute "tb_soc.processor.processor.execute.dmem_data_out"
lappend sg_execute "tb_soc.processor.processor.execute.dmem_data_size"
lappend sg_execute "tb_soc.processor.processor.execute.dmem_read_req"
lappend sg_execute "tb_soc.processor.processor.execute.dmem_write_req"
lappend sg_execute "tb_soc.processor.processor.execute.prev_dmem_address"
lappend sg_execute "tb_soc.processor.processor.execute.branch_out"
lappend sg_execute "tb_soc.processor.processor.execute.jump_out"
lappend sg_execute "tb_soc.processor.processor.execute.jump_target_out"
lappend sg_execute "tb_soc.processor.processor.execute.pc_out"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_addr_out"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_write_out"
#lappend sg_execute "tb_soc.processor.processor.execute.csr_value_out"
#lappend sg_execute "tb_soc.processor.processor.execute.mtvec_out"
#lappend sg_execute "tb_soc.processor.processor.execute.exception_out"
#lappend sg_execute "tb_soc.processor.processor.execute.exception_context_out"
#lappend sg_execute "tb_soc.processor.processor.execute.hazard_detected"
gtkwave::addSignalsFromList $sg_execute
gtkwave::highlightSignalsFromList $sg_execute
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_execute_dec
gtkwave::/Edit/Data_Format/Decimal
gtkwave::highlightSignalsFromList $sg_execute_dec
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Memory_In"
set sg_mem_stage [list]
set sg_mem_stage_dec [list]
lappend sg_mem_stage "tb_soc.processor.processor.memory.stall"
lappend sg_mem_stage "tb_soc.processor.processor.memory.count_instr_in"
lappend sg_mem_stage "tb_soc.processor.processor.memory.mem_op_num"
lappend sg_mem_stage "tb_soc.processor.processor.memory.mem_op_in"
lappend sg_mem_stage "tb_soc.processor.processor.memory.mem_size_in"
lappend sg_mem_stage "tb_soc.processor.processor.memory.dmem_read_ack"
lappend sg_mem_stage "tb_soc.processor.processor.memory.dmem_write_ack"
lappend sg_mem_stage "tb_soc.processor.processor.memory.dmem_data_in"
lappend sg_mem_stage "tb_soc.processor.processor.memory.rd_data_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.pc"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.rd_write_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.rd_addr_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.branch"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.alu_op_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.jump_taken_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.jump_target_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.exception_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.exception_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.csr_addr_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.csr_write_in"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.csr_data_in"
gtkwave::addSignalsFromList $sg_mem_stage
gtkwave::highlightSignalsFromList $sg_mem_stage
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_mem_stage_dec
gtkwave::/Edit/Data_Format/Decimal
gtkwave::highlightSignalsFromList $sg_mem_stage_dec
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Memory_Ext"
set sg_mem_ext [list]
lappend sg_mem_ext "tb_soc.processor.dmem_address"
lappend sg_mem_ext "tb_soc.processor.dmem_data_in"
lappend sg_mem_ext "tb_soc.processor.dmem_data_out"
lappend sg_mem_ext "tb_soc.processor.dmem_data_size"
lappend sg_mem_ext "tb_soc.processor.dmem_read_req"
lappend sg_mem_ext "tb_soc.processor.dmem_read_ack"
lappend sg_mem_ext "tb_soc.processor.dmem_write_req"
lappend sg_mem_ext "tb_soc.processor.dmem_write_ack"
gtkwave::addSignalsFromList $sg_mem_ext
gtkwave::highlightSignalsFromList $sg_mem_ext
gtkwave::/Edit/UnHighlight_All

gtkwave::addCommentTracesFromList "Memory_Out"
set sg_mem_stage [list]
set sg_mem_stage_dec [list]
lappend sg_mem_stage "tb_soc.processor.processor.memory.count_instr_out"
lappend sg_mem_stage "tb_soc.processor.processor.memory.mem_op_out"
lappend sg_mem_stage "tb_soc.processor.processor.memory.rd_write_out"
lappend sg_mem_stage "tb_soc.processor.processor.memory.rd_addr_out"
lappend sg_mem_stage "tb_soc.processor.processor.memory.rd_data_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.wb_op_num"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.alu_op_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.jump_taken_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.jump_target_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.exception_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.exception_context_out"
#lappend sg_mem_stage "tb_soc.processor.processor.memory.csr_addr_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.csr_write_out"
#lappend sg_mem_stage_dec "tb_soc.processor.processor.memory.csr_data_out"
gtkwave::addSignalsFromList $sg_mem_stage
gtkwave::highlightSignalsFromList $sg_mem_stage
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_mem_stage_dec
gtkwave::/Edit/Data_Format/Decimal
gtkwave::highlightSignalsFromList $sg_mem_stage_dec
gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "Writeback_Out"
set sg_writeback [list]
set sg_writeback_dec [list]
lappend sg_writeback "tb_soc.processor.processor.writeback.count_instr_out"
lappend sg_writeback "tb_soc.processor.processor.writeback.op_num_out"
lappend sg_writeback "tb_soc.processor.processor.writeback.alu_op_out"
lappend sg_writeback "tb_soc.processor.processor.writeback.rd_write_out"
lappend sg_writeback "tb_soc.processor.processor.writeback.rd_addr_out"
lappend sg_writeback "tb_soc.processor.processor.writeback.rd_data_out"
#lappend sg_writeback "tb_soc.processor.processor.writeback.jump_taken_out"
#lappend sg_writeback "tb_soc.processor.processor.writeback.jump_target_out"
#lappend sg_writeback "tb_soc.processor.processor.writeback.exception_ctx_out"
#lappend sg_writeback "tb_soc.processor.processor.writeback.exception_out"
#lappend sg_writeback "tb_soc.processor.processor.writeback.csr_write_out"
#lappend sg_writeback "tb_soc.processor.processor.writeback.csr_data_out"
#lappend sg_writeback "tb_soc.processor.processor.writeback.csr_addr_out"
gtkwave::addSignalsFromList $sg_writeback_dec
gtkwave::highlightSignalsFromList $sg_writeback_dec
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_writeback
gtkwave::/Edit/UnHighlight_All


#gtkwave::addCommentTracesFromList "ROB_Completed_In"
#set sg_completed [list]
#set sg_completed_dec [list]
#lappend sg_completed_dec "tb_soc.processor.processor.reorder_buffer.completed1_num"
#lappend sg_completed     "tb_soc.processor.processor.reorder_buffer.completed1_op"
#lappend sg_completed_dec "tb_soc.processor.processor.reorder_buffer.completed1_res"
#lappend sg_completed     "tb_soc.processor.processor.reorder_buffer.completed1_jump_taken"
#lappend sg_completed_dec "tb_soc.processor.processor.reorder_buffer.completed1_jump_target"
#gtkwave::addSignalsFromList $sg_completed_dec
#gtkwave::highlightSignalsFromList $sg_completed_dec
#gtkwave::/Edit/Data_Format/Decimal
#gtkwave::/Edit/UnHighlight_All
#gtkwave::addSignalsFromList $sg_completed
#gtkwave::/Edit/UnHighlight_All


gtkwave::addCommentTracesFromList "ROB_Commit_Out"
set sg_commit [list]
set sg_commit_dec [list]
#lappend sg_commit_dec "tb_soc.processor.processor.reorder_buffer.committing_t1"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_num"
lappend sg_commit     "tb_soc.processor.processor.reorder_buffer.commit1_op"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_x_src"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_y_src"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_rd_addr"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_res"
lappend sg_commit     "tb_soc.processor.processor.reorder_buffer.commit1_rd_write"
lappend sg_commit     "tb_soc.processor.processor.reorder_buffer.commit1_jump_taken"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_jump_target"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_mem_op"
lappend sg_commit "tb_soc.processor.processor.reorder_buffer.commit1_mem_size"
gtkwave::addSignalsFromList $sg_commit_dec
gtkwave::highlightSignalsFromList $sg_commit_dec
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::addSignalsFromList $sg_commit
gtkwave::/Edit/UnHighlight_All


gtkwave::/Time/Zoom/Zoom_Full