.include "../MACROSv21.s"
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

.macro image(%imageAddressRegis , %xLower , %yLower)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	call Image

.end_macro

.macro iterate_animation(%imageAddressRegis , %xLower , %yLower, %should_loop)
	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	mv a3,%should_loop
	
	call Animation_Iterator
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

.data

.include "resources/mapaTeste.data"
.include "resources/walk.data"
.include "resources/stages.data"
.include "resources/scissors.data"
.include "resources/tree.data"
.include "resources/menu.data"

.include "battle/battleBG.data"
.include "battle/battleText.data"
.include "battle/battleSelect.data"
.include "battle/battlePlayer.data"
.include "battle/battleEnemy.data"
.include "battle/pkmns.data"
.include "battle/attackSelec.data"

.include "resources/guard.data"

CONST_FLOAT: .float 100

imagem: .word 0,0,0
player_real_position: .float 160, 130
player_position: .word 160, 130
player_last_position: .word 0,0

animation_state: .word 0,0

player_hitbox: .word 0,0,0,0
pkmnsSelect: .word 16,
1, 60,16,267,47
1, 60,48,155,55
1, 204,48,267,55
1, 61,64,74,95
1, 188,83,235,107
1, 60,137,139,167
1, 188,137,267,167
1, 60,196,75,223
1, 252,196,268,223
2, 150,211,176,227
exit_pk_select: .word 0,0, 0,200,1
1, 0,0,319,15
1, 0,14,58,224
1, 268,14,319,225
1, 0,224,319,239
7, 68,64,118,118
1, 75,73,107,111

stadium_hb: .word 27,
1, 104,64,120,80
1, 200,80,216,96
6, 88,64,136,80,0
6, 184,80,232,96,1
1, 72,0,247,24
1, 56,0,71,239
8, 157,59,171,78, -1
1, 248,0,263,239
1, 104,32,135,65
1, 136,32,215,52 
1, 232,48,247,69
1, 72,48,87,69
1, 200,53,215,82
1, 104,81,119,111
1, 104,112,135,149
1, 184,112,215,149
1, 200,99,215,111
1, 72,160,87,181
1, 232,144,247,165
1, 87,199,103,230
1, 104,192,135,229
1, 184,192,215,229
1, 216,199,232,230
#1, 136,112,183,132 
# 1, 136,112,150,132
8, 225,111,269,130,6
1, 168,112,183,132
2, 147,228,172,239, 
exit_stadium: .word 0,0, 180,50,2
8, 83,111,97,130,3
#8, 89,111,103,130,4
8, 209,111,223,130,5


open1_hb: .word 14,
1, 0,0,10,198
3, 11,0,75,84
2, 0,0,319,20, 
open1_up: .word 0,0, 0,200,2
3, 124,0,267,20
3, 76,69,220,84
3, 268,0,300,198
4, 15,89,215,146
3, 11,148,60,198
1, 0,199,138,239
3, 188,197,219,239
1, 301,0,319,198
1, 220,199,319,239
2, 0,229,319,239, 
open1_down: .word 0,0, 0,185,0
8, 248,26,262,45,0 

open2_hb: .word 25,
1, 0,0,10,239
1, 11,0,139,33
1, 140,0,162,52
1, 163,0,211,44
1, 212,0,235,52
1, 236,0,299,34
1, 300,0,319,239
2, 163,45,211,60, 
open2_up: .word 0,0, 155,200,3
1, 132,34,139,75 # 1, 132,34,139,65
1, 236,35,243,75 # 1, 236,35,243,65
3, 11,195,75,239
3, 124,197,219,239
3, 220,213,299,239
2, 0,231,319,239,
open2_down: .word 0,0, 0,20,1
1, 11,77,59,84
1, 76,77,139,84
1, 219,77,251,84
1, 268,77,299,84
1, 11,141,123,148
1, 140,141,235,149
1, 236,117,299,180
1, 284,196,299,212
5, 106,48,120,62
8, 61,67,75,86,1
8, 125,129,139,148,2

key: .byte 0
current_map: .word 0
has_scissors: .byte 0,1
has_trees: .byte 1,1

current_dialog: .word 1,0 # bool, dialog address

dialogo_inicial: .word 126
.string "Voce magicamente brota numa sala suspeita\n\n\n\n-Voce\n Oh nao eu vou perder a aula de OAC, eh melhor eu descobrir como sair daqui"

#################### combat data

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
bag: .word 4
.string "Talk"
run: .word 3
.string "Run"

player_pkmns: .word 4
pkmns_array:

.word 0  # current_pkmn, if don't -1
.float 100 # level
.word 10, 500, 30 # level, stats attack, stats defense 

.word 1  # is_active?, current_pkmn
.float 90 # level
.word 9, 500, 30 # level, stats attack, stats defense 

.word 2  # is_active?, current_pkmn
.float 80 # level
.word 8, 500, 30 # level, stats attack, stats defense 

.word 3  # is_active?, current_pkmn
.float 70 # level
.word 7, 500, 30 # level, stats attack, stats defense 

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
states_positions_select: .word	1,182,188, 10,247,188
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

constCP1: .float 0.0125
constCP2: .float 0.075
constCP3: .float 0.8571428571428571

initial_stats: .byte 53,44, 48,50, 49,49, 55,40, 58,40

guards: .byte 1,1,1,1,0,0,1

battle_type: .word 0,0

dialogo_final:.word 51
.string "Eh...\n\n\nNao era para eu sair daqui?\n\n\n\nFim de jogo\n"
      
# normal : 0, fire : 1, water : 2, grass : 3, fighting : a4, dark : 5 

types_matrix: .float
1.0, 1.0, 1.0, 1.0, 1.0, 1.0
1.0, 0.5, 0.5, 2.0, 1.0, 1.0
1.0, 2.0, 0.5, 0.5, 1.0, 1.0
1.0, 0.5, 2.0, 0.5, 1.0, 1.0
1.0, 1.0, 1.0, 1.0, 0.5, 2.0
1.0, 1.0, 1.0, 1.0, 2.0, 0.5

.include "bgm/battle_music.data"

.text

la s0,player_position	#
li s1,0xFF100000	# Initialize 
la s2,imagem		# Constants
## s3 time
la s4,pkmnSelect
la s5,pkmnsSelect

##### conecting maps

la t0,exit_stadium
la t1,open2
la t2,open2_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,exit_pk_select
la t1,open1
la t2,open1_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,open1_up
la t1,open2
la t2,open2_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,open1_down
la t1,pkmnSelect
la t2,pkmnsSelect
sw t1,0(t0)
sw t2,4(t0)

la t0,open2_up
la t1,stadium
la t2,stadium_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,open2_down
la t1,open1
la t2,open1_hb
sw t1,0(t0)
sw t2,4(t0)

######

la t0,walkFront0
#la t0,walkBack0
la a0,imagem
sw t0,0(a0)
sw t0,8(a0)
li t0,0	   		# 0 para direita 1 para esquerda
sw t0,4(a0)


#######

la t0,dialogo_inicial
la t1,current_dialog
sw t0,4(t1)

#######

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



#### main loop #####


LOOP:	

	
#################### dialog
	
	la t0,current_dialog
	lw t1,0(t0)
	beq t1,zero,Dont_Dialog
		sw zero,0(t0)
		lw a0,4(t0)
		call Dialog_stop
	
Dont_Dialog:
####################

	li a7,30	# saves global time
	ecall
	mv s3,a0


	####################  load map
	li a5,0			
	mv a0,s4
	image(a0, 0, 0)	
		
	################ update last player position
	
	lw t1,0(s0)
	lw t2,4(s0)
	sw t1,8(s0)
	sw t2,12(s0)
	
	####################  input player
	la a0,imagem
	call Input_Player
	
	####### change hitboxes
	
	la t0, player_position
	lw t1,0(t0)
	lw t2,4(t0)
	
	la t0, imagem
	lw t0,0(t0)
	lw t3,0(t0)
	lw t4,4(t0)
	
	
	add t3,t3,t1
	add t4,t4,t2
	addi t3,t3,-1
	addi t4,t4,-1
	
	addi t2,t2,12
	
	la t0, player_hitbox
	sw t1,0(t0)
	sw t2,4(t0)
	sw t3,8(t0)
	sw t4,12(t0)
	
	
	la a0,player_hitbox
	mv a1,s5
	mv a2,s0
	addi a3,s0,-8
	call player_hitbox_interaction
	
	###################### battle
	
	la t0, battle_type
	lw t1,0(t0)
	beq t1,zero,dont_start_battle
	
	la a0,enemy_array
	mv a1,t1
	call generate_enemy
	
	la a0,pkmns_array
	la a1,enemy_array
	call Battle

		la t0, battle_type
		lw t1,0(t0)
		li t3,3
		beq t1,t3,boss_state
		li t3,2
		bne t1,t3,perdeu_batalha
		lw t1,4(t0)
		sw zero,-8(t1)
		
		lw t1,12(t1)
		la t0,guards
		add t0,t0,t1
		sb zero,0(t0)
		j perdeu_batalha
boss_state:
		la a0,dialogo_final
		call Dialog_stop
		j fim
				
perdeu_batalha:
	
	la t0, battle_type
	sw zero,0(t0)
	
dont_start_battle:	

################## print guards

	la t0,current_map
	lb t1,0(t0)
	li t2,1
	la t3,guards
	la t4,guard
	bne t1,t2,not_map1
		lb t0,0(t3)
		beq t0,zero,not_map1
		li a5,0
		image(t4,248,26)	
not_map1:
	li t2,2
	bne t1,t2,not_map2
		la t3,guards
		lb t0,1(t3)
		la t4,guard
		beq t0,zero,not_guard1
		li a5,0
		image(t4,61,67)
not_guard1:
		la t3,guards
		lb t0,2(t3)
		la t4,guard
		beq t0,zero,not_map2
		li a5,0
		image(t4,125,129)	
not_map2:	


li t2,3
	bne t1,t2,not_map3
		la t3,guards
		lb t0,3(t3)
		la t4,guard
		beq t0,zero,not_guard3
		li a5,0
		image(t4,83,111)
not_guard3:
		la t3,guards
		lb t0,4(t3)
		la t4,guard
		beq t0,zero,not_guard4
		li a5,0
		image(t4,89,111)
		
not_guard4:
		la t3,guards
		lb t0,5(t3)
		la t4,guard
		beq t0,zero,not_guard5
		li a5,0
		image(t4,209,111)
not_guard5:

		la t3,guards
		lb t0,6(t3)
		la t4,guard
		beq t0,zero,not_map3
		li a5,0
		image(t4,225,111)
not_map3:	
	
	###################### print player
	
	la a0,imagem
	la a2,player_position
	lw a1,0(a2)
	lw a2,4(a2)
	
	la t0, animation_state
	lw a3, 0(t0)   # sould loop
	call Animation_Iterator # it moves the player
	

	####################### action menu
	
	la t0, key
	lb t1,0(t0)
	li t2, 27
	
	bne t1,t2,dont_action_menu
	call action_menu
	
dont_action_menu:
			
	####################### print map objects
	
	
	la t0,has_scissors
	lb t1,0(t0)
	beq t1,zero,no_scissors
	la a0,scissors
	li a5,0
	image(a0, 0, 0)	
no_scissors:

		
	la t0,current_map
	lb t1,0(t0)
	li t2,2
	bne t1,t2,no_collectable_scissors
	la t0,has_scissors
	lb t1,1(t0)
	beq t1,zero,no_collectable_scissors
	li a5,0
	la a0,scissors
	image(a0, 106, 48)	
no_collectable_scissors:

	la t0,current_map
	lb t1,0(t0)
	li t2,3
	bne t1,t2,no_trees
	
		la t0,has_trees
		lb t1,0(t0)
		beq t1,zero,not_first_tree
		
		la a0,tree
		li a5,0
		image(a0, 104, 64)
	
not_first_tree:
	la t0,has_trees
	lb t1,1(t0)
	beq t1,zero,no_trees
		la a0,tree
		li a5,0
		image(a0, 200, 80)
		
no_trees:



################# frame changer
	call Frame_changer
	
j LOOP
fim: j fim

##################### IMAGE

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
	j Loop_I1
END_I:
	ret

########################## Animation Iterator

Animation_Iterator:
	# a0 = pointer to the animation section (pointer to the images), a1 = x, a2 = y, a3 = should_loop
	## toda animacao tem que terminar com x, 0
	
	addi sp, sp, -4
	
	sw a3,0(sp)
	
	
	lw t0,0(a0) # endereco das imagens
	
	lw t1,0(t0) # maximo de largura
	lw t2,4(t0) # maximo de altura
	bne t1,t2,Dont_Restart_Loop
	bne t1,zero,Dont_Restart_Loop
	lw t0,8(a0) ## endereco atual igual ao inicial
	sw t0,0(a0) ##

Dont_Restart_Loop:

	addi sp,sp,-8
	sw a0,4(sp)
	sw ra,0(sp)

	lw a5,4(a0) # pega orientacao de a0
	mv a0,t0
	call Image # chama Image
	lw ra,0(sp)
	lw a0,4(sp)
	
	addi sp,sp,8
	
	
	lw a3,0(sp)
	addi sp, sp, 4
	
	bne a3, zero, Continue_AniIter
	ret
Continue_AniIter: 
	
	lw t0,0(a0)  #
	lw t1,4(t0)  #
	lw t2,0(t0)  # 
	mul t1,t1,t2
	li t3,4
	rem t2,t1,t3
	beq t2,zero,Correct_Val
	sub t2,t3,t2
Correct_Val:
		
	add t1,t1,t0
	addi t1,t1,8
	add t1,t1,t2
	sw t1,0(a0) # salva novo endereco
	
	ret
	
################## Frame changer

Frame_changer:
	li t0,0x00100000
	xor s1,s1,t0
	li t0,0xFF200604
	lw t1,0(t0)
	xori t1,t1,0x01
	sw t1,0(t0)
	ret

##########################  Input player


KEY:	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se n�o h� tecla pressionada ent�o vai para FIM
  	lw a0,4(t1)  			# le o valor da tecla tecla
  	la t1,key
  	sb a0,0(t1)
FIM:	ret	


Input_Player:
	# a0 = player animation
	
	########## ft0 = delta time
	mv a2,a0
	
	li a7,30
	ecall
	sub t0,a0,s3
	la t1, CONST_FLOAT
	fcvt.s.w ft0,t0
       	flw     ft1,0(t1)
       	fdiv.s  ft0,ft0,ft1

	mv a0,a2
	mv a1,a2
	##########
	
	addi sp,sp,-4
	sw ra,0(sp)
	call KEY
	
	mv a3,s0
	
	li t0,97 # a
	bne a0,t0,Next_Input1
	la t2,walkSide0
	li a2,1

	li a4,-70 #*******
		
	call Move_Player_Command
	
Next_Input1:
	li t0,100 # d
	bne a0,t0,Next_Input2
	la t2,walkSide0
	li a2,0
	li a4,70 #*******
	
	
	call Move_Player_Command
	
Next_Input2:
	li t0,115 # s 
	bne a0,t0,Next_Input3
	la t2,walkFront0
	li a2,1
	addi a3,a3,4
	li a4,70 #*******
		
	
	call Move_Player_Command
	
Next_Input3:
	li t0,119 # w
	la t2,walkBack0
	li a2,0
	addi a3,a3,4
	li a4,-70 #*******
	
	
	bne a0,t0,Next_Input4
	call Move_Player_Command
Next_Input4:
	la t0, animation_state	# should loop = false
	sw zero,0(t0)		#
		
	j End_IP
Move_Player_Command:

	la t3, animation_state	#
	li t1,1			# should loop = true
	sw t1,0(t3)
	lw t1,4(t3)		#
	sw t0,4(t3)
	sub t0,t0,t1
	
	call Move_Player

End_IP:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret

##################### player movement

Move_Player:
	
	fcvt.s.w ft1,a4		#
	fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	sw t2,8(a1)
	
	beq zero,t0,Same_Direction
	sw t2,0(a1)
	sw a2,4(a1) # change direction

Same_Direction:

	
	flw ft1,-8(a3)
	fadd.s ft1,ft1,ft0
	fsw ft1,-8(a3)
	
	fcvt.w.s t0,ft1
	sw t0,0(a3)
	
	li a0,53	# nota
        li a1,10	# duracao
        li a2,35	# instrumento
        li a3,40	# volume
        li a7,31
        ecall
	
	ret
	
######################### hitbox interactions

new_position:
        lw      a5,4(a2)
        lw      a4,12(a2)
        sub     a6,a5,a4
        beq     a5,a4,PHI15
        flw     fa5,4(a3)
        bgt     a6,zero,PHI16
        lw      a4,4(a0)
        lw      a6,12(a1)
        sub     a4,a4,a6
        addi    a4,a4,-1
        sub     a5,a5,a4
        sw      a5,4(a2)
        lw      a5,4(a0)
        lw      a4,12(a1)
        sub     a5,a5,a4
        addi    a5,a5,-1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,4(a3)
PHI7:
        ret
PHI16:
        lw      a4,12(a0)
        lw      a6,4(a1)
        sub     a4,a4,a6
        addi    a4,a4,1
        sub     a5,a5,a4
        sw      a5,4(a2)
        lw      a5,12(a0)
        lw      a4,4(a1)
        sub     a5,a5,a4
        addi    a5,a5,1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,4(a3)
        ret
PHI15:
        lw      a4,0(a2)
        lw      a5,8(a2)
        sub     a5,a4,a5
        ble     a5,zero,PHI9
        lw      a5,8(a0)
        lw      a6,0(a1)
        flw     fa5,0(a3)
        sub     a5,a5,a6
        addi    a5,a5,1
        sub     a4,a4,a5
        sw      a4,0(a2)
        lw      a5,8(a0)
        lw      a4,0(a1)
        sub     a5,a5,a4
        addi    a5,a5,1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,0(a3)
        ret
PHI9:
        beq     a5,zero,PHI7
        lw      a5,0(a0)
        lw      a6,8(a1)
        flw     fa5,0(a3)
        sub     a5,a5,a6
        addi    a5,a5,-1
        sub     a4,a4,a5
        sw      a4,0(a2)
        lw      a5,0(a0)
        lw      a4,8(a1)
        sub     a5,a5,a4
        addi    a5,a5,-1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,0(a3)
        ret
        
collision_decision2:
        li      a5,7
        beq     a0,a5,PHB38
        li      a5,8
        beq     a0,a5,PHB39
        li      a5,3
        beq     a0,a5,PHB42
        ret
PHB42:
        addi sp,sp,-4
        sw a7,0(sp)
        la a0,animation_state
        lw a1,0(a0)
        li a0,2
        li a7,41
        ecall
        andi a0,a0,15
        addi a0,a0,-14
        slt a0,zero,a0
        and a0,a0,a1
        beq a0,zero,dont_battle
        
                la a0,battle_type
                li a1,1
                sw a1,0(a0)
        
dont_battle:
        lw a7,0(sp)
        addi sp,sp,4
        ret
PHB39:
        	la a0,battle_type
                sw a1,4(a0)
                lw a1,12(a1)
                addi a1,a1,1
                beq a1,zero, boss_fight
                li a1,2
                sw a1,0(a0)
		ret
boss_fight:
		li a1,3
		sw a1,0(a0)
        ret
PHB38:
        li      a5,0
        la a0,key
        lb a0,0(a0)
        li a5,10
        bne a0,a5,dont_heal
        addi sp,sp,-4
       	sw ra,0(sp)
       	call heal_pkmns
       	lw ra,0(sp)
       	addi sp,sp,4
        
dont_heal:        
        ret
player_hitbox_interaction:
        addi    sp,sp,-64
        sw      s8,24(sp)
        lw      s8,0(a1)
        sw      ra,60(sp)
        sw      s0,56(sp)
        sw      s1,52(sp)
        sw      s2,48(sp)
        sw      s3,44(sp)
        sw      s4,40(sp)
        sw      s5,36(sp)
        sw      s6,32(sp)
        sw      s7,28(sp)
        sw      s9,20(sp)
        sw      s10,16(sp)
        sw      s11,12(sp)
        ble     s8,zero,PHB43
        mv      s9,a0
        mv      s10,a2
        mv      s1,a3
        li      s5,0
        addi    a5,a1,4
        li      s7,0
        li      s2,5
        li      s3,6
        li      s6,10
        li      s4,1
        li      s11,2
PHB44:
        lw      a1,0(s9)
        lw      a4,12(a5)
        lw      a0,0(a5)
        bgt     a1,a4,PHB80
        lw      a3,4(a5)
        lw      a4,8(s9)
        bgt     a3,a4,PHB80
        lw      a3,12(s9)
        lw      a4,8(a5)
        blt     a3,a4,PHB80
        lw      a3,16(a5)
        lw      a4,4(s9)
        blt     a3,a4,PHB80
        li      a3,1
        beq     a0,s11,PHB83
PHB46:
        addi    a4,a0,-6
        andi    a4,a4,-3
        addi    s0,a5,8
        beq     a4,zero,PHB54
        addi    s0,a5,4
PHB54:
        bne     a3,zero,PHB84
PHB47:
        addi    s7,s7,1
        addi    a5,s0,16
        bne     s8,s7,PHB44
PHB43:
        lw      ra,60(sp)
        lw      s0,56(sp)
        lw      s1,52(sp)
        lw      s2,48(sp)
        lw      s3,44(sp)
        lw      s4,40(sp)
        lw      s5,36(sp)
        lw      s6,32(sp)
        lw      s7,28(sp)
        lw      s8,24(sp)
        lw      s9,20(sp)
        lw      s10,16(sp)
        lw      s11,12(sp)
        addi    sp,sp,64
        jr      ra
PHB80:
        li      a3,0
        addi    s0,a5,24
        bne     a0,s11,PHB46
        j       PHB47
PHB84:
        beq     a0,s2,PHB55
        ble     a0,s2,PHB85
        bne     a0,s3,PHB58
        li      a5,0
        la a0,key
        lb a0,0(a0)
        mv a5,a0
        la t0,has_scissors
        lb s5,0(t0)
        beq s5,zero,PHB58
        beq     a5,s6,PHB86
PHB58:
        mv      a1,s0
        call    collision_decision2
        j       PHB47
PHB85:
        bne     a0,s4,PHB58
        lw      a5,4(s10)
        lw      a4,12(s10)
        sub     a3,a5,a4
        beq     a5,a4,PHB87
        flw     fa5,4(s1)
        bgt     a3,zero,PHB88
        lw      a4,4(s9)
        lw      a3,12(s0)
        mv      a1,s0
        sub     a4,a4,a3
        addi    a4,a4,-1
        sub     a5,a5,a4
        sw      a5,4(s10)
        lw      a5,4(s9)
        lw      a4,12(s0)
        sub     a5,a5,a4
        addi    a5,a5,-1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,4(s1)
        call    collision_decision2
        j       PHB47
PHB55:
        la t0,has_scissors
        sb zero,1(t0)
        li t1,1
        sb t1,0(t0)
        mv      a1,s0
        call    collision_decision2
        j       PHB47
PHB83:
        lw      a2,32(a5)
        lw      a3,4(s10)
        flw     fa5,4(s1)
        lw      a4,28(a5)
        sub     a3,a2,a3
        fcvt.s.w        fa4,a3
        lw      a1,24(a5)
        lw      a3,20(a5)
        fadd.s  fa5,fa5,fa4
        lw      a6,36(a5)
        sw      a2,4(s10)
        addi    s0,a5,24
        fsw     fa5,4(s1)
        beq     a4,zero,PHB52
        lw      a5,0(s10)
        flw     fa5,0(s1)
        sw      a4,0(s10)
        sub     a4,a4,a5
        fcvt.s.w        fa4,a4
        fadd.s  fa5,fa5,fa4
        fsw     fa5,0(s1)
PHB52:
        la t0,current_map
        sw a6, 0(t0)
        sw a3,40(sp)
        sw a1,36(sp)
        mv      a1,s0
        call    collision_decision2
        j       PHB47
PHB87:
        lw      a4,0(s10)
        lw      a5,8(s10)
        sub     a5,a4,a5
        ble     a5,zero,PHB61
        lw      a5,8(s9)
        lw      a3,0(s0)
        flw     fa5,0(s1)
        mv      a1,s0
        sub     a5,a5,a3
        addi    a5,a5,1
        sub     a4,a4,a5
        sw      a4,0(s10)
        lw      a5,8(s9)
        lw      a4,0(s0)
        sub     a5,a5,a4
        addi    a5,a5,1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,0(s1)
        call    collision_decision2
        j       PHB47
PHB86:
        lw      a5,12(s0)
        li      a4,0
        la t0,has_trees
        add t0,t0,a5
        sb zero,0(t0)
        la a4, stadium_hb
        
        slli t0,a5,2
        add t0,t0,a5
        slli t0,t0,2
        addi a4,a4,4
        add a4,a4,t0
          
        sw zero,0(a4)
        mv      a1,s0
        call    collision_decision2
        j       PHB47
PHB88:
        lw      a4,12(s9)
        lw      a3,4(s0)
        mv      a1,s0
        sub     a4,a4,a3
        addi    a4,a4,1
        sub     a5,a5,a4
        sw      a5,4(s10)
        lw      a5,12(s9)
        lw      a4,4(s0)
        sub     a5,a5,a4
        addi    a5,a5,1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,4(s1)
        call    collision_decision2
        j       PHB47
PHB61:
        beq     a5,zero,PHB58
        lw      a5,8(s0)
        flw     fa5,0(s1)
        sub     a5,a1,a5
        addi    a5,a5,-1
        sub     a5,a4,a5
        sw      a5,0(s10)
        lw      a5,0(s9)
        lw      a4,8(s0)
        sub     a5,a5,a4
        addi    a5,a5,-1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,0(s1)
        j       PHB58


doOverlap:
        lw      a3,0(a0)
        lw      a4,8(a1)
        mv      a5,a0
        bgt     a3,a4,.L3
        lw      a4,8(a0)
        lw      a3,0(a1)
        li      a0,0
        bgt     a3,a4,.L2
        lw      a3,12(a5)
        lw      a4,4(a1)
        blt     a3,a4,.L2
        lw      a0,12(a1)
        lw      a5,4(a5)
        slt     a0,a0,a5
        xori    a0,a0,1
        ret
.L3:
        li      a0,0
.L2:
        ret

########################### dialog

Dialog_stop:
# a0 = dialog address
addi sp,sp,-12
sw ra,0(sp)
sw zero,4(sp)
sw a0,8(sp)

Loop_DS:

la a0, battleText	# Load map
li a5,0
image(a0, 0, 168)

lw t3,4(sp)

lw t0,8(sp)
li t1, 15
li t2, 182
print_dialog(t0, t1, t2, t3, 35, 5, 0x51FF)


mv t2,a0

call KEY

li t1, 10
bne a0,t1, End_If_DS
	beq t2,zero,end_Loop_DS
	sw t2,4(sp)


End_If_DS:

call Frame_changer

j Loop_DS
end_Loop_DS:

lw ra,0(sp)
addi sp,sp,12

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
	

	li a7,111
	ecall

	li a0,62
	addi a1,a1,2
	li a3,0xC7FF

	ecall
End_Next_Symbol:
	beq t5,t0,If_PD
	mv a0, t5
	ret
If_PD:	li a0,0
	ret

	
############################# action menu

action_menu:

addi sp,sp,-4
sw ra,0(sp)

loop_menu:

la t0,menu
li a5,0
image(t0,0,0)
call print_menu
call Frame_changer
call KEY

bne a0,zero,end_menu

j loop_menu
end_menu:

lw ra,0(sp)
addi sp,sp,4

ret

##############################################

print_menu:

li t2,0
li t3,4

li a2, 39
li a3, 0xc7ff 
srai a4,s1,20
andi a4,a4,1
la t4, pkmns_names
la t5, pkmns_array

addi sp,sp,-16
sw ra,0(sp)
sw t4,4(sp)
sw a2,8(sp)
sw a4,12(sp)

loop_PM:
beq t2,t3,end_PM

lw a0,4(sp)
lw a1,0(t5)
addi a1,a1,1
beq a1,zero,dont_print_menu
addi a1,a1,-1
lw a2,8(sp)
li a3,0xc7ff
lw a4,12(sp)
call access_name
li a1, 95
li a7, 104
ecall

li a0,0x33
li a1,194
lw a2,8(sp)
addi a2,a2,2

flw fa0,4(t5)
fcvt.w.s a3,fa0
li a4,61
li a5,3
call bar

lw a0,8(t5)
li a1,135
lw a2,8(sp)
addi a2,a2,10
li a3,0xc7ff
lw a4,12(sp)
li a7,101
ecall

dont_print_menu:

lw a2,8(sp)
addi a2,a2,37
sw a2,8(sp)

addi t5,t5,20
addi t2,t2,1
j loop_PM

end_PM:

lw ra,0(sp)
addi sp,sp,16

ret

##############################################

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

#################################################	

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
        
heal_pkmns:

la a0,pkmns_array
addi a0,a0,4
li a1,0
li a2,4
li a3,1120403456
loop_HP:
beq a1,a2,end_HP

sw a3,0(a0)

addi a0,a0,20
addi a1,a1,1
j loop_HP
end_HP:

ret

############################ battle

Battle:

addi sp,sp,-12
sw ra,0(sp)
sw a0,4(sp)
sw a1,8(sp)

la s9, main_track

la a0,menu
li a5,0
image(a0,0,0)
call print_menu
call Frame_changer
la a0,menu
li a5,0
image(a0,0,0)
call print_menu

la a0, attackSelec	# Load map
li a5,0
image(a0, 0, 168)	#


lw a0,4(sp)
call select_pkmn

lw t0,8(sp)
lw t1,0(t0)
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
sw zero,20(t0)                  
       

call refresh_battle_screen
call Frame_changer
call refresh_battle_screen
li a0,2
li a7,41
ecall
andi a0,a0,0x1
beq a0,zero,Enemy_turn
                              
Player_Loop:

call refresh_battle_screen

call KEY

####### menu state
li t0, 27
la t1, menu_state
bne a0, t0, not_back
sw zero, 0(t1)
not_back:

la t3, current_menu
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
beq t0, t1, talk_state
li t1,4
beq t0, t1, attack_state
li t1,5
beq t0, t1, attack_state
slt t2,t1,t0
li t1,10
slt t3,t0,t1
and t1,t2,t3
addi t1,t1,-1
beq zero,t1, pkmn_select_state

li t1,10
beq t0,t1, run_state

	addi sp,sp, -4
	sw a0,0(sp)

	la a0, battleSelect	# Load map
	li a5,0
	image(a0, 160, 168)	#

	lw a0,0(sp)
	addi sp,sp, 4

	la a1, menu_position
	la a2, lines_columns_select
	la a3, states_positions_select
	la a4, current_menu
	call menu_battle

	lw a1, 4 (a0)
	lw a2, 8 (a0)
	li a0, 42	# eh relativa a cada jogada
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

run_state:

la t2,menu_state
sw zero,0(t2)

la a0,pkmns_array
call calculate_chance
bne a0,zero,End_battle

j Enemy_turn

battle_state:

	addi sp,sp, -4
	sw a0,0(sp)

	la a0, attackSelec	# Load map
	li a5,0
	image(a0, 0, 168)	#

	lw a0,0(sp)
	addi sp,sp, 4

	la a1, menu_position
	la a2, lines_columns_battle
	la a3, states_positions_battle
	la a4, current_menu
	call menu_battle
	
	lw a1, 4 (a0)
	lw a2, 8 (a0)
	li a0, 42	# eh relativa a cada jogada
	li a3, 0xff00
	srli t0, s1, 20
	andi a4, t0, 1 	#
	li a7, 111	#
	ecall 

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
	li a5,0
	image(a0, 0, 168)	#

	lw a0,0(sp)
	addi sp,sp, 4
	
	call pkmn_select_menu
	
j end_state
talk_state:

	la t2,menu_state
	sw zero,0(t2)
	
	lw a0,8(sp)
	call calculate_chance
	beq a0,zero,Enemy_turn
	
	la a0, battleText	# Load map
	li a5,0
	image(a0, 0, 168)
	call print_lifes
	call Frame_changer
	la a0, battleText	# Load map
	li a5,0
	image(a0, 0, 168)
	call print_lifes
	call Frame_changer
		
loop_pkmn_change:	
	call KEY
	li t0,10
	beq t0,a0,end_pkmn_change
	call pkmn_select_menu
	call Frame_changer

	j loop_pkmn_change
	
end_pkmn_change:
			
	la t0,current_menu
	lw t3,0(t0)	
	addi t0,t3,-6
	li t1,20
	mul t0,t0,t1
	lw t2,4(sp)
	add t6,t2,t0
	
	la t1,enemy_pkmn_index
	lw t0,(t1)
	li t1,20
	mul t0,t0,t1
	lw t2,8(sp)
	add t0,t2,t0
	
	lw t1,0(t0)
	lw t2,4(t0)
	lw t3,8(t0)
	lw t4,12(t0)
	lw t5,16(t0)
	
	sw t1,0(t6)
	sw t2,4(t6)
	sw t3,8(t6)
	sw t4,12(t6)
	sw t5,16(t6)
	
	j End_battle

pkmn_select_state:

	addi t0,t0,-6
	mv t6,t0
	li t1,20
	mul t0,t0,t1
	
	la t2,menu_state
	sw zero,0(t2)
	
	lw t2,4(sp)
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
	call Dialog_stop_battle
	
		
	fmv.s.x ft0,zero
	fle.s t0,ft1,ft0
	beq t0,zero,Enemy_turn
	
	lw t0,8(sp)
	la t1, enemy_pkmn_index
	lw t1,0(t1)
	li t2,20
	mul t1,t1,t2
	add t0,t0,t1
	
	lw t1,0(t0)
	addi t1,t1,-5	
	sw t1,0(t0)
	
	
	la t1, enemy_pkmns
	lw t2,0(t1)
	addi t2,t2,-1
	sw t2,0(t1)
	
	bne t2,zero,dont_win
	la a0,ganhou
	li a1,0
	call Dialog_stop_battle
	li a0,0
	j End_battle
dont_win:

	la t1, enemy_pkmn_index
	lw t0,0(t1)
	addi t0,t0,1
	
	mv t6,t0
	li t1,20
	mul t0,t0,t1
	
	lw t2,8(sp)
	add t0,t2,t0
	
	lw t1,0(t0)
	
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
call BGM
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
	
	la t0,current_player_pkmn
	lw t0,0(t0)
	lw t1,4(sp)
	li t2,20
	mul t0,t0,t2
	add t1,t0,t1
			
	la t0,life_player
	flw ft1,0(t0)
	fsub.s ft1,ft1,fa0
	fsw ft1,0(t0)
	fsw ft1,4(t1)

	la a0,recebeu
	fcvt.w.s a1,fa0
	call Dialog_stop_battle
	
	fmv.s.x ft0,zero
	fle.s t0,ft1,ft0
	beq t0,zero,Player_Loop
	
	lw t0,4(sp)
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
	call Dialog_stop_battle
	li a0,1
	j End_battle
dont_lose:
	li a0,0
	lw a0,4(sp)
	call select_pkmn			

	
	j Player_Loop


End_battle:


lw t0,4(sp)
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

lw ra,0(sp)
addi sp,sp,12

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

li a4, 64
li a5, 5
call bar

lw ra,0(sp)
addi sp,sp,4	


ret			
        
select_battle_section:
        ble     a1,zero,SBS2
        li      a4,0
SBS3:
        lbu     a5,0(a0)
        addi    a4,a4,1
        addi    a5,a5,4
        add     a0,a0,a5
        bne     a1,a4,SBS3
SBS2:
	lbu     a5,0(a0)
        addi    a5,a5,2
        add     a1,a0,a5

        ret

damage:
        lw      a5,0(a1)

        la a4,.LC0
        flw fa3,0(a4)
        
        fcvt.s.w        fa5,a5

        la a5,.LC1
        flw fa4,0(a5)
        
        fadd.s  fa5,fa5,fa5
        lw      a5,0(a2)
        fcvt.s.w        fa2,a0
        fcvt.s.w        fa1,a5
        fdiv.s  fa5,fa5,fa3
        lw      a5,4(a3)
        fcvt.s.w        fa3,a5

        la a5,.LC2
        
        fadd.s  fa5,fa5,fa4
        fmul.s  fa5,fa5,fa1
        fmul.s  fa5,fa5,fa2
        fdiv.s  fa5,fa5,fa3

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

call select_battle_section

lb a3,1(a1)	# attack base damage
lb a1,0(a1)	# attack type


la a0, types_matrix
lw a2,16(sp)

call access_matrix

mv a0, a3
lw a1,4(sp)
lw a2,8(sp)
lw a3,12(sp)
call damage


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


Dialog_stop_battle:
# a0 = dialog address
# a1 = val, if val != 0
addi sp,sp,-16
sw ra,0(sp)
sw zero,4(sp)
sw a0,8(sp)
sw a1,12(sp)

Loop_DSB:

la a0, battleText	# Load map
li a5,0
image(a0, 0, 168)

lw t3,4(sp)

lw t0,8(sp)
li t1, 15
li t2, 182
print_dialog(t0, t1, t2, t3, 35, 5, 0x51FF)


mv t2,a0

li a7,101
lw a0,12(sp)
beq a0,zero,dont_print_val_battle
li a1,15
li a2,192
li a3,0xc7ff
srai a4,s1,20
andi a4,a4,1
ecall
dont_print_val_battle:

call KEY

li t1, 10
bne a0,t1, End_If_DSB
	beq t2,zero,end_Loop_DSB
	sw t2,4(sp)


End_If_DSB:

call print_lifes
call Frame_changer

j Loop_DSB
end_Loop_DSB:

lw ra,0(sp)
addi sp,sp,16

ret

#####################################

refresh_battle_screen:

addi sp,sp,-4
sw ra,0(sp)

la a0, battleBG	
li a5,0	# background
image(a0, 0, 0)	#

la a0, battleText
li a5,0	# texto
image(a0, 0, 168)	#

la a0, battleEnemy
li a5,0	# janela de vida do inimigo
image(a0, 17, 25)	#

la a0, battlePlayer
li a5,0	# janela de vida do jogador
image(a0, 168, 113)	#

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
	image(a0, 55, 114) # imprime pkmn
	
	la t0, pkmns_front
	la t1,current_enemy_pkmn
	lw t1,0(t1)
	slli t1,t1,2
	add t0,t0,t1
	lw a0,0(t0)
	li a5, 0
	image(a0, 211, 47)	# imprime pkmn

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
	li a5,0
	image(a0, 0, 168)	#

	lw a0,4(sp)

	la a1, menu_position
	la a2, lines_columns_pkmns
	la a3, states_positions_pkmns
	la a4, current_menu
	
	call menu_battle
	

	lw a1, 4 (a0)
	lw a2, 8 (a0)
	li a0, 42	# eh relativa a cada jogada
	li a3, 0xff00
	srli t0, s1, 20
	andi a4, t0, 1 	#
	li a7, 111	#
	ecall
	
	
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
############################

select_pkmn:

addi sp,sp,-8
sw ra,0(sp)
sw a0,4(sp)

loop_pkmn_select:

	call KEY
	
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
	
	lw t2,4(sp)
	add t0,t2,t0
	
	fcvt.s.w ft1,zero
	flw ft0,4(t0)
	fle.s t1,ft0,ft1
	bne t1,zero,loop_pkmn_select
	lw t1,0(t0)
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

lw ra,0(sp)
addi sp,sp,8	
ret

#############################

calculate_chance:
# a0 = address array

addi a0,a0,4
li a1,0
li a2,4

fcvt.s.w fa0,zero

loop_CC:
beq a1,a2,end_CC

flw fa1,0(a0)
fadd.s fa0,fa0,fa1

addi a0,a0,20
addi a1,a1,1
j loop_CC
end_CC:

li a1, 100
fcvt.s.w fa1,a1
fdiv.s fa0,fa0,fa1

la t0,constCP1
flw fa2,0(t0)
la t0,constCP2
flw fa3,0(t0)

fmul.s fa2,fa2,fa0
fadd.s fa2,fa2,fa3
fmul.s fa1,fa0,fa2

li a0,2
li a7,43
ecall

fle.s a0,fa0,fa1

ret
              
menu_battle:
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
                            
generate_stats:
# a0 = pkmn address, a1 = level


#.float 100 # level
#.word 10, 50, 10 # level, stats attack, stats defense 

li a2,100
fcvt.s.w fa0,a2
fsw fa0,4(a0)

sw a1,8(a0)

addi a2,a1,-1
fcvt.s.w fa1,a2

la a2,constCP3
flw fa2,0(a2)
fmul.s fa1,fa1,fa2
fcvt.w.s a2,fa1

la a3,initial_stats
lw a4,0(a0)

slli a4,a4,1
add a3,a3,a4
lb a4,0(a3)
lb a5,1(a3)

add a4,a4,a2
add a5,a5,a2

sw a4,12(a0)
sw a5,16(a0)

ret


generate_enemy:
# a0 = enemy_array address, a1 = quantity of enemies

addi sp,sp,-4
sw ra,0(sp)

li a2, 0
mv a3,a0

la a0,enemy_pkmns
sw a1,0(a0)

loop_GE:
beq a2,a1,end_GE

addi sp,sp,-12
sw a1,0(sp)
sw a2,4(sp)
sw a3,8(sp)

li a0,2
li a7,41
ecall
bge a0,zero,pos_GE
sub a0,zero,a0
pos_GE:
li a4,5
rem a0,a0,a4

sw a0,0(a3)

mv a0,a3
li a1,5


call generate_stats

lw a1,0(sp)
lw a2,4(sp)
lw a3,8(sp)
addi sp,sp,12

addi a3,a3,20
addi a2,a2,1
j loop_GE
end_GE:

li a2,0
li a4,4
sub a1,a4,a1
li a4,-1

loop_GE2:
beq a2,a1,end_GE2

sw a4,0(a3)

addi a3,a3,20
addi a2,a2,1
j loop_GE2
end_GE2:

lw ra,0(sp)
addi sp,sp,4

ret

calculate_prob:
# a0 = address array

addi a0,a0,4
li a1,0
li a2,4

fcvt.s.w fa0,zero

loop_CP:
beq a1,a2,end_CP

flw fa1,0(a0)
fadd.s fa0,fa0,fa1

addi a0,a0,20
addi a1,a1,1
j loop_CP
end_CP:
li a1, 100
fcvt.s.w fa1,a1
fdiv.s fa0,fa0,fa1

la t0,constCP1
flw fa2,0(t0)
la t0,constCP2
flw fa3,0(t0)

fmul.s fa2,fa2,fa0
fadd.s fa2,fa2,fa3
fmul.s fa0,fa0,fa2

ret

###################### music

BGM:    #ebreak
	mv t6, a0		
	li a3,50		# define o volume

	# TRACK 1
	li a2,80 	       # define o instrumento
	lw a0,0(s9)		# le o valor da nota
	lw a1,4(s9)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota		

	lw a0,0(s9)		# le o valor da nota
	li t0, 12
	sub a0, a0, t0
	lw a1,4(s9)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota

	lw a0,0(s9)		# le o valor da nota
	li t0, 24
	sub a0, a0, t0
	lw a1,4(s9)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota

	addi s9,s9,8		# incrementa para o endere?o da pr?xima nota

	mv a0,a1		# passa a dura??o da nota para a pausa
	addi a0, a0, -15	# Ajusta velocidade da musica
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms

	mv a0, t6

	ret
                                                                                                                                                   
.include "../SYSTEMv21.s"
