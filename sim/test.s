.global _start      

.text               
_start:

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
    
    # Esempio: Configurazione di un contatore personalizzato
    li x10, 100              # Carica il valore 100 in x11
    csrw mscratch, x10       # SCRITTURA: scrive 100 nel registro mscratch
    csrrwi x11, mscratch, 2
    csrrw x12, mscratch, x11

    srli x2, x2, 12
    add x3, x1, x2 
    addi x4, x0, 1
    sub x5, x3, x1
    and x6, x3, x4

    # HAZARD: L'istruzione successiva legge immediatamente mscratch
    #csrrsi x12, mscratch, 1       # LETTURA: x12 dovrebbe ricevere 100
    #addi x13, x12, 1          # Incrementa il valore letto

    #csrrw x12, mscratch, x10

    li x14, -72
    sra x15, x11, x4
    sltu x16, x9, x3
    slt x17, x11, x12
    j jump


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
    csrw 0xbf0, 0b11
    
    j stop