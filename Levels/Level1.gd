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
		#print(chara[index]["name"])
		#character.show_chara_stats(chara[index])
		index += 1
	# Set the active character to the first one
	active_character = characters[0]

# Function to play the turn
func play_turn():
	print("AC is " + str(active_character))
	# Call the move function for the active character
	active_character.chara = characters
	active_character.enemies = enemies
	if turner == 0:
		active_character._process(0)
	active_character.show_chara_stats(chara[0])
	active_character._physics_process(0)

# Function to switch to the next character
func next_character():
	current_character_index += 1
	if current_character_index >= characters.size() and turner ==0:
		characters[current_character_index-1].recycler(characters[current_character_index-1])
		characters[current_character_index-1].draw_card_deck_hand(characters[current_character_index-1])
		turner = 1
		current_character_index = 0
	if current_character_index >= enemies.size() and turner == 1:
		turner = 0
		current_character_index = 0
	if (turner==0) :
		characters[current_character_index-1].recycler(characters[current_character_index-1])
		characters[current_character_index-1].draw_card_deck_hand(characters[current_character_index-1])
		active_character = characters[current_character_index]
	if (turner==1) :
		active_character = enemies[current_character_index]
		active_character.chara = characters
	active_character.movecapital = 105
	active_character.chara = characters
	active_character.enemies = enemies
	if turner == 1:
		active_character._physics_process(0)
	if turner == 0:
		active_character._process(0)
		active_character.show_chara_stats(chara[current_character_index])
	print("AC is " + str(active_character))

func get_char_data(char):
	chara = char

func show_chara_stats():
	var string5 = "Active_Character/Label"
	get_node(string5).text = chara

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	play_turn()
	#loop_over_tiles(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Function to loop over tiles and get tile information
#func loop_over_tiles(val):
	## Get all used cells
	#var used_cells = Tilemap.get_used_cells(val)
#
	#for cell in used_cells:
		## Get the tile's source ID (to determine the tile type)
		#var source_id = Tilemap.get_cell_source_id(0, cell)  # 0 is the first layer
		#var arr = []
		#if source_id == -1:
			#print(cell)
		#else:
			#arr.append(cell)
			##print("Tile at {cell} has source ID:", source_id)
		#print(arr)
		## Get world position of the tile
		#var world_pos = Tilemap.local_to_map(cell)
#
		## Check for character bodies at this world position
		##check_for_characters(world_pos)

# Function to check for character bodies at a specific world position
#func check_for_characters(world_pos):
	## Get the direct space state from the 2D world
	#var space_state = get_world_2d().direct_space_state
	#
	## Get all bodies that intersect with this point
	#var intersecting_bodies = space_state.intersect_point(world_pos)  # true to include collisions
	#
	## Check for character bodies
	#for body in intersecting_bodies:
		#if body.is_in_group("characters"):  # Check if it's a character
			#print("Character found at position {world_pos}")


