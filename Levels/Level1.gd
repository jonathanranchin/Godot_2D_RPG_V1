extends Node2D

class_name Level

var active_character

func initialize():
	active_character = get_child(2)
	print(active_character)

func play_turn():
	#await active_character.play_turn() == "completed"
	#var new_index : int = (active_character.get_index()+1)
	#if(new_index==5):
	#	new_index = 2
	#get_child(new_index).raise()
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	play_turn()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
