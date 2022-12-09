.include "../MACROSv21.s"
.macro image(%imageAddressRegis , %xLower , %yLower)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	jal ra,Image

.end_macro

.macro print_regis(%regis,%is_hexa)
	sw a0,-4(sp)
	sw t0,-8(sp)
	li a7,1
	li t0,%is_hexa
	beq t0,zero,Dec
	addi a7,a7,33
Dec:
	lw t0,-8(sp)
	mv a0,%regis
	ecall
	li a0,10
	li a7,11
	ecall
	lw a0,-4(sp)
	
.end_macro

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

.include "battle/battleBG.data"
.include "battle/battleText.data"
.include "battle/battleSelect.data"
.include "battle/battlePlayer.data"
.include "battle/battleEnemy.data"
dialogo: .word 321
.string "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed fringilla metus in accumsan lacinia. Phasellus nec massa mattis, dictum sapien eu, egestas ipsum. Quisque sed ullamcorper quam, ac porta enim. Fusce consequat justo aliquam eros sagittis, id consectetur nulla convallis. Donec lacinia metus vel tortor malesuada"

player_name: .word 12
.string "Nal do Canal"

fight: .word 5
.string "Fight"

.text

li s0,0xFF200604
li t0, 1
sw t0,0(s0)

li s1,0xFF100000


la a0, battleBG		# Load map
image(a0, 0, 0)		#

la a0, battleText	# Load map
image(a0, 0, 168)	#

la a0, battleEnemy	# Load map
image(a0, 17, 25)

la a0, battlePlayer	# Load map
image(a0, 168, 113)

la t0,dialogo
li t1, 15
li t2, 182
print_dialog(t0, t1, t2, zero, 35, 5, 0xC7FF)

la t0,player_name
li t1, 188
li t2, 121
print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

la t0,player_name
li t1, 23
li t2, 32
print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

la a0, battleSelect	# Load map
image(a0, 160, 168)	#

la t0,fight
li t1, 190
li t2, 188
print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

la t0,fight
li t1, 255
li t2, 188
print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

la t0,fight
li t1, 190
li t2, 208
print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

la t0,fight
li t1, 255
li t2, 208
print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)


li a0, 0x77 # color
li a1, 232   # x
li a2, 138    # y
li a3, 100
li a4, 64
li a5, 5
jal bar

li a0, 0x77 # color
li a1, 68   # x
li a2, 50   # y
li a3, 100
li a4, 64
li a5, 5
jal bar

Loop: j Loop

li a7,10
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

#############################

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
	ori a4,s1,-2	 # Frame
	neg a4,a4
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
	
	
#################### bar

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
        
.include "../SYSTEMv21.s"
