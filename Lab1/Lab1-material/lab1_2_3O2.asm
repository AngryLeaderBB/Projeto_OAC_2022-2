show(int*, int):
         mv     t0,a0 
         mv     t1,a1 
         mv     t2,zero 
loop1:  beq     t2,t1,fim1 
        li      a7,1 
        lw      a0,0(t0) 
        ecall 
        li      a7,11 
        li      a0,9 
        ecall 
        addi    t0,t0,4 
        addi    t2,t2,1 
        j       loop1 
fim1:   li      a7,11 
        li      a0,10 
        ecall 

        ret
swap(int*, int):
        slli    a1,a1,2
        addi    a5,a1,4
        add     a5,a0,a5
        lw      a3,0(a5)
        add     a1,a0,a1
        lw      a4,0(a1)
        sw      a3,0(a1)
        sw      a4,0(a5)
        ret
sort(int*, int):
        ble     a1,zero,.L4
        li      a4,0
        addi    a7,a4,1
        mv      a6,a0
        li      a0,-1
        beq     a1,a7,.L4
.L11:
        mv      a5,a6
        j       .L8
.L10:
        sw      a2,0(a5)
        sw      a3,4(a5)
        addi    a5,a5,-4
        beq     a4,a0,.L7
.L8:
        lw      a3,0(a5)
        lw      a2,4(a5)
        addi    a4,a4,-1
        bgt     a3,a2,.L10
.L7:
        mv      a4,a7
        addi    a7,a4,1
        addi    a6,a6,4
        bne     a1,a7,.L11
.L4:
        ret
main:
        addi    sp,sp,-16
        sw      s0,8(sp)
        lui     s0,%hi(.LANCHOR0)
        addi    a0,s0,%lo(.LANCHOR0)
        li      a1,30
        sw      ra,12(sp)
        call    show(int*, int)
        addi    a0,s0,%lo(.LANCHOR0)
        li      a1,30
        call    sort(int*, int)
        addi    a0,s0,%lo(.LANCHOR0)
        li      a1,30
        call    show(int*, int)
        lw      ra,12(sp)
        lw      s0,8(sp)
        li      a0,0
        addi    sp,sp,16
        jr      ra