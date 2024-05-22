extends TileMap

var characters

var character1 = {
	"damage"  = 0,
	"damage_reduction"  = 0,
	"action_hand"  = [],
	"action_pool" = [[],[]]
}

var character2 = {
	"damage"  = 0,
	"damage_reduction"  = 0,
	"action_hand"  = [],
	"action_pool" = [[],[]]
}

var character3 = {
	"damage"  = 0,
	"damage_reduction"  = 0,
	"action_hand"  = [],
	"action_pool" = [[],[]]
}

var character4 = {
	"damage"  = 0,
	"damage_reduction"  = 0,
	"action_hand"  = [],
	"action_pool" = [[],[]]
}


# Called when the node enters the scene tree for the first time.
func _ready():
	loader()
	characterLoader()
	var chara = [character1,character2,character3,character4]
	get_parent().get_char_data(chara)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func characterLoader():
	character1 = {
		"name" : characters[0]["name"],
		"life_pool" : characters[0]["life_pool"],
		"action_pool" : characters[0]["action_deck"],
		"spells" : characters[0]["spells"],
		"abilities" : characters[0]["abilities"],
		"weapons" : characters[0]["weapons"],
		"weapons_equiped" : characters[0]["weapons_equiped"],
		"armor" : characters[0]["armor"],
		"backstory" : characters[0]["backstory"],
		"strength" : characters[0]["strength"],
		"intellect" : characters[0]["intellect"],
		"agility" : characters[0]["agility"],
		"charisma" : characters[0]["charisma"]
	}
	character2 = {
		"name" : characters[1]["name"],
		"life_pool" : characters[1]["life_pool"],
		"action_pool" : characters[1]["action_deck"],
		"spells" : characters[1]["spells"],
		"abilities" : characters[1]["abilities"],
		"weapons" : characters[1]["weapons"],
		"weapons_equiped" : characters[1]["weapons_equiped"],
		"armor" : characters[1]["armor"],
		"backstory" : characters[1]["backstory"],
		"strength" : characters[1]["strength"],
		"intellect" : characters[1]["intellect"],
		"agility" : characters[1]["agility"],
		"charisma" : characters[1]["charisma"]
	}
	character3 = {
		"name" : characters[2]["name"],
		"life_pool" : characters[2]["life_pool"],
		"action_pool" : characters[2]["action_deck"],
		"spells" : characters[2]["spells"],
		"abilities" : characters[2]["abilities"],
		"weapons" : characters[2]["weapons"],
		"weapons_equiped" : characters[2]["weapons_equiped"],
		"armor" : characters[2]["armor"],
		"backstory" : characters[2]["backstory"],
		"strength" : characters[2]["strength"],
		"intellect" : characters[2]["intellect"],
		"agility" : characters[2]["agility"],
		"charisma" : characters[2]["charisma"]
	}
	character4 = {
		"name" : characters[3]["name"],
		"life_pool" : characters[3]["life_pool"],
		"action_pool" : characters[3]["action_deck"],
		"spells" : characters[3]["spells"],
		"abilities" : characters[3]["abilities"],
		"weapons" : characters[3]["weapons"],
		"weapons_equiped" : characters[3]["weapons_equiped"],
		"armor" : characters[3]["armor"],
		"backstory" : characters[3]["backstory"],
		"strength" : characters[3]["strength"],
		"intellect" : characters[3]["intellect"],
		"agility" : characters[3]["agility"],
		"charisma" : characters[3]["charisma"]
	}
	character1["life_pool"][1] += character1["life_pool"][0]
	character2["life_pool"][1] += character2["life_pool"][0]
	character3["life_pool"][1] += character3["life_pool"][0]
	character4["life_pool"][1] += character4["life_pool"][0]
	for n in range(0,character1["weapons_equiped"].size()):
		character1["life_pool"][1] += character1["weapons_equiped"][n]["life_pool"]
	for n in range(0,character2["weapons_equiped"].size()):
		character2["life_pool"][1] += character2["weapons_equiped"][n]["life_pool"]
	for n in range(0,character3["weapons_equiped"].size()):
		character3["life_pool"][1] += character3["weapons_equiped"][n]["life_pool"]
	for n in range(0,character4["weapons_equiped"].size()):
		character4["life_pool"][1] += character4["weapons_equiped"][n]["life_pool"]
	character1["life_pool"][1] += character1["armor"][0]["life_pool"]
	character2["life_pool"][1] += character2["armor"][0]["life_pool"]
	character3["life_pool"][1] += character3["armor"][0]["life_pool"]
	character4["life_pool"][1] += character4["armor"][0]["life_pool"]
	for n in range(0,character1["weapons_equiped"].size()):
			character1["damage"] =  character1["weapons_equiped"][n]["damage"]
	for n in range(0,character2["weapons_equiped"].size()):
			character2["damage"] =  character2["weapons_equiped"][n]["damage"]
	for n in range(0,character3["weapons_equiped"].size()):
			character3["damage"] =  character3["weapons_equiped"][n]["damage"]
	for n in range(0,character4["weapons_equiped"].size()):
			character4["damage"] =  character4["weapons_equiped"][n]["damage"]
	if (character1["strength"] == 3):
		character1["damage"] +=  1
		if (character1["strength"] == 4):
			character1["damage"] +=  1
	if (character2["strength"] == 3):
		character2["damage"] +=  1
		if (character2["strength"] == 4):
			character2["damage"] +=  1
	if (character3["strength"] == 3):
		character3["damage"] +=  1
		if (character3["strength"] == 4):
			character3["damage"] +=  1
	if (character4["strength"] == 3):
		character4["damage"] +=  1
		if (character4["strength"] == 4):
			character4["damage"] +=  1
	var num = character1["armor"][0]["damage_reduction"]
	character1["damage_reduction"] = int(num)
	num = character2["armor"][0]["damage_reduction"]
	character2["damage_reduction"] = int(num)
	num = character3["armor"][0]["damage_reduction"]
	character3["damage_reduction"] = int(num)
	num = character4["armor"][0]["damage_reduction"]
	character4["damage_reduction"] = int(num)
	character1["action_pool"].append(character1["armor"][0]["action_deck"])
	character2["action_pool"].append(character2["armor"][0]["action_deck"])
	character3["action_pool"].append(character3["armor"][0]["action_deck"])
	character4["action_pool"].append(character4["armor"][0]["action_deck"])
	character1["action_pool"] = [character1["action_pool"],shuffle_array(character1["action_pool"])]
	character1["action_hand"] = extract_and_remove_first_n(shuffle_array(character1["action_pool"][1]),5)
	character1["action_pool"][1] = character1["action_pool"][1].slice(5, character1["action_pool"][1].size())
	character1["life_pool"][1] = shuffle_string(character1["life_pool"][1])
	character2["action_pool"] = [character2["action_pool"],shuffle_array(character2["action_pool"])]
	character2["action_hand"] = extract_and_remove_first_n(shuffle_array(character2["action_pool"][1]),5)
	character2["action_pool"][1] = character2["action_pool"][1].slice(5, character2["action_pool"][1].size())
	character2["life_pool"][1] = shuffle_string(character2["life_pool"][1])
	character3["action_pool"] = [character3["action_pool"],shuffle_array(character3["action_pool"])]
	character3["action_hand"] = extract_and_remove_first_n(shuffle_array(character3["action_pool"][1]),5)
	character3["action_pool"][1] = character3["action_pool"][1].slice(5, character3["action_pool"][1].size())
	character3["life_pool"][1] = shuffle_string(character3["life_pool"][1])
	character4["action_pool"] = [character4["action_pool"],shuffle_array(character4["action_pool"])]
	character4["action_hand"] = extract_and_remove_first_n(shuffle_array(character4["action_pool"][1]),5)
	character4["action_pool"][1] = character4["action_pool"][1].slice(5, character4["action_pool"][1].size())
	character4["life_pool"][1] = shuffle_string(character4["life_pool"][1])


func draw_hand(deck,hand):
	if hand:
		print(hand)
	if deck.size>=5:
		hand += extract_and_remove_first_n(shuffle_array(deck),5)
		deck = deck.slice(5, deck.size())
	if(deck.size()>=1 and deck.size()<5):
		hand += extract_and_remove_first_n(shuffle_array(deck),deck.size())
		deck = []
		print("Round over for Character")
	pass

func loader():
	var file = FileAccess.open("res://saves/party_data_3.tres", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		if content:
			var data = JSON.parse_string(content)
			if data:
				characters = data["characters"]
				return true
			else:
				print("Failed to parse JSON data.")
		else:
			print("File content is empty.")
	else:
		print("Failed to open file for reading.")
	return false
	
func shuffle_array(arr: Array) -> Array:
	var shuffled_arr = arr.duplicate()
	var n = shuffled_arr.size()

	# Iterate through the array in reverse order
	for i in range(n - 1, 0, -1):
		# Generate a random index between 0 and i (inclusive)
		var j = randi() % (i + 1)
		
		# Swap elements at indices i and j
		var temp = shuffled_arr[i]
		shuffled_arr[i] = shuffled_arr[j]
		shuffled_arr[j] = temp
	
	return shuffled_arr

func extract_and_remove_first_n(arr: Array, n: int) -> Array:
	var extracted_elements = []
	
	# Iterate through the array and extract the first n elements
	for i in range(min(n, arr.size())):
		extracted_elements.append(arr[i])
	
	# Remove the extracted elements from the original array
	for i in range(min(n, arr.size())):
		arr.erase(arr.find(extracted_elements[i]))
	
	return extracted_elements

func shuffle_string(input_string: String) -> String:
	# Convert the string to an array of characters
	var char_array = []
	for char in input_string:
		char_array.append(char)

	# Shuffle the array
	char_array.shuffle()

	# Convert the shuffled array back to a string
	var shuffled_string = ""
	for char in char_array:
		shuffled_string += String(char)

	return shuffled_string
