extends Node2D

class_name Level
var active_character
var characters = [] # List to store all characters
var current_character_index = 0 # Index of the current character

# Function to initialize characters
func initialize():
	# Populate the characters list
	for child in get_children():
		if child is CharacterBody2D:
			characters.append(child)
	# Set the active character to the first one
	active_character = characters[0]

# Function to play the turn
func play_turn():
	print(active_character)
	# Call the move function for the active character
	active_character._physics_process(0)

# Function to switch to the next character
func next_character():
	current_character_index += 1
	if current_character_index >= characters.size():
		current_character_index = 0
	active_character = characters[current_character_index]
	active_character.movecapital = 105
	print(active_character)

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	play_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

