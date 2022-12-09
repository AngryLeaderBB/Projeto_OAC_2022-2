.include "../MACROSv21.s"

.macro print_dialog(%address, %x, %y, %written, %letters, %lines, %color)

	mv a0, %address,
	mv a1, %x,
	mv a2, %y
	mv a3, %written
	li a4, %letters
	li a5, %lines
	li a6, %color
	jal PrintDialog

.end_macro

.data
nome: .word 5
.string "Boraaa"

.text

li s1, 0xFF000000
la t0, nome
li t1, 10
li t2, 10
li t3, 0
print_dialog(t0 t1, t2, t3, 3, 2, 0xC7FF)
li a7,10
ecall

PrintDialog:
	# a0 = address ( length + string)
	# a1 = x, a2 = y
	# a3 = num already read letters
	# a4 = max letters per line
	# a5 = max lines per textBox
	# a6 = color
	
	lw t0,0(a0)  # t0 = length
	addi a0,a0,4 # addrress of string
	mv t1,a4     # max letters per line
	mv t2,a5     # max lines per textBox
	
	li t3,0	     # index of the letter 
	li t4,0	     # index of the line
	mv t5,a3     # num of letters written
	
	mv t6, a1
	mv a5, a2

	add a0,a0,t5
	
	li a7,111    # Print char
	mv a3, a6   # Color
	andi a4,s1,0x01	 # Frame
Loop_PD:	
	beq t2,t4,End_PD
Inner_Loop_PB:	
	beq t1,t3,End_Inner_PD
	beq t0,t5,End_PD
	
	slli a1,t3,3
	add a1,a1,t6   #  x 
	slli a2,t4,3
	add a2,a2,a5   # y
	
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
	
	addi a1, a1, 8

	li a0,73
	li a3,0xC7FF
	#li a4,0           #

	li a7,111
	ecall

	li a0,62
	addi a1,a1,2
	li a3,0xC7FF
	#li a4,0        #
	ecall
End_Next_Symbol:
	mv a0, t5
	ret	

.include "../SYSTEMv21.s"
