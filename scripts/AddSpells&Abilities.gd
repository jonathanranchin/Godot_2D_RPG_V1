extends Node2D

var characters
var life_pools
var action_deck
var spellnums
var abilities
var names

# Called when the node enters the scene tree for the first time.
func _ready():
	loader()
	print(abilities)
	pass # Replace with function body.

func loader():
	var file = FileAccess.open("res://saves/party_data_1.tres", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		if content:
			var data = JSON.parse_string(content)
			if data:
				characters = data["characters"]
				life_pools = data["life_pools"]
				action_deck = data["action_deck"]
				spellnums = data["spellnums"]
				abilities = data["abilities"]
				names = data["names"]
				return true
			else:
				print("Failed to parse JSON data.")
		else:
			print("File content is empty.")
	else:
		print("Failed to open file for reading.")
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
