.include "../MACROSv21.s"
.macro image(%imageAddressRegis , %xLower , %yLower, %orientation)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	li a5, %orientation
	call,Image

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
	call PrintDialog

.end_macro



.data

.include "battle/battleBG.data"
.include "battle/battleText.data"
.include "battle/battleSelect.data"
.include "battle/battlePlayer.data"
.include "battle/battleEnemy.data"
.include "battle/pkmns.data"
.include "battle/attackSelec.data"

atacou: .word 21
.string "Seu ataque foi de:\n\n\n"

recebeu: .word 24
.string "Voce recebeu de dano:\n\n\n"

ganhou: .word 28
.string "\n\n             Voce ganhou!\n"

perdeu: .word 32
.string "\n\n    Mais sorte na proxima vez\n"

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

player_pkmns: .word 4
pkmns_array:

.word 0  # current_pkmn, if don't -1
.float 100 # level
.word 10, 50, 10 # level, stats attack, stats defense 

.word 1  # is_active?, current_pkmn
.float 90 # level
.word 9, 50, 10 # level, stats attack, stats defense 

.word 2  # is_active?, current_pkmn
.float 80 # level
.word 8, 50, 10 # level, stats attack, stats defense 

.word 3  # is_active?, current_pkmn
.float 70 # level
.word 7, 50, 10 # level, stats attack, stats defense 

#.word 4  # is_active?, current_pkmn
#.float 60 # level
#.word 6, 50, 10 # level, stats attack, stats defense 

enemy_pkmns: .word 2
enemy_array:

.word 3  # current_pkmn, if don't -1
.float 100 # level
.word 10, 50, 10 # level, stats attack, stats defense 

.word 4  # is_active?, current_pkmn
.float 90 # level
.word 9, 50, 10 # level, stats attack, stats defense 

.word -1  # is_active?, current_pkmn
.float 80 # level
.word 8, 50, 10 # level, stats attack, stats defense 

.word -1  # is_active?, current_pkmn
.float 70 # level
.word 7, 50, 10 # level, stats attack, stats defense 


pkmns_names:
.byte 10  
.string "Charmander"
.byte 8
.string "Squirtle"
.byte 9
.string "Bulbasaur"
.byte 6
.string "Machop"
.byte 6
.string "Ratata"

# ataques 

attack_section:
.byte 7
.string "Scratch"
.byte 0, 40

.byte 5
.string "Ember" 
.byte 1, 40

.byte 6
.string "Tackle"
.byte 0, 40

.byte 9 
.string "Vine Whip"
.byte 3, 45

.byte 9
.string "Water Gun"
.byte 2, 40

.byte 4
.string "Bite"
.byte 5, 45

.byte 7 
.string "Revenge"
.byte 4, 45

.byte 9
.string "Knock Off"
.byte 0, 45

player_attacks:
.byte 0,1,2,4,2,3,6,7,2,5


pkmns_front:
.word 0,0,0,0,0
pkmns_back:
.word 0,0,0,0,0

########## menu
menu_position: .word  0, 0
lines_columns_select: .word  2, 2
states_positions_select: .word	1,182,188, 0,247,188
				2,182,208, 3,247,208
				
lines_columns_battle: .word  2, 1
states_positions_battle: .word	4,12,188, 5,12,208

lines_columns_pkmns: .word 2,2
states_positions_pkmns: .word 	6,40,188, 7,92,188
			      	8,40,208, 9,92,208			
																		
current_menu: .word 0,0,0
menu_state: .word 0

############## pkmns

current_player_pkmn: .word 0
life_player: .float 100
level: .word 10
stats: .word 50,10
player_pkmn_index: .word 0

current_enemy_pkmn: .word 3
life_enemy: .float 100
enemy_level: .word 10
enemy_stats: .word 10,20
enemy_pkmn_index: .word 0

#### consts

.LC0:
        .word   1084227584
.LC1:
        .word   1073741824
.LC2:
        .word   1112014848
        
# normal : 0, fire : 1, water : 2, grass : 3, fighting : a4, dark : 5 

types_matrix: .float
1.0, 1.0, 1.0, 1.0, 1.0, 1.0
1.0, 0.5, 0.5, 2.0, 1.0, 1.0
1.0, 2.0, 0.5, 0.5, 1.0, 1.0
1.0, 0.5, 2.0, 0.5, 1.0, 1.0
2.0, 1.0, 1.0, 1.0, 1.0, 2.0
1.0, 1.0, 1.0, 1.0, 0.5, 0.5

.text

#li t1,0xFF200000
#sw zero,0(t1)	

li s0,0xFF200604	#
li t0, 1		# inicializa
sw t0,0(s0)		#

li s1,0xFF000000 # inicializa frame

################


la t0,pkmns_back
la t1,char
sw t1,0(t0)
la t2,squir
sw t2,4(t0)
la t1,bul
sw t1,8(t0)
la t2,mac
sw t2,12(t0)
la t1,rat
sw t1,16(t0)

la t0,pkmns_front
la t1,charFront
sw t1,0(t0)
la t2,squirFront
sw t2,4(t0)
la t1,bulFront
sw t1,8(t0)
la t2,macFront
sw t2,12(t0)
la t1,ratFront
sw t1,16(t0)




######################## main loop

call Battle

li a7,1
ecall

li a7,10
ecall


####################
Battle:

addi sp,sp,-4
sw ra,0(sp)

# adicionar inicialiazacao
# 
   
Player_Loop:

call refresh_battle_screen

call key

####### menu state
li t0, 27
la t1, menu_state
bne a0, t0, not_back
sw zero, 0(t1)
not_back:

la t3, current_menu
#lw t2, 0(t1)

#bne t2,zero,end_select
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
li t1,4
beq t0, t1, attack_state
li t1,5
beq t0, t1, attack_state

slt t2,t1,t0
li t1,11
slt t3,t0,t1
and t1,t2,t3
addi t1,t1,-1
beq zero,t1, pkmn_select_state

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
	call menu

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
	call menu
	
	lw a1, 4 (a0)
	lw a2, 8 (a0)
	li a0, 42	# eh relativa a cada jogada
	# li a3, 0xc700	#
	li a3, 0xff00
	srli t0, s1, 20
	andi a4, t0, 1 	#
	li a7, 111	#
	ecall 


	######################## bug here!!!!!!!!!!!!
	la t0,current_player_pkmn
	lw t1,0(t0)
	slli t1,t1,1 
	la t0,player_attacks
	add t0,t0,t1
	lb a1,0(t0)
	la a0,attack_section
	call select_battle_section
	
	addi a0,a0,1
	li a1,20
	li a2,188
	li a3,0xC700
	srai a4,s1,20
	andi a4,a4,1
	li a7,104
	ecall

	la t0,current_player_pkmn
	lw t1,0(t0)
	slli t1,t1,1 
	la t0,player_attacks
	add t0,t0,t1
	lb a1,1(t0)
	la a0,attack_section
	call select_battle_section
	addi a0,a0,1
	li a1,20
	li a2,208
	li a3,0xC700
	srai a4,s1,20
	andi a4,a4,1
	li a7,104
	ecall

j end_state

pkmn_state:

	addi sp,sp, -4
	sw a0,0(sp)

	la a0, attackSelec	# Load map
	image(a0, 0, 168, 0)	#

	lw a0,0(sp)
	addi sp,sp, 4
	
	call pkmn_select_menu
	
j end_state
bag_state:

	la a0, attackSelec	# Load map
	image(a0, 0, 168, 0)	#
	
	la t0,bag
	li t1, 20
	li t2, 198
	print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)
	
	j end_state

pkmn_select_state:

	addi t0,t0,-6
	mv t6,t0
	li t1,20
	mul t0,t0,t1
	
	la t2,menu_state
	sw zero,0(t2)
	
	la t2,pkmns_array
	add t0,t2,t0
	
	lw t1,0(t0)
	
	blt t1,zero,end_state
	
	lw t2,4(t0)
	lw t3,8(t0)
	lw t4,12(t0)
	lw t5,16(t0)
	
	la t0,current_player_pkmn
	
	sw t1,0(t0)
	sw t2,4(t0)
	sw t3,8(t0)
	sw t4,12(t0)
	sw t5,16(t0)
	sw t6,20(t0)
	#li a7,10
	#ecall
	
	#j end_state	
	call refresh_battle_screen
	call Frame_changer
	call refresh_battle_screen	
	
	j Enemy_turn

attack_state:
	
	#player_attacks:
	#.byte 0,1,2,4,2,3,6,7,2,5
	
	li t3,4
	sub t3,t0,t3
		
	la t0,current_player_pkmn
	lw t1,0(t0)
	slli t2,t1,1
	add t2,t2,t3
	
	la t0, player_attacks
	add t2,t0,t2
	lb a0,0(t2)
	
	la a1, level
	la a2, stats
	la a3, enemy_stats
	la t0,current_enemy_pkmn
	lw a4,0(t0)
	addi a4,a4,1
	call attack
	
	la t0,life_enemy
	flw ft1,0(t0)
	fsub.s ft1,ft1,fa0
	fsw ft1,0(t0)
	
	la t0,menu_state
	sw zero,0(t0)
	
	la a0,atacou
	fcvt.w.s a1,fa0
	call Dialog_stop
	
		
	fmv.s.x ft0,zero
	fle.s t0,ft1,ft0
	beq t0,zero,Enemy_turn
	
	la t0, enemy_array
	la t1, enemy_pkmn_index
	lw t1,0(t1)
	li t2,20
	mul t1,t1,t2
	add t0,t0,t1
	
	lw t1,0(t0)
	addi t1,t1,-5	# correct this funct
	sw t1,0(t0)
	
	
	la t1, enemy_pkmns
	lw t2,0(t1)
	addi t2,t2,-1
	sw t2,0(t1)
	
	bne t2,zero,dont_win
	la a0,ganhou
	li a1,0
	call Dialog_stop
	li a0,0
	j End_battle
dont_win:

	la t1, enemy_pkmn_index
	lw t0,0(t1)
	addi t0,t0,1
	
	mv t6,t0
	li t1,20
	mul t0,t0,t1
	
	la t2,enemy_array
	add t0,t2,t0
	
	# may cause bug
	lw t1,0(t0)
	#blt t1,zero,loop_pkmn_select
	
	lw t2,4(t0)
	lw t3,8(t0)
	lw t4,12(t0)
	lw t5,16(t0)
	
	la t0,current_enemy_pkmn
	
	sw t1,0(t0)
	sw t2,4(t0)
	sw t3,8(t0)
	sw t4,12(t0)
	sw t5,16(t0)
	sw t6,20(t0)	
											
	j Enemy_turn

end_state:

call print_lifes
call Frame_changer

j Player_Loop

Enemy_turn:
	
	li a0,2
	li a7,41
	ecall	
	andi t3,a0,1
	la t0,current_enemy_pkmn
	lw t1,0(t0)
	slli t2,t1,1
	add t2,t2,t3
	
	la t0, player_attacks
	add t2,t0,t2
	lb a0,0(t2)

	la a1, enemy_level
	la a2, enemy_stats
	la a3, stats
	la t0,current_player_pkmn
	lw a4,0(t0)
	addi a4,a4,1
	call attack
	
	la t0,life_player
	flw ft1,0(t0)
	fsub.s ft1,ft1,fa0
	fsw ft1,0(t0)

	la a0,recebeu
	fcvt.w.s a1,fa0
	call Dialog_stop
	
	fmv.s.x ft0,zero
	fle.s t0,ft1,ft0
	beq t0,zero,Player_Loop
	
	la t0, pkmns_array
	la t1, player_pkmn_index
	lw t1,0(t1)
	li t2,20
	mul t1,t1,t2
	add t0,t0,t1
	
	lw t1,0(t0)
	addi t1,t1,-5	# correct this funct
	sw t1,0(t0)
	
	la t1, player_pkmns
	lw t2,0(t1)
	addi t2,t2,-1
	sw t2,0(t1)
	
	bne t2,zero,dont_lose
	la a0,perdeu
	li a1,0
	call Dialog_stop
	li a0,1
	j End_battle
dont_lose:
	li a0,0
			
loop_pkmn_select:	
	call key
	li t0,10
	beq t0,a0,end_pkmn_select
	call pkmn_select_menu
	call Frame_changer

	j loop_pkmn_select
	
end_pkmn_select:
	
	la t0,current_menu
	lw a0,0(t0)	
	
	addi t0,a0,-6
	mv t6,t0
	li t1,20
	mul t0,t0,t1
	
	la t2,menu_state
	sw zero,0(t2)
	
	la t2,pkmns_array
	add t0,t2,t0
	
	lw t1,0(t0)
	
	blt t1,zero,loop_pkmn_select
	
	lw t2,4(t0)
	lw t3,8(t0)
	lw t4,12(t0)
	lw t5,16(t0)
	
	la t0,current_player_pkmn
	
	sw t1,0(t0)
	sw t2,4(t0)
	sw t3,8(t0)
	sw t4,12(t0)
	sw t5,16(t0)
	sw t6,20(t0)	

	#li a7,10
	#ecall
	
	j Player_Loop
#j Loop

End_battle:

lw ra,0(sp)
addi sp,sp,4

la t0,pkmns_array
li t1,0
li t2,4

recover_vals:
beq t1,t2,end_recover_vals
lw t3,0(t0)
li t4,-1
bge t3,t4,valid_val
addi t3,t3,5
sw t3,0(t0)
valid_val:
addi t0,t0,20
addi t1,t1,1
j recover_vals
end_recover_vals:

ret 

print_lifes:

addi sp,sp,-4
sw ra,0(sp)

############# player life
li a0, 0x07 # color
li a1, 232   # x
li a2, 138    # y

la t0, life_player
flw ft0,0(t0)
fcvt.w.s a3,ft0

#li a3, 100  # percent
li a4, 64   # total length
li a5, 5   # thickness
call bar


############# enemy life

li a0, 0x77 # color
li a1, 68   # x
li a2, 50   # y

la t0, life_enemy
flw ft0,0(t0)
fcvt.w.s a3,ft0

#li a3, 100
li a4, 64
li a5, 5
call bar

lw ra,0(sp)
addi sp,sp,4	

ret			

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
	
#################### bar

bar:
        mul     a3,a3,a4
        li      a7,100
        div     a3,a3,a7
        add     a7,a3,a1
        bge     a1,a7,.L1
        add     a5,a2,a5
        bge     a2,a5,.L1
        slli    a4,a5,2
        add     a4,a4,a5
        slli    a5,a2,2
        slli    a4,a4,6
        add     a2,a5,a2
        add     a4,a4,s1
        slli    a2,a2,6
        add     a4,a4,a1
        add     a2,a2,s1
        andi    a3,a0,0xff
.L6:
        add     a5,a1,a2
.L4:
        sb      a3,0(a5)
        addi    a5,a5,320
        bne     a4,a5,.L4
        addi    a1,a1,1
        addi    a4,a4,1
        bne     a1,a7,.L6
.L1:
        ret

        
select_battle_section:
        ble     a1,zero,.L2
        li      a4,0
.L3:
        lbu     a5,0(a0)
        addi    a4,a4,1
        addi    a5,a5,4
        add     a0,a0,a5
        bne     a1,a4,.L3
.L2:
	lbu     a5,0(a0)
        addi    a5,a5,2
        add     a1,a0,a5

        ret

damage:
        lw      a5,0(a1)
        #lui     a4,%hi(.LC0)
        #flw     fa3,%lo(.LC0)(a4)
        la a4,.LC0
        flw fa3,0(a4)
        
        fcvt.s.w        fa5,a5
        #lui     a5,%hi(.LC1)
        #flw     fa4,%lo(.LC1)(a5)
        la a5,.LC1
        flw fa4,0(a5)
        
        fadd.s  fa5,fa5,fa5
        lw      a5,0(a2)
        fcvt.s.w        fa2,a0
        fcvt.s.w        fa1,a5
        fdiv.s  fa5,fa5,fa3
        lw      a5,4(a3)
        fcvt.s.w        fa3,a5
        #lui     a5,%hi(.LC2)
        la a5,.LC2
        
        fadd.s  fa5,fa5,fa4
        fmul.s  fa5,fa5,fa1
        fmul.s  fa5,fa5,fa2
        fdiv.s  fa5,fa5,fa3
        #flw     fa3,%lo(.LC2)(a5)
        flw fa3,0(a5)
        fdiv.s  fa5,fa5,fa3
        fadd.s  fa5,fa5,fa4
        fmul.s  fa0,fa5,fa0
        ret



##################################

attack:
# a0 = attack number, a1 = address attacker level,
# a2 = address attacker stats, a3 = address defender stats 
# a4 = pkmn type

addi sp,sp,-20
sw ra,0(sp)
sw a1,4(sp)
sw a2,8(sp)
sw a3,12(sp)
sw a4,16(sp)


mv a1,a0

la a0, attack_section 
#li a1,1	# attack number
jal select_battle_section

lb a3,1(a1)	# attack base damage
lb a1,0(a1)	# attack type

#mv a0,a1
#li a7,1
#ecall

#li a0,10
#li a7,11
#ecall

la a0, types_matrix
##li a1, 4		# attack type ~ i
#la a2,enemy_type	# deffense type ~ j
lw a2,16(sp)

jal access_matrix

#li a7, 2
#ecall

# fa0 damage, a3 base damage, 

mv a0, a3
lw a1,4(sp)
lw a2,8(sp)
lw a3,12(sp)
jal damage


lw ra,0(sp)
addi sp,sp,20

ret            

access_matrix:
	# a0 = address, a1 = x, a2 = y
        slli    a5,a1,1
        add     a1,a5,a1
        slli    a1,a1,3
        add     a0,a0,a1
        slli    a2,a2,2
        add     a0,a0,a2
        flw     fa0,0(a0)
        ret                                               


Dialog_stop:
# a0 = dialog address
# a1 = val, if val != 0
addi sp,sp,-16
sw ra,0(sp)
sw zero,4(sp)
sw a0,8(sp)
sw a1,12(sp)

Loop_DS:

la a0, battleText	# Load map
li a5,0
image(a0, 0, 168, 1)

#la t0, current_min_text
lw t3,4(sp)

lw t0,8(sp)
li t1, 15
li t2, 182
print_dialog(t0, t1, t2, t3, 35, 5, 0x51FF)


mv t2,a0

li a7,101
lw a0,12(sp)
beq a0,zero,dont_print_val
li a1,15
li a2,192
li a3,0xc7ff
srai a4,s1,20
andi a4,a4,1
ecall
dont_print_val:

call key

li t1, 10
bne a0,t1, End_If_DS
	#la t0, current_min_text
	beq t2,zero,end_Loop_DS
	sw t2,4(sp)


End_If_DS:

call print_lifes
call Frame_changer

j Loop_DS
end_Loop_DS:

lw ra,0(sp)
addi sp,sp,16

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

#####################################
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
access_name:
# a0 = address names
# a1 = index

li t0, 0

loop_AN: beq t0,a1,end_AN

lb t1,0(a0)
add a0,a0,t1
addi a0,a0,2

addi t0,t0,1

j loop_AN
end_AN:

addi a0,a0,1

ret
###########################################

.text

refresh_battle_screen:

addi sp,sp,-4
sw ra,0(sp)

la a0, battleBG		# background
image(a0, 0, 0, 0)	#

la a0, battleText	# texto
image(a0, 0, 168, 0)	#

la a0, battleEnemy	# janela de vida do inimigo
image(a0, 17, 25, 0)	#

la a0, battlePlayer	# janela de vida do jogador
image(a0, 168, 113, 0)	#

la t0, current_player_pkmn
lw a1,0(t0)
la a0, pkmns_names
call access_name

li a1, 188
li a2, 121
li a3, 0xc700
srai a4,s1,20
andi a4,a4,1
li a7,104
ecall

la t0, current_enemy_pkmn
lw a1,0(t0)
la a0, pkmns_names
call access_name

li a1, 23
li a2, 32
ecall

	la t0, pkmns_back
	la t1,current_player_pkmn
	lw t1,0(t1)
	slli t1,t1,2
	add t0,t0,t1
	lw a0,0(t0)
	li a5, 0
	image(a0, 55, 114, 0) # imprime pkmn
	
	la t0, pkmns_front
	la t1,current_enemy_pkmn
	lw t1,0(t1)
	slli t1,t1,2
	add t0,t0,t1
	lw a0,0(t0)
	li a5, 0
	image(a0, 211, 47, 0)	# imprime pkmn

lw ra,0(sp)
addi sp,sp,4

ret 

#####################################

pkmn_select_menu:
# a0 = command key

addi sp,sp,-8
sw ra,0(sp)
	sw a0,4(sp)

	la a0, attackSelec	# Load map
	image(a0, 0, 168, 0)	#

	lw a0,4(sp)

	la a1, menu_position
	la a2, lines_columns_pkmns
	la a3, states_positions_pkmns
	la a4, current_menu
	call menu

	lw a1, 4 (a0)
	lw a2, 8 (a0)
	li a0, 42	# eh relativa a cada jogada
	# li a3, 0xc700	#
	li a3, 0xff00
	srli t0, s1, 20
	andi a4, t0, 1 	#
	li a7, 111	#
	ecall
	
	#la t0,pkmn
	#li t1, 20
	#li t2, 198
	#print_dialog(t0, t1, t2, zero, 35, 5, 0xC700)
	
	li a0,1
	li a1,48
	li a2,188
	li a3,0xc700
	srai a4,s1,20
	andi a4,a4,1
	li a7,101
	ecall
	
	li a0,2
	addi a1,a1,52
	ecall
	
	li a0,3
	li a1,48
	li a2,208
	ecall
	
	li a0,4
	addi a1,a1,52
	ecall

lw ra,0(sp) 
addi sp,sp,8

ret

.include "../SYSTEMv21.s"
