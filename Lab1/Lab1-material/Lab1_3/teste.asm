.include "MACROSv21.s"

.data 

cor: .string "cor"
dificuldade: .string "dificuldade"
facil: .string "facil"
medio: .string "medio"
dificil: .string "dificil"

difficult: .word 0
color: .word 0
is_color: .word 0
menu: .word 0x1300,0,0,0x1300,0

.text


############### menu #################
li a3, 0xFF
li a4, 0

la a0, dificuldade
li a1, 117
li a2, 89
li a7, 104
ecall

la a0, cor
li a1, 149
li a2, 121
li a7, 104
ecall

menu_loop:
jal KEY
li t0, 10
beq a0,t0, end_menu
# li a0, 97
la a1, is_color
la a2, menu
addi a3, a2, 12
la a4, difficult

jal iterate_menu

la t0, is_color
lw t0,0(t0)

li a0, 42
li a3, 0
li a4, 0
li a7,111
	
bne t0,zero,if_select
	li a1, 129
	li a2, 137
	ecall 
	
	li a1, 69
	li a2, 105
	
j end_select
if_select:
	li a1, 69
	li a2, 105
	ecall

	li a1, 129
	li a2, 137

end_select:

	li a3, 0xff
	ecall

li a3, 0xFF
li a4, 0

la t0, menu

la a0, facil
li a1, 85
li a2, 105
li a3, 0x33
lw t1,0(t0)
add a3, a3, t1
li a7, 104
ecall

la a0, medio
li a1, 133
li a2, 105
li a3, 0x77
lw t1,4(t0)
add a3, a3, t1
li a7, 104
ecall

la a0, dificil
li a1, 181
li a2, 105
li a3, 0x6
lw t1,8(t0)
add a3, a3, t1
li a7, 104
ecall


#li a0, 0
#li a1, 157
#li a2, 137
#li a7, 101
# ecall

addi t0,t0,12

li a0, 1
li a1, 145
li a2, 137
li a3, 7
lw t1,0(t0)
add a3, a3, t1
li a7, 101
ecall

li a0, 2
li a1, 172
li a2, 137
li a3, 0xc0
lw t1,4(t0)
add a3, a3, t1
li a7, 101
ecall

#la a0, dificuldade
#li a7,4
#ecall

#la a0, difficult
#lw a0,0(a0)
#li a7, 1
#ecall

#li a0, 10
#li a7, 11
#ecall

#la a0, cor
#li a7,4
#ecall

#la a0, difficult
#addi a0, a0, 4
#lw a0,0(a0)
#li a7, 1
#ecall



#li a0, 10
#li a7, 11
#ecall

#la a0, is_color
#lw a0, 0(a0)
#li a7, 1
#ecall

j menu_loop

end_menu:

li a7,10
ecall

loop: jal KEY

bne a0,zero,fim 

j loop
fim:
li a7,1
ecall

li a7,10
ecall


iterate_menu:
        li      a5,97
        beq     a0,a5,IM6
        li      a5,100
        beq     a0,a5,IM8
        andi    a0,a0,-5
        li      a5,115
        beq     a0,a5,IM9
        ret
IM8:
        lbu     a1,0(a1)
        li      a5,1
        beq     a1,zero,IM4
IM10:
        lw      a1,4(a4)
        addi    a2,a1,1
        srli    a0,a2,31
        add     a5,a2,a0
        slli    a1,a1,2
        add     a2,a3,a1
        andi    a5,a5,1
        lw      a1,0(a2)
        sub     a5,a5,a0
        slli    a0,a5,2
        add     a3,a3,a0
        sw      a1,0(a3)
        sw      zero,0(a2)
        sw      a5,4(a4)
        ret
IM9:
        lbu     a5,0(a1)
        xori    a5,a5,1
        sb      a5,0(a1)
        ret
IM6:
        lbu     a1,0(a1)
        li      a5,2
        bne     a1,zero,IM10
IM4:
        lw      a3,0(a4)
        li      a1,3
        add     a5,a5,a3
        rem     a5,a5,a1
        slli    a3,a3,2
        add     a3,a2,a3
        lw      a1,0(a3)
        slli    a0,a5,2
        add     a2,a2,a0
        sw      a1,0(a2)
        sw      zero,0(a3)
        sw      a5,0(a4)
        ret

KEY:	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se n�o h� tecla pressionada ent�o vai para FIM
  	lw a0,4(t1)  			# le o valor da tecla tecla
	sw a0,12(t1)  			# escreve a tecla pressionada no display
FIM:	ret	
.include "SYSTEMv21.s"
