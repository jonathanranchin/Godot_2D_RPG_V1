extends Node2D

class_name Level
var active_character
var characters = [] # List to store all characters
var chara
var enemies = []
var neutrals = []
var current_character_index = 0 # Index of the current character
var enemy_character_index = 0
var turner = 0
var roaster = []
@onready var Tilemap = $TileMap
# Function to initialize characters
func initialize():
	# Populate the characters list
	for child in get_node("Characters").get_children():
		if child is CharacterBody2D:
			characters.append(child)
	for child in get_node("Enemies").get_children():
		if child is CharacterBody2D:
			enemies.append(child)
	for child in get_node("Neutrals").get_children():
		if child is CharacterBody2D:
			neutrals.append(child)
	var index = 0
	for character in characters:
		character.local = chara[index]
		roaster.append([character,character.local["agility"],0,"ally"])
		index += 1
	for enemy in enemies:
		roaster.append([enemy,enemy.local.agility,0,"enemy"])
		enemy.chara = characters
	for unit in roaster:
		var random_number = randi_range(1, 15)
		unit[2] = unit[1] * (unit[1]/2) + 5 + random_number
	roaster = sort_array_by_third_element(roaster)
	#prints(roaster.size())
	# Set the active character to the first one
	active_character = roaster[0][0]


func sort_array_by_third_element(array_of_arrays):
	var n = array_of_arrays.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			if array_of_arrays[j][2] < array_of_arrays[j + 1][2]:
				var temp = array_of_arrays[j]
				array_of_arrays[j] = array_of_arrays[j + 1]
				array_of_arrays[j + 1] = temp
	return array_of_arrays

# Function to play the turn
func play_turn():
	print("AC is " + str(active_character))
	# Call the move function for the active character
	active_character.chara = characters
	active_character.enemies = enemies
	if roaster[0][3] == "ally":
		active_character._process(0)
	if roaster[0][3] == "enemy":
		#active_character.chara = characters
		active_character._process(0)
	active_character.show_chara_stats(chara[0])
	active_character._physics_process(0)

# Function to switch to the next character
func next_character():
	prints(current_character_index,roaster.size())
	current_character_index += 1
	roaster[current_character_index-1][0].recycler(roaster[current_character_index-1][0])
	roaster[current_character_index-1][0].draw_card_deck_hand(roaster[current_character_index-1][0])
	if current_character_index >= roaster.size()-1:
		current_character_index = 0
	active_character = roaster[current_character_index][0]
	active_character.chara = characters
	active_character.enemies = enemies
	active_character.show_chara_stats(roaster[current_character_index][0])
	
	if roaster[current_character_index][3] == "enemy":
		#active_character.movecapital = 105
		#print(roaster[current_character_index][3])
		active_character._physics_process(0)

	if roaster[current_character_index][3] == "ally":
		#print(roaster[current_character_index][3])
		active_character._process(0)

		#turner = 1
		#current_character_index = 0
	#if current_character_index >= enemies.size() and turner == 1:
		#turner = 0
		#
	#if (turner==0) :
		#characters[current_character_index-1].recycler(characters[current_character_index-1])
		#characters[current_character_index-1].draw_card_deck_hand(characters[current_character_index-1])
		#active_character = characters[current_character_index]
	#if (turner==1) :
		#active_character = enemies[current_character_index]
		#active_character.chara = characters
	#active_character.movecapital = 105
	#active_character.chara = characters
	#active_character.enemies = enemies
	#if turner == 1:
		#active_character._physics_process(0)
	#if turner == 0:
		#active_character._process(0)
		#active_character.show_chara_stats(chara[current_character_index])
	print("AC is " + str(active_character))
	
	#current_character_index += 1
	#if current_character_index >= characters.size() and turner ==0:
		#characters[current_character_index-1].recycler(characters[current_character_index-1])
		#characters[current_character_index-1].draw_card_deck_hand(characters[current_character_index-1])
		#turner = 1
		#current_character_index = 0
	#if current_character_index >= enemies.size() and turner == 1:
		#turner = 0
		#current_character_index = 0
	#if (turner==0) :
		#characters[current_character_index-1].recycler(characters[current_character_index-1])
		#characters[current_character_index-1].draw_card_deck_hand(characters[current_character_index-1])
		#active_character = characters[current_character_index]
	#if (turner==1) :
		#active_character = enemies[current_character_index]
		#active_character.chara = characters
	#active_character.movecapital = 105
	#active_character.chara = characters
	#active_character.enemies = enemies
	#if turner == 1:
		#active_character._physics_process(0)
	#if turner == 0:
		#active_character._process(0)
		#active_character.show_chara_stats(chara[current_character_index])
	#print("AC is " + str(active_character))

func roaster_remove(data):
	var stock = []
	for unit in roaster:
		if unit[0] != data:
			stock.append(unit)
	enemies = []
	for child in get_node("Enemies").get_children():
		if child is CharacterBody2D and child != data:
			enemies.append(child)
	print(enemies)
	active_character.enemies = enemies
	roaster = stock
	print(roaster.size())

func get_char_data(char):
	chara = char

func show_chara_stats():
	var string5 = "Active_Character/Label"
	get_node(string5).text = chara

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	play_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
