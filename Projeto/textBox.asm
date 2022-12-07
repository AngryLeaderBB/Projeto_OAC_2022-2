.include "../MACROSv21.s"

.macro faster_rectangle(%address, %color , %xLower , %yLower, %xUpper, %yUpper)
	#address is the address of the bitmap display

	li a0,%address
	li a1,%color

	li a2,%xLower
	li a3,%yLower

	li a4,%xUpper
	li a5,%yUpper

	jal ra,FASTER_RECTANGLE

.end_macro
.data 
nome: .string "fica de testaum"
dialogo_tamanho: .word 163
dialogo: .string "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed fringilla metus in accumsan lacinia. Phasellus nec massa mattis, dictum sapien eu, egestas ipsum. Quisque sed ullamcorper quam, ac porta enim. Fusce consequat justo aliquam eros sagittis, id consectetur nulla convallis. Donec lacinia metus vel tortor malesuada"

.text


faster_rectangle(0xFF000000, 0xC0C0C0C0, 8, 36 , 316 , 106)
faster_rectangle(0xFF000000, 0x0F0F0F0F, 12, 40 , 80 , 102)
la a0,nome
li a1,89
li a2,40
li a3,0xC7FF
li a4,0
li a7,104
ecall
#la a0,dialogo
#li a1,94
#li a2,50
#ecall


#la a0,dialogo
#li a1,94
#li a2,90
#ecall

la a0,dialogo_tamanho
jal PrintDialog

li a7,10
ecall

FASTER_RECTANGLE: 
	
	mv t0,a2
	mv t1,a3
	li t2,320
	mul t2,t1,t2
	add t2,t2,t0
	add t2,a0,t2

LOOP2:
	bge t1,a5, END2
INNER_LOOP2:	
	bge t0,a4, END_INNER2
	
	sw a1,0(t2)

	addi t2,t2,4
	addi t0,t0,4
	j INNER_LOOP2
END_INNER2:
	add t2,t2,a2
	sub t2,t2,a4
	addi t2,t2,320
	mv t0,a2
	addi t1,t1,1
	j LOOP2
END2:
	ret
	
PrintDialog:
	# a0 = address ( length + string)
	lw t0,0(a0)  # t0 = length
	addi a0,a0,4 # addrress of string
	li t1,27     # max letters per line
	li t2,6      # max lines per textBox
	
	li t3,0	     # index of the letter 
	li t4,0	     # index of the line
	li t5,0	     # num of letters written
	
	li a7,111    # Print char
	li a3,0xC7FF   # Color
	li a4,0	     # Frame
Loop_PD:	
	beq t2,t4,End_PD
Inner_Loop_PB:	
	beq t1,t3,End_Inner_PD
	beq t0,t5,End_PD
	
	slli a1,t3,3
	addi a1,a1,94
	slli a2,t4,3
	addi a2,a2,50
	
	addi sp,sp,-4
	sw a0,0(sp)

	lb a0,0(a0)
	ecall	
	
	lw a0,0(sp)
	addi sp,sp,4
	
	addi t3,t3,1
	addi t5,t5,1
	addi a0,a0,1
	j Inner_Loop_PB
End_Inner_PD:

	li t3,0
	addi t4,t4,1
	j Loop_PD
End_PD:	

	slt t0,t5,t0
	beq t0,zero,End_Next_Symbol
	
	li a1,306
	li a2,98

	li a0,73
	li a3,0xC7FF
	li a4,0

	li a7,111
	ecall

	li a0,62
	addi a1,a1,2
	li a3,0xC7FF
	li a4,0
	ecall
End_Next_Symbol:
	
	ret	
	
.include "../SYSTEMv21.s"
