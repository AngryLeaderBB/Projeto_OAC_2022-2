.include "../MACROSv21.s"

.macro faster_rectangle(%color , %xLower , %yLower, %xUpper, %yUpper)
	#address is the address of the bitmap display

	mv a0,s1
	li a1,%color

	li a2,%xLower
	li a3,%yLower

	li a4,%xUpper
	li a5,%yUpper

	jal ra,FASTER_RECTANGLE

.end_macro

.macro image(%imageAddressRegis , %xLower , %yLower)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	jal ra,Image

.end_macro

.macro iterate_animation(%imageAddressRegis , %xLower , %yLower)
	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	jal ra,Animation_Iterator
.end_macro


.data

.include "bat-fly_20x48.data"
player_position: .word 100,100
imagem: .word 0,0,0

.text

	la s0,player_position
	li s1,0xFF100000
	la s2,imagem

	la t0,bat_fly1
	sw t0,0(s2)
	sw zero,4(s2)
	sw t0,8(s2)

LOOP0:
	faster_rectangle(0, 0, 0, 320, 240)
	mv a0,s2
	jal Input_Player

	mv a0,s2
	lw a1,0(s0)
	lw a2,4(s0)
	jal Animation_Iterator
	jal Frame_changer

j LOOP0

li a7,10
ecall

Frame_changer:
	li t0,0x00100000
	xor s1,s1,t0
	li t0,0xFF200604
	lw t1,0(t0)
	xori t1,t1,0x01
	sw t1,0(t0)
	ret 

KEY:	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se não há tecla pressionada então vai para FIM
  	lw a0,4(t1)  			# le o valor da tecla tecla
	sw a0,12(t1)  			# escreve a tecla pressionada no display
FIM:	ret	

Input_Player:
	# a0 = player animation
	mv a1,a0 
	
	addi sp,sp,-4
	sw ra,0(sp)
	jal KEY
	
	mv a3,s0
	
	li t0,97 # a
	bne a0,t0,Next_Input1
	li a2,1
	#addi a3,a3,4
	li a4,-16
	jal Move_Bat_Command
	
Next_Input1:
	li t0,100 # d
	bne a0,t0,Next_Input2
	li a2,0
	#addi a3,a3,4
	li a4,16
	jal Move_Bat_Command
	
Next_Input2:
	li t0,115 # s 
	bne a0,t0,Next_Input3
	li a2,-1
	addi a3,a3,4
	li a4,16
	jal Move_Bat_Command
	
Next_Input3:
	li t0,119 # w
	li a2,-1
	addi a3,a3,4
	li a4,-16
	bne a0,t0,Next_Input4
	jal Move_Bat_Command
Next_Input4:	
	jal End_IP
Move_Bat_Command:	
	jal Move_Bat

End_IP:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret



Move_Bat:
	li t0,-1
	beq a2,t0,Same_Direction
	sw a2,4(a1)
Same_Direction:
	lw t0,0(a3)
	add t0,t0,a4
	sw t0,0(a3)

	jal End_IP

Move_Bat_Backward:
	li t0,1
	sw t0,4(a1)

	la t0,player_position
	lw t1,0(t0)
	addi t1,t1,-8
	sw t1,0(t0)
	
	j End_IP

Move_Bat_Foward:
	sw zero,4(a1)
	la t0,player_position
	lw t1,0(t0)
	addi t1,t1,8
	sw t1,0(t0)
	
	j End_IP



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
	

Image: 
	# a5 = orientation (0  right, 1 left)
	lw t0,0(a0)
	add a3,a1,t0
	
	lw t1,4(a0)
	add a4,a2,t1
	
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
	#addi a0,a0,1
	j Loop_I1
END_I:
	ret

Animation_Iterator:
	# a0 = pointer to the animation section (pointer to the images), a1 = x, a2 = y
	lw t0,0(a0) # endereco das imagens
	
	lw t1,0(t0)
	lw t2,4(t0)
	bne t1,t2,Dont_Restart_Loop
	bne t1,zero,Dont_Restart_Loop
	lw t0,8(a0)
	sw t0,0(a0)

Dont_Restart_Loop:

	addi sp,sp,-8
	sw a0,4(sp)
	sw ra,0(sp)

	lw a5,4(a0)
	mv a0,t0
	jal ra,Image
	lw ra,0(sp)
	lw a0,4(sp)
	
	addi sp,sp,8
	
	lw t0,0(a0)
	lw t1,4(t0)
	lw t2,0(t0)
	mul t1,t1,t2
	li t3,4
	rem t2,t1,t3
	beq t2,zero,Correct_Val
	sub t2,t3,t2
Correct_Val:
		
	add t1,t1,t0
	addi t1,t1,8
	add t1,t1,t2
	sw t1,0(a0)
	
	ret

	
.include "../SYSTEMv21.s"
