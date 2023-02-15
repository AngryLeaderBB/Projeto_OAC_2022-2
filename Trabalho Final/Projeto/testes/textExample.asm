.include "../MACROSv21.s"
.macro image(%imageAddressRegis , %xLower , %yLower, %orientation)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	li a5, %orientation
	call ra,Image

.end_macro

.macro print_dialog(%address, %x, %y, %written, %letters, %lines, %color)

	mv a0, %address,
	mv a1, %x,
	mv a2, %y
	mv a3, %written
	li a4, %letters
	li a5, %lines
	li a6, %color
	call PrintDialog

.end_macro

.data 

.include "battle/battleText.data"
dialogo: .word 321
.string "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed fringilla metus in accumsan lacinia. Phasellus nec massa mattis, dictum sapien eu, egestas ipsum. Quisque sed ullamcorper quam, ac porta enim. Fusce consequat justo aliquam eros sagittis, id consectetur nulla convallis. Donec lacinia metus vel tortor malesuada"

dialogo_inicial: .word 126
.string "Voce magicamente brota numa sala suspeita\n\n\n\n-Voce\n Oh nao eu vou perder a aula de OAC, eh melhor eu descobrir como sair daqui"

dialogo_interacao: .word 273
.string "-Voce\n\n3 esferas, cada uma com uma ex-fera. Humm.........\n\nVoce escolheu seu pkmn (por favor nao nos processa ntndo).TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT-Voce\nUe, soh era um?"

current_min_text: .word 0

.text

li s0,0xFF200604
li t0, 1
sw t0,0(s0)
li s1,0xFF000000

la a0,dialogo_interacao
call Dialog_stop


la a0,dialogo
call Dialog_stop

li a7,10
ecall


#############################################

Dialog_stop:
# a0 = dialog address
addi sp,sp,-12
sw ra,0(sp)
sw zero,4(sp)
sw a0,8(sp)

Loop_DS:

la a0, battleText	# Load map
image(a0, 0, 168, 0)	#

#la t0, current_min_text
lw t3,4(sp)

lw t0,8(sp)
li t1, 15
li t2, 182
print_dialog(t0, t1, t2, t3, 35, 5, 0x51FF)


mv t2,a0

#li a1,0
#li a2,0
#li a3,0xff
#li a4,0
#li a7,101
#ecall

call key

li t1, 10
bne a0,t1, End_If_DS
	#la t0, current_min_text
	beq t2,zero,end_Loop_DS
	sw t2,4(sp)


End_If_DS:

call Frame_changer

j Loop_DS
end_Loop_DS:

lw ra,0(sp)
addi sp,sp,12

ret


Frame_changer:
	li t0,0x00100000
	xor s1,s1,t0
	li t0,0xFF200604
	lw t1,0(t0)
	xori t1,t1,0x01
	sw t1,0(t0)
	ret

Image: 
	# a5 = orientation (0  right, 1 left)
	lw t0,0(a0)
	add a3,a1,t0
	
	lw t1,4(a0)
	add a4,a2,t1
	
	neg  t0,t0	# t6 = t0 % 4
        andi t6,t0,3	#
	
	addi a0,a0,8
	
	li t5, 1
	beq a5,zero,Right_Orientation
	mv t2,a1
	mv a1,a3
	mv a3,t2
	addi t5,t5,-2
Right_Orientation:
	
	mv t0,a1
	mv t1,a2
	li t2,320
	mul t2,t1,t2
	add t2,t2,t0
	add t2,s1,t2

	li t4,-57
Loop_I1:
	beq t1,a4, END_I
INNER_Loop_I1:	
	beq t0,a3, END_Inner_I
	lb t3,0(a0)
	beq t3,t4,Transparent
	sb t3,0(t2)
Transparent:

	add t2,t2,t5
	add t0,t0,t5
	addi a0,a0,1
	j INNER_Loop_I1
END_Inner_I:

	add t2,t2,a1
	sub t2,t2,a3
	addi t2,t2,320
	mv t0,a1
	addi t1,t1,1
	add a0,a0,t6	#
	j Loop_I1
END_I:
	ret
	
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
	
	srai a4,s1,20
	andi a4,a4,1
	#ori a4,s1,-2	 # Frame
	#neg a4,a4
Loop_PD:	
	beq t2,t4,End_PD
Inner_Loop_PB:	
	beq t1,t3,End_Inner_PD
	beq t0,t5,End_PD
	
	slli a1,t3,3
	add a1,a1,t6   #  x 
	slli a2,t4,3
	add a2,a2,a5   # y
	
	addi sp,sp,-8
	sw a0,0(sp)
	sw s0,4(sp)

	lb a0,0(a0)
	li s0,10
	bne a0,s0,not_new_line
	
	mv t3,t1
	addi t3,t3,-1
		
not_new_line:	ecall	
	
	lw a0,0(sp)
	lw s0,4(sp)
	addi sp,sp,8
	
	addi t3,t3,1
	addi t5,t5,1
	addi a0,a0,1
	j Inner_Loop_PB
End_Inner_PD:

	li t3,0
	addi t4,t4,1
	j Loop_PD
End_PD:	

	lb t2,-1(a0)
	addi t2,t2,-10
	
	beq t2,zero,End_Next_Symbol
		
	slt t1,t5,t0
	beq t1,zero,End_Next_Symbol
	
	addi a1, a1, 8

	li a0,73
	li a3,0xC7FF
	
	#srai a4,s1,20
	#andi a4,a4,1
	#li a4,0           #

	li a7,111
	ecall

	li a0,62
	addi a1,a1,2
	li a3,0xC7FF
	#li a4,0        #
	ecall
End_Next_Symbol:
	beq t5,t0,If_PD
	mv a0, t5
	ret
If_PD:	li a0,0
	ret

key:	li t1,0xFF200000		# 
	lb t0,0(t1)			# 
	andi t0,t0,0x0001		# Copiei do exemplo mesmo
   	beq t0,zero,fim  	   	# pode denunciar
  	lw a0,4(t1)  			# 
fim:	ret
	
.include "../SYSTEMv21.s"
