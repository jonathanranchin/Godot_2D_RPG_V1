extends Node2D
var reserve_points = [ 6,6,0,0]
var characters = [
{ "strength": 1,"intellect": 1,"agility": 1,"charisma": 1},
{"strength": 1,"intellect": 1,"agility": 1,"charisma": 1},
{"strength": 1,"intellect": 1,"agility": 1,"charisma": 1},
{"strength": 1,"intellect": 1,"agility": 1,"charisma": 1}
]
var life_pools := [["",""],["",""],["",""],["",""]]
var action_deck := [[],[],[],[]]
var spellnums = [
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
]
var abilities = [
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
]
var names = ["Name1","Name2","Name3","Name4"]
# Function to handle LineEdit content change
func _on_line_edit_text_changed(new_text: String, characternum):
	# Update the string variable with the new content
	var string = "GridContainer/Character_"+str(characternum)+"_Container/Name_Container_"+str(characternum)+"/LineEdit"
	#get_node(string).text = new_text
	names[characternum] = new_text
	# Print the content for demonstration
	update_ui()

func _ready():
	#pass;
	update_ui()

func _on_increment_button_pressed(attribute,characterNum):
	#characterNum += 1
	var label = get_node("GridContainer/Character_"+str(characterNum+1)+"_Container/"+ attribute+"_Container_"+str(characterNum+1)+"/"+attribute+"_Label");
	var attribute_value = characters[characterNum][attribute]
	if (reserve_points[characterNum] > 0 and attribute_value < 4):
		attribute_value += 1
		#print(attribute_value);
		label.text = str(attribute_value)
		reserve_points[characterNum] -= 1
		characters[characterNum][attribute] = attribute_value
		update_ui()

func _on_decrement_button_pressed(attribute,characterNum):
	#characterNum += 1
	var label = get_node("GridContainer/Character_"+str(characterNum+1)+"_Container/"+ attribute+"_Container_"+str(characterNum+1)+"/"+attribute+"_Label");
	var attribute_value = characters[characterNum][attribute]
	if (attribute_value > 1):
		attribute_value -= 1
		label.text = str(attribute_value)
		reserve_points[characterNum] += 1
		characters[characterNum][attribute] = attribute_value
		update_ui()

func array_to_string(arr: Array) -> String:
	var s = ""
	var counter = 0
	for i in arr:
		s += String(i) + ","
		if(int(counter)%int(8)==0):
			s+= "\n"
		counter += 1
	return s

func update_ui():
	for n in range(1,5):
		var real = n-1
		var format_string = "%s: %o"
		var string1 = "GridContainer/Character_"+str(n)+"_Container/strength_Container_"+str(n)+"/strength_Label"
		get_node(string1).text = format_string % ["Strength", characters[real]["strength"]]
		var string2 = "GridContainer/Character_"+str(n)+"_Container/intellect_Container_"+str(n)+"/intellect_Label"
		get_node(string2).text = "Intellect: " + str(characters[real]["intellect"])
		var string3 = "GridContainer/Character_"+str(n)+"_Container/agility_Container_"+str(n)+"/agility_Label"
		get_node(string3).text = "Agility: " + str(characters[real]["agility"])
		var string4 = "GridContainer/Character_"+str(n)+"_Container/charisma_Container_"+str(n)+"/charisma_Label"
		get_node(string4).text = "Charisma: " + str(characters[real]["charisma"])
		var string5 = "GridContainer/Character_"+str(n)+"_Container/Reserve_Points_"+str(n)
		get_node(string5).text = "Reserve Points: " + str(reserve_points[real])
		generatedeck(characters[real]["strength"],characters[real]["intellect"],characters[real]["agility"],characters[real]["charisma"],real)
		var string6 = "GridContainer/Recap_Container/Character_Recaps/Character_"+str(n)+"_Recap"
		get_node(string6).text = "Character : "+str(n)+" : " + names[real] + "\nLife pool : "+life_pools[real][0]+"\n"
		get_node(string6).text += "Action deck : "+array_to_string(action_deck[real])+"\n"
		for m in range(1,5):
			if(spellnums[0]["T"+str(m)+"S"][0]>0):
				get_node(string6).text += "Spells : " +"Tier "+str(m)+" Spells" + " Draw " + str(spellnums[0]["T"+str(m)+"S"][0]) + " choose "+ str(spellnums[0]["T"+str(m)+"S"][1]) +"\n"
		for m in range(1,5):
			if(abilities[0]["T"+str(m)+"A"][0]>0):
				get_node(string6).text += "Abilities : " +"Tier "+str(m)+" Abilities" + " Draw " + str(abilities[0]["T"+str(m)+"A"][0]) + " choose "+ str(abilities[0]["T"+str(m)+"A"][1]) +"\n"
		if (n==4):
			if(reserve_points == [ 0,0,0,0] and names != ["","","",""] ):
				get_node("GridContainer/Character_4_Container/charisma_Container_4/Proceed Button").text += "Proceed with this Party\n To Pick Spells and Abilities\n And then to the adventure itself"

func add_lives(lives: int, character) -> void:
	for n in lives:
		life_pools[character][0] += "l"

func add_blocks(blocks: int, character) -> void:
	for n in blocks:
		life_pools[character][0] += "b"

func add_statuses(statuses: int, character) -> void:
	for n in statuses:
		life_pools[character][0] += "p"

#func add_shields(shields: int, character) -> void:
	#for n in shields:
		#life_pools[character][0] += "s"

func add_hp_cards(strength,agility,character):
	if(strength==1):
		add_lives(6,character)
		add_blocks(1,character)
	if(strength==2):
		add_lives(9,character)
		add_blocks(2,character)
	if(strength==3):
		add_lives(11,character)
		add_blocks(2,character)
	if(strength==4):
		add_lives(13,character)
		add_blocks(3,character)
	if(agility==1):
		add_statuses(1,character)
	if(agility==2):
		add_statuses(2,character)
	if(agility==3):
		add_statuses(2,character)
	if(agility==4):
		add_statuses(3,character)

func add_spell_cards(intellect, character) -> void:
	if(intellect==1):
		action_deck[character].append("T1C");
		spellnums[character]["T1S"] = [3,1]
	if(intellect==2):
		action_deck[character].append("T1C");
		action_deck[character].append("T1C");
		action_deck[character].append("T2C");
		spellnums[character]["T1S"] = [5,2]
		spellnums[character]["T2S"] = [3,1]
	if(intellect==3):
		action_deck[character].append("T1C");
		action_deck[character].append("T1C");
		action_deck[character].append("T1C");
		action_deck[character].append("T2C");
		action_deck[character].append("T2C");
		action_deck[character].append("T3C");
		spellnums[character]["T1S"] = [7,3]
		spellnums[character]["T2S"] = [5,2]
		spellnums[character]["T3S"] = [3,1]
	if(intellect==4):
		action_deck[character].append("T1C");
		action_deck[character].append("T1C");
		action_deck[character].append("T1C");
		action_deck[character].append("T1C");
		action_deck[character].append("T1C");
		action_deck[character].append("T2C");
		action_deck[character].append("T2C");
		action_deck[character].append("T2C");
		action_deck[character].append("T3C");
		action_deck[character].append("T3C");
		action_deck[character].append("T4C");
		spellnums[character]["T1S"] = [9,4]
		spellnums[character]["T2S"] = [7,3]
		spellnums[character]["T3S"] = [5,2]
		spellnums[character]["T4S"] = [3,1]

func add_attack_cards(agility, character) -> void:
	if(agility==1):
		action_deck[character].append("ATK");
		action_deck[character].append("ATK");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
	if(agility==2):
		action_deck[character].append("ATK");
		action_deck[character].append("ATK");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
	if(agility==3):
		action_deck[character].append("ATK");
		action_deck[character].append("ATK");
		action_deck[character].append("ATK");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
	if(agility==4):
		action_deck[character].append("ATK");
		action_deck[character].append("ATK");
		action_deck[character].append("ATK");
		action_deck[character].append("ATK");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");
		action_deck[character].append("YARD");

func add_abilities_cards(charisma, character) -> void:
	if(charisma==1):
		action_deck[character].append("AC");
		abilities[character]["T1A"] = [1,1]
	if(charisma==2):
		action_deck[character].append("AC");
		action_deck[character].append("AC");
		abilities[character]["T1A"] = [2,1]
		abilities[character]["T2A"] = [1,1]
	if(charisma==3):
		action_deck[character].append("AC");
		action_deck[character].append("AC");
		action_deck[character].append("AC");
		abilities[character]["T1A"] = [4,1]
		abilities[character]["T2A"] = [3,1]
		abilities[character]["T3A"] = [1,1]
	if(charisma==4):
		action_deck[character].append("AC");
		action_deck[character].append("AC");
		action_deck[character].append("AC");
		action_deck[character].append("AC");
		action_deck[character].append("AC");
		abilities[character]["T1A"] = [5,2]
		abilities[character]["T2A"] = [3,1]
		abilities[character]["T3A"] = [3,1]
		abilities[character]["T4A"] = [1,1]

func generatedeck(strength,intellect,agility,charisma,character):
	life_pools[character] = ["",""]
	action_deck[character] = []
	spellnums[character] =  { "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]}
	abilities[character] = { "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]}
	add_spell_cards(intellect,character)
	add_attack_cards(agility,character)
	add_abilities_cards(charisma,character)
	add_hp_cards(strength,agility,character)
	pass

func array_2_string(arr):
	return JSON.stringify(arr)

func load():
	var file = FileAccess.open("res://saves/party_data_1.tres", FileAccess.READ)
	var content = file.get_as_text()
	return content

func save(content):
	var file = FileAccess.open("res://saves/party_data_1.tres", FileAccess.WRITE)
	file.store_string(content)

func save_data():
	var data = {
		"characters": characters,
		"life_pools": life_pools,
		"action_deck": action_deck,
		"spellnums": spellnums,
		"abilities": abilities,
		"names": names
	}
	var json_string = JSON.stringify(data)
	save(json_string)

func _on_proceed_button_pressed():
	save_data()
	get_tree().change_scene_to_file("res://Menus/AddSpells&Abilities.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
