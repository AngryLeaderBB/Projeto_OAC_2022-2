.macro rectangle(%color , %xLower , %yLower, %xUpper, %yUpper)
	#address is the address of the bitmap display

	mv a0,s1
	li a1,%color

	li a2,%xLower
	li a3,%yLower

	li a4,%xUpper
	li a5,%yUpper

	jal ra,RECTANGLE

.end_macro

.macro image(%imageAddressRegis , %xLower , %yLower)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	jal ra,Image

.end_macro

.data
.include "lifebar.data"
#.include "idle.data"
vida: .word 100


.text

li s1,0xFF000000

rectangle(-1,0,0,320,240)
la t0,lifebar
li a0,100
jal PrintLifeBar


la t0,lifebar
image(t0, 0 , 0)

li a7,10
ecall

PrintLifeBar:
	# a0 = life
	
	addi sp,sp,-4
	sw ra,0(sp)
	
	mv a4,a0
	addi a4,a4,10
	
	mv a0,s1
	li a1,0x07

	li a2,10
	li a3,10

	li a5,20

	jal ra,RECTANGLE
	
	lw ra,0(sp)
	addi sp,sp,4
	
	ret
	
	
RECTANGLE: 
	
	mv t0,a2
	mv t1,a3
	li t2,320
	mul t2,t1,t2
	add t2,t2,t0
	add t2,a0,t2
	
LOOP1:
	beq t1,a5, END1
INNER_LOOP1:	
	beq t0,a4, END_INNER1
	
	sb a1,0(t2)
	

	addi t2,t2,1
	addi t0,t0,1
	j INNER_LOOP1
END_INNER1:
	add t2,t2,a2
	sub t2,t2,a4
	addi t2,t2,320
	mv t0,a2
	addi t1,t1,1
	j LOOP1
END1:
	ret

Image: 

	lw t0,0(a0)
	add a3,a1,t0
	
	lw t1,4(a0)
	add a4,a2,t1
	
	addi a0,a0,8
	
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

	addi t2,t2,1
	addi t0,t0,1
	addi a0,a0,1
	j INNER_Loop_I1
END_Inner_I:

	add t2,t2,a1
	sub t2,t2,a3
	addi t2,t2,320
	mv t0,a1
	addi t1,t1,1

	j Loop_I1
END_I:
	ret
