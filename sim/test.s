.global _start      

.text               
_start:

    LI x3, 4096      
    LI x4, 4224      
    LI x1, 111    
    LI x2, 222       

    SW x1, 0(x3)
    SH x2, 0(x3)
    ADDI x5, x0, 1  

    SW x1, 0(x3)
    SW x2, 0(x4)
    ADDI x5, x0, 2

    LW x11, 0(x3)
    LH x12, 0(x3)
    ADDI x5, x0, 3

    LW x11, 0(x3)
    LW x12, 0(x4)
    ADDI x5, x0, 4

    SW x1, 0(x3)
    LW x11, 0(x3)
    ADDI x5, x0, 5

    LW x11, 0(x3)
    SW x1, 0(x3)
    ADDI x5, x0, 6

    SW x1, 0(x3)
    LW x11, 0(x4)
    ADDI x5, x0, 7

    LW x11, 0(x3)
    SW x1, 0(x4)
    ADDI x5, x0, 8

stop:
    csrw 0xbf0, 0b11
    
    j stop