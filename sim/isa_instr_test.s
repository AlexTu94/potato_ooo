REGISTER - REGISTER     : add, sub, and, or, xor, sll, srl, sra, slt, sltu
REGISTER - IMMEDIATE    : addi, andi, ori, xori, slli, srli, srai, slti, sltiu
                          li, lui, auipc
LOAD                    : lb, lh, lbu, lhu, lw
STORE                   : sb, sh, sw
JUMP                    : j, jal, jalr
BRANCH                  : beq, bne, blt, bge, bltu, bgeu
THE ABOVE ARE ALL WORKING 
ZICSR                   : csrrw, csrrs, csrrc, csrrwi, csrrsi, csrrci
SYSTEM                  : ecall, ebreak, fence
WHAT DOES IS            : simple (nothing, it's just a test)

x1 10
x2 20480->5
x3 15
x4 1
x5 5
x6 1
x7 5
x8 4
x9 10
x10 5
x11 -72
x12 -36
x13 1
x14 1
x15 2
x16 11
x17 15
x18 40
x19 3
x20 -18
x21 1
x22 1

    li x1, 10
    lui x2, 5
    srli x2, x2, 12
    add x3, x1, x2 
    addi x4, x0, 1
    sub x5, x3, x1
    and x6, x3, x4
    or x7, x5, x4
    xor x8, x6, x2
    sll x9, x2, x4
    srl x10, x1, x6
    li x11, -72
    sra x12, x11, x4
    sltu x13, x9, x3
    slt x14, x11, x12
    andi x15, x9, 2
    ori x16, x9, 3
    xori x17, x7, 10
    slli x18, x10, 3
    srli x19, x3, 2
    srai x20, x12, 1
    slti x21, x12, -2
    sltiu x22, x16, 15


    
    li x1, 262402
    li x2, -259

    li x3, 4096
    sw x1, 0(x3)

    li x4, 4224
    sw x2, 0(x4) 

    sw x1, 0(x3)
    sh x1, 0(x3)
    sb x1, 0(x3)

    lw x11, 0(x3)
    lh x12, 0(x3)
    lb x13, 0(x3)

    lw x11, 0(x4)
    lhu x12, 0(x4)
    lbu x13, 0(x4)


TEST CHE (DOVREBBE) COPRIRE TUTTO
(NON COPRE LE OPERAZIONI IN MEMORIA)
    li x1, 10
    lui x2, 5
    srli x2, x2, 12
    add x3, x1, x2 
    addi x4, x0, 1
    sub x5, x3, x1
    and x6, x3, x4
    or x7, x5, x4
    xor x8, x6, x2
    sll x9, x2, x4
    srl x10, x1, x6
    
    li x1, 1
    li x2, 1

    beq x1, x2, jump
    li x1, 10
    lui x2, 5
    srli x2, x2, 12
    add x3, x1, x2 
    addi x4, x0, 1
    sub x5, x3, x1
    and x6, x3, x4
    or x7, x5, x4
    xor x8, x6, x2
    sll x9, x2, x4
    srl x10, x1, x6

linkato: 
    slt x14, x11, x12
    andi x15, x9, 2
    ori x16, x9, 3
    xori x17, x7, 10
    slli x18, x10, 3
    srli x19, x3, 2
    srai x20, x12, 1
    j stop

jump: 
    li x11, -72
    sra x12, x11, x4
    sltu x13, x9, x3
    slt x14, x11, x12
    andi x15, x9, 2
    ori x16, x9, 3
    xori x17, x7, 10
    slli x18, x10, 3
    srli x19, x3, 2
    srai x20, x12, 1
    slti x21, x12, -2
    sltiu x22, x16, 15
    jal x5, linkato

stop:
    j stop






 # ---------------------------------------------------------
    # 1. CSRRW (Read and Write)
    # Sintassi: csrrw rd, csr, rs1
    # Operazione: rd = csr; csr = rs1
    # ---------------------------------------------------------
    li t1, 0x1000           # Carica il valore 0x1000 nel registro t1
    csrrw t0, mscratch, t1  # Salva il vecchio valore di mscratch in t0 e scrive t1 in mscratch

    # ---------------------------------------------------------
    # 2. CSRRS (Read and Set)
    # Sintassi: csrrs rd, csr, rs1
    # Operazione: rd = csr; csr = csr | rs1
    # ---------------------------------------------------------
    li t1, 0x8              # Maschera con il bit 3 a 1 (es. per MIE in mstatus)
    csrrs t0, mstatus, t1   # Salva mstatus in t0 e imposta a 1 i bit specificati in t1

    # ---------------------------------------------------------
    # 3. CSRRC (Read and Clear)
    # Sintassi: csrrc rd, csr, rs1
    # Operazione: rd = csr; csr = csr & ~rs1
    # ---------------------------------------------------------
    li t1, 0x8              # Maschera con il bit 3 a 1
    csrrc t0, mstatus, t1   # Salva mstatus in t0 e azzera (mette a 0) i bit specificati in t1

    # ---------------------------------------------------------
    # Le varianti "I" (Immediate) usano un valore immediato a 5 bit (0-31) 
    # al posto del registro rs1.
    # ---------------------------------------------------------

    # ---------------------------------------------------------
    # 4. CSRRWI (Read and Write Immediate)
    # Sintassi: csrrwi rd, csr, uimm
    # Operazione: rd = csr; csr = uimm
    # ---------------------------------------------------------
    csrrwi t0, mscratch, 15 # Salva il vecchio valore di mscratch in t0 e ci scrive il valore 15

    # ---------------------------------------------------------
    # 5. CSRRSI (Read and Set Immediate)
    # Sintassi: csrrsi rd, csr, uimm
    # Operazione: rd = csr; csr = csr | uimm
    # ---------------------------------------------------------
    csrrsi t0, mstatus, 8   # Salva mstatus in t0 e imposta a 1 il bit 3 (valore 8)

    # ---------------------------------------------------------
    # 6. CSRRCI (Read and Clear Immediate)
    # Sintassi: csrrci rd, csr, uimm
    # Operazione: rd = csr; csr = csr & ~uimm
    # ---------------------------------------------------------
    csrrci t0, mstatus, 8   # Salva mstatus in t0 e azzera il bit 3 (valore 8)

    # ---------------------------------------------------------
    # Loop infinito di terminazione
    # ---------------------------------------------------------