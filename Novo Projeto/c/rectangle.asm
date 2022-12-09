.text

li s1, 0xFF000000

li a0, 0x77 # color
li a1, 80   # x
li a2, 0    # y
li a3, 50   # percent
li a4, 20   # width
li a5, 5    # height
jal bar

li a7,10
ecall

bar:
        mul     a3,a3,a4
        li      a6,100
        div     a3,a3,a6
        add     a6,a3,a1
        bge     a1,a6,.L1
        add     a5,a2,a5
        bge     a2,a5,.L1
        slli    a4,a5,2
        add     a4,a4,a5
        slli    a5,a2,2
        mv      a7,s1
        slli    a4,a4,6
        add     a2,a5,a2
        add     a4,a4,a7
        slli    a2,a2,6
        add     a4,a4,a1
        andi    a3,a0,0xff
        add     a2,a2,a7
.L6:
        add     a5,a2,a1
.L4:
        sb      a3,0(a5)
        addi    a5,a5,320
        bne     a4,a5,.L4
        addi    a1,a1,1
        addi    a4,a4,1
        bne     a1,a6,.L6
.L1:
        ret
