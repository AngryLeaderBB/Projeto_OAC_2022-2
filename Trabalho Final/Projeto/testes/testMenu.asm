.include "../MACROSv21.s"
.macro rectangle(%color, %x_lower, %y_lower, %x_upper, %y_upper)

	li a0, %color
	li a1, %x_lower
	li a2, %y_lower
	li a3, %x_upper
	li a4, %y_upper
	jal rectangle

.end_macro

.macro image(%imageAddressRegis , %xLower , %yLower, %orientation)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	li a5, %orientation
	jal ra,Image

.end_macro

.data
.include "battle/battleText.data"
.include "battle/mac.data"

menu_position: .word  0, 0
lines_columns: .word  2, 2
states_positions: .word	0,152,112, 1,168,112,
			2,152,128, 3,168,128
			
current_menu: .word 0,0,0

.text

li s1,0xFF100000	# Initialize 

loop:

rectangle(0xff, 0, 0, 320, 240)

jal key
li a7,1
ecall
li t0,10
beq a0, t0, end_loop
la a1, menu_position
la a2, lines_columns
la a3, states_positions
la a4, current_menu
jal menu

lw a1, 4 (a0)
lw a2, 8 (a0)

li a0, 42	# eh relativa a cada jogada
li a3, 0xff00	#
srli t0, s1, 20
andi a4, t0, 1 	#

li a7, 111	#
ecall 


la a0, battleText	# Load map
image(a0, 0, 168, 0)	#


la a0, mac
li a5, 0
image(a0, 55, 114, 0)		#

jal Frame_changer
j loop

end_loop:

la t0, current_menu
lw a0, 0(t0)

li a7,1
ecall

li a7, 10
ecall

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
	
Frame_changer:
	li t0,0x00100000
	xor s1,s1,t0
	li t0,0xFF200604
	lw t1,0(t0)
	xori t1,t1,0x01
	sw t1,0(t0)
	ret

menu:
        li      t1,115
        lw      a7,0(a1)
        lw      a5,4(a1)
        beq     a0,t1,.L2
        bgtu    a0,t1,.L3
        li      t1,97
        beq     a0,t1,.L4
        li      t1,100
        bne     a0,t1,.L6
        lw      a0,4(a2)
        addi    a7,a7,1
        rem     a7,a7,a0
        sw      a7,0(a1)
.L6:
        lw      a2,4(a2)
        mv      a0,a4
        mul     a5,a5,a2
        add     a5,a5,a7
        slli    a2,a5,1
        add     a5,a2,a5
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a3,0(a5)
        sw      a3,0(a4)
        lw      a3,4(a5)
        sw      a3,4(a4)
        lw      a5,8(a5)
        sw      a5,8(a4)
        ret
.L3:
        li      t1,119
        bne     a0,t1,.L6
        lw      a0,0(a2)
        add     a6,a0,a5
        addi    a6,a6,-1
        rem     a5,a6,a0
        sw      a5,4(a1)
        j       .L6
.L2:
        lw      a0,0(a2)
        addi    a5,a5,1
        rem     a5,a5,a0
        sw      a5,4(a1)
        j       .L6
.L4:
        lw      a0,4(a2)
        add     a7,a0,a7
        addi    a7,a7,-1
        rem     a7,a7,a0
        sw      a7,0(a1)
        j       .L6

rectangle:			## 	
        bgt     a1,a3,.L10	##	   
        bgt     a2,a4,.L10	##
        slli    a5,a2,2		## void rectangle(int color, int x_lower,
        addi    a7,a4,1		##  int y_lower, int x_upper, int y_upper){
        mv      t1,s1
        #li      t1,-16777216	##
        add     a2,a5,a2	##    unsigned char *Frame, *aux;
        slli    a2,a2,6		##    Frame = (unsigned char *) VGA_ADDRESS;
        addi    a4,t1,1		##
        slli    a6,a7,2		##    for (int i = x_lower; i <= x_upper; i++){
        add     a4,a2,a4	##         for (int j = y_lower; j <= y_upper; j++){
        add     a6,a6,a7	##             aux = Frame + (i + j*320);
        add     a4,a4,a3	## 	        *aux = color;
        slli    a6,a6,6		##        }
        add     a3,a1,t1	##     }
.L15:				## }
        add     a5,a3,a2	##
.L13:				##
        sb      a0,0(a5)	##
        addi    a5,a5,1		##
        bne     a5,a4,.L13	##
        addi    a2,a2,320	##
        addi    a4,a4,320	##
        bne     a2,a6,.L15	##
.L10:				##
        ret			##
        
key:	li t1,0xFF200000		# 
	lw t0,0(t1)			# 
	andi t0,t0,0x0001		# Copiei do exemplo mesmo
   	beq t0,zero,fim  	   	# pode denunciar
  	lw a0,4(t1)  			# 
	sw a0,12(t1)  			# 
fim:	ret	

.include "../SYSTEMv21.s"
