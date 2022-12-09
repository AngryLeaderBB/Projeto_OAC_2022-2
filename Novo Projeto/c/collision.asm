.data

rect1: .word 0, 1, 1 ,2
rect2: .word 1, 5, 3 , 7

.text

la a0, rect1
la a1, rect2


jal doOverlap

li a7,1
ecall

li a7,10
ecall

doOverlap:
        lw      a3,0(a0)
        lw      a4,8(a1)
        mv      a5,a0
        bgt     a3,a4,.L3
        lw      a4,8(a0)
        lw      a3,0(a1)
        li      a0,0
        bgt     a3,a4,.L2
        lw      a3,12(a5)
        lw      a4,4(a1)
        bgt     a3,a4,.L2
        lw      a0,12(a1)
        lw      a5,4(a5)
        sgt     a0,a0,a5
        xori    a0,a0,1
        ret
.L3:
        li      a0,0
.L2:
        ret
        