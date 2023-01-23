.include "../MACROSv21.s"
.macro image(%imageAddressRegis , %xLower , %yLower, %orientation)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	li a5, %orientation
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
.include "battle/char.data"
.include "battle/charFront.data"
.include "battle/bulFront.data"
.include "battle/bul.data"
.include "battle/squirFront.data"
.include "battle/squir.data"
.include "battle/rat.data"
.include "battle/ratFront.data"
.include "battle/macFront.data"
.include "battle/mac.data"
.include "battle/attackSelec.data"

dialogo: .word 321
.string "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed fringilla metus in accumsan lacinia. Phasellus nec massa mattis, dictum sapien eu, egestas ipsum. Quisque sed ullamcorper quam, ac porta enim. Fusce consequat justo aliquam eros sagittis, id consectetur nulla convallis. Donec lacinia metus vel tortor malesuada"

player_name: .word 12
.string "Nal do Canal"

fight: .word 5
.string "Fight"
pkmn: .word 4
.string "Pkmn"
bag: .word 3
.string "Bag"
run: .word 3
.string "Run"

attack1:
.word 8
.string "attack 1"

attack2:
.word 8
.string "attack 2"

menu_position: .word  0, 0
lines_columns_select: .word  2, 2
states_positions_select: .word	1,182,188, 0,247,188
				2,182,208, 3,247,208
				
lines_columns_battle: .word  2, 1
states_positions_battle: .word	0,12,188, 1,12,208
			
current_menu: .word 0,0,0
menu_state: .word 0

.text

#li t1,0xFF200000
#sw zero,0(t1)	

li s0,0xFF200604
li t0, 1
sw t0,0(s0)

li s1,0xFF000000


Loop: 

la a0, battleBG		# Load map
image(a0, 0, 0, 0)		#

la a0, battleText	# Load map
image(a0, 0, 168, 0)	#

la a0, battleEnemy	# Load map
image(a0, 17, 25, 0)

la a0, battlePlayer	# Load map
image(a0, 168, 113, 0)

la t0,dialogo
li t1, 15
li t2, 182
print_dialog(t0, t1, t2, zero, 35, 5, 0x51FF)

la t0,player_name
li t1, 188
li t2, 121
print_dialog(t0, t1, t2, zero, 35, 5, 0xff00)

la t0,player_name
li t1, 23
li t2, 32
print_dialog(t0, t1, t2, zero, 35, 5, 0xff00)



	#la a0, char		# pkmns
	#la a0, bul
	#la a0, squir
	#la a0, rat
	la a0, mac
	li a5, 0
	image(a0, 55, 114, 0)		#

	#la a0, charFront	# pkmns
	la a0, bulFront
	#la a0, squirFront
	#la a0, ratFront
	#la a0, macFront
	li a5, 0
	image(a0, 211, 47, 0)	#


jal key

####### menu state
li t0, 27
la t1, menu_state
bne a0, t0, not_back
sw zero, 0(t1)
not_back:

la t3, current_menu
lw t2, 0(t1)

bne t2,zero,end_select
li t0, 10
bne a0, t0, end_select
lw t0, 0(t3)
sw t0, 0(t1)


end_select:
#######


la t1, menu_state
lw t0,0(t1)
li t1, 1
beq t0, t1, battle_state
li t1, 2
beq t0, t1, pkmn_state
li t1, 3
beq t0, t1, bag_state

	addi sp,sp, -4
	sw a0,0(sp)

	la a0, battleSelect	# Load map
	image(a0, 160, 168, 0)	#

	lw a0,0(sp)
	addi sp,sp, 4

	la a1, menu_position
	la a2, lines_columns_select
	la a3, states_positions_select
	la a4, current_menu
	jal menu

	lw a1, 4 (a0)
	lw a2, 8 (a0)
	li a0, 42	# eh relativa a cada jogada
	# li a3, 0xc700	#
	li a3, 0xff00
	srli t0, s1, 20
	andi a4, t0, 1 	#
	li a7, 111	#
	ecall 

	la t0,fight
	li t1, 190
	li t2, 188
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

	la t0,run
	li t1, 255
	li t2, 188
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

	la t0,pkmn
	li t1, 190
	li t2, 208
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

	la t0,bag
	li t1, 255
	li t2, 208
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)
j end_state

battle_state:

	addi sp,sp, -4
	sw a0,0(sp)

	la a0, attackSelec	# Load map
	image(a0, 0, 168, 0)	#

	lw a0,0(sp)
	addi sp,sp, 4

	la a1, menu_position
	la a2, lines_columns_battle
	la a3, states_positions_battle
	la a4, current_menu
	jal menu
	
	lw a1, 4 (a0)
	lw a2, 8 (a0)
	li a0, 42	# eh relativa a cada jogada
	# li a3, 0xc700	#
	li a3, 0xff00
	srli t0, s1, 20
	andi a4, t0, 1 	#
	li a7, 111	#
	ecall 

	la t0, attack1
	li t1, 20
	li t2, 188
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

	la t0, attack2
	li t1, 20
	li t2, 208
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)
j end_state

pkmn_state:
	la a0, attackSelec	# Load map
	image(a0, 0, 168, 0)	#
	
	la t0,pkmn
	li t1, 20
	li t2, 198
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

j end_state
bag_state:

	la a0, attackSelec	# Load map
	image(a0, 0, 168, 0)	#
	
	la t0,bag
	li t1, 20
	li t2, 198
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)

end_state:

li a0, 0x07 # color
li a1, 232   # x
li a2, 138    # y
li a3, 100  # percent
li a4, 64   # total length
li a5, 5   # thickness
jal bar

li a0, 0x77 # color
li a1, 68   # x
li a2, 50   # y
li a3, 100
li a4, 64
li a5, 5
jal bar

jal Frame_changer
j Loop

li a7,10
ecall

key:	li t1,0xFF200000		# 
	lb t0,0(t1)			# 
	andi t0,t0,0x0001		# Copiei do exemplo mesmo
   	beq t0,zero,fim  	   	# pode denunciar
  	lw a0,4(t1)  			# 
fim:	ret	

menu:
        mv      a6,a0
        li      t1,115
        lw      a7,0(a1)
        lw      a5,4(a1)
        mv      a0,a4
        beq     a6,t1,M2
        bgtu    a6,t1,M3
        li      a4,97
        beq     a6,a4,M4
        li      a4,100
        bne     a6,a4,M6
        lw      a4,4(a2)
        addi    a7,a7,1
        rem     a7,a7,a4
        sw      a7,0(a1)
M8:
        lw      a4,4(a2)
        mul     a5,a5,a4
        add     a5,a5,a7
        slli    a4,a5,1
        add     a5,a4,a5
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a4,0(a5)
        sw      a4,0(a0)
        lw      a4,4(a5)
        sw      a4,4(a0)
        lw      a5,8(a5)
        sw      a5,8(a0)
        mv a4,a0
        li a0,62	# nota
        li a1,120	# duracao
        li a2,11	# instrumento
        li a3,50	# volume
        li a7,31
        ecall
        mv a0,a4
        ret
M3:
        li      a4,119
        bne     a6,a4,M6
        lw      a4,0(a2)
        add     a6,a4,a5
        addi    a6,a6,-1
        rem     a5,a6,a4
        sw      a5,4(a1)
        j       M8
M6:
        lw      a4,4(a2)
        mul     a5,a5,a4
        add     a5,a5,a7
        slli    a4,a5,1
        add     a5,a4,a5
        slli    a5,a5,2
        add     a5,a3,a5
        lw      a4,0(a5)
        sw      a4,0(a0)
        lw      a4,4(a5)
        sw      a4,4(a0)
        lw      a5,8(a5)
        sw      a5,8(a0)
        ret
M2:
        lw      a4,0(a2)
        addi    a5,a5,1
        rem     a5,a5,a4
        sw      a5,4(a1)
        j       M8
M4:
        lw      a4,4(a2)
        add     a7,a4,a7
        addi    a7,a7,-1
        rem     a7,a7,a4
        sw      a7,0(a1)
        j       M8

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
