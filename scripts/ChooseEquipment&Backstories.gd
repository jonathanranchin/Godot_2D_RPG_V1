extends Node2D
var characters
var life_pools
var action_decks
var spells
var abilities
var names
var character_slots = [0,0,0,0]
var character_weapons = []
var character_armor = []
var character_backstory = []
var step = 0

var weapons = {
		"Light" :
				{
			"Tier_1" : [
				{"name":"Dagger","damage":2,"range":1,"price":"10","life_pool":"p","special":"backstab","Tier":1,"hands":1,"class":"Light"},
				{"name":"Short Sword","damage":2,"range":2,"price":"15","life_pool":"bp","special":false,"Tier":1,"hands":1,"class":"Light"}
				],
			"Tier_2" : [
				{"name":"Balanced Dagger","damage":2,"range":2,"price":"20","life_pool":"p","special":"backstab","Tier":2,"hands":1,"class":"Light"},
				{"name":"Quickblade","damage":2,"range":2,"price":"25","life_pool":"bbp","special":false,"Tier":2,"hands":1,"class":"Light"}
				],
			"Tier_3" : [
				{"name":"Elven Rapier","damage":3,"range":2,"price":"30","life_pool":"pp","special":"critical","Tier":3,"hands":1,"class":"Light"},
				{"name":"Swift Blade","damage":2,"range":2,"price":"35","life_pool":"bbpp","special":false,"Tier":3,"hands":1,"class":"Light"}
				],
			"Tier_4" : [
				{"name":"Legendary Assassin's Dagger","damage":5,"range":2,"price":"80","life_pool":"ppp","special":"backstab","Tier":4,"hands":1,"class":"Light"},
				{"name":"Fencer's Foil","damage":3,"range":2,"price":"65","life_pool":"bbbpp","special":false,"Tier":4,"hands":1,"class":"Light"}
				],
			},
		"Normal" :
			{
				"Tier_1" : [
					{"name":"Longsword","damage":2,"range":2,"price":"20","life_pool":"b","special":false,"Tier":1,"hands":1,"class":"Normal"},
					],
				"Tier_2" : [
					{"name":"War Axe","damage":3,"range":2,"price":"25","life_pool":"bb","special":"crash","Tier":2,"hands":2,"class":"Normal"},
					{"name":"Scimitar","damage":3,"range":2,"price":"25","life_pool":"bp","special":"critical","Tier":2,"hands":1,"class":"Normal"}
					],
				"Tier_3" : [
					{"name":"Flamberge","damage":4,"range":2,"price":"35","life_pool":"bpp","special":"critical","Tier":3,"hands":2,"class":"Normal"},
					{"name":"Halberd ","damage":4,"range":3,"price":"35","life_pool":"bb","special":false,"Tier":3,"hands":2,"class":"Normal"}
					],
				"Tier_4" : [
					{"name":"Masterwork Broadsword","damage":6,"range":2,"price":"70","life_pool":"ppp","special":false,"Tier":4,"hands":1,"class":"Normal"},
					{"name":"Executioner's Axe","damage":7,"range":2,"price":"65","life_pool":"bbb","special":"crush","Tier":4,"hands":2,"class":"Normal"},
					{"name":"War Spear","damage":5,"range":4,"price":"70","life_pool":"bbbp","special":"skewer","Tier":4,"hands":2,"class":"Normal"}
					],
			},
		"Heavy" :
			{
				"Tier_1" : [
					{"name":"Maul","damage":4,"range":1,"price":"30","life_pool":"bp","special":"crush","Tier":1,"hands":2,"class":"Heavy"},
					],
				"Tier_2" : [
					{"name":"War Hammer","damage":5,"range":2,"price":"35","life_pool":"bbp","special":"crush","Tier":2,"hands":3,"class":"Heavy"},
					],
				"Tier_3" : [
					{"name":"Greatsword","damage":6,"range":2,"price":"45","life_pool":"bppp","special":"critical","Tier":3,"hands":3,"class":"Heavy"},
					],
				"Tier_4" : [
					{"name":"Claymore ","damage":8,"range":2,"price":"70","life_pool":"bbpp","special":false,"Tier":4,"hands":3,"class":"Heavy"},
					],
			},
		"Shield" :
			{
				"Tier_1" : [
					{"name":"Buckler","damage":1,"range":1,"price":"15","life_pool":"bbp","special":"push","Tier":1,"hands":1,"class":"Shield"},
					{"name":"Small Wooden Shield","damage":0,"range":1,"price":"20","life_pool":"bbpp","special":"push","Tier":1,"hands":1,"class":"Shield"}
					],
				"Tier_2" : [
					{"name":"Round Shield","damage":1,"range":1,"price":"30","life_pool":"bbpp","special":"push","Tier":2,"hands":1,"class":"Shield"},
					{"name":"Kite Shield","damage":2,"range":1,"price":"30","life_pool":"bbpp","special":"push","Tier":2,"hands":1,"class":"Shield"}
					],
				"Tier_3" : [
					{"name":"Tower Shield","damage":3,"range":1,"price":"40","life_pool":"bbbpp","special":"push","Tier":3,"hands":1,"class":"Shield"},
					{"name":"Reinforced Bulwark","damage":1,"range":1,"price":"45","life_pool":"bbbbpp","special":"push","Tier":3,"hands":2,"class":"Shield"}
					],
				"Tier_4" : [
					{"name":"Great Aegis","damage":6,"range":1,"price":"65","life_pool":"bbbppp","special":"rend","Tier":4,"hands":2,"class":"Shield"},
					{"name":"Colossal Barrier","damage":1,"range":1,"price":"85","life_pool":"bbbbppp","special":"push","Tier":4,"hands":2,"class":"Shield"},
					],
			},
		"Super Heavy" :
			{
				"Tier_1" : [
					{"name":"Ogre Maul","damage":7,"range":1,"price":"60","life_pool":"bbb","special":"rend","Tier":1,"hands":3,"class":"Super Heavy"},
					],
				"Tier_2" : [
					{"name":"Goliath Greathammer","damage":8,"range":1,"price":"70","life_pool":"bbb","special":"crush","Tier":2,"hands":4,"class":"Super Heavy"},
					],
				"Tier_3" : [
					{"name":"Titan Blade","damage":9,"range":2,"price":"75","life_pool":"bbbp","special":"critical","Tier":3,"hands":4,"class":"Super Heavy"},
					],
				"Tier_4" : [
					{"name":"Colossus War Axe","damage":11,"range":2,"price":"90","life_pool":"bbpp","special":"split","Tier":4,"hands":4,"class":"Super Heavy"},
					],
			},
		"Magical" :
			{
				"Tier_1" : [
					{"name":"Wand","damage":1,"range":1,"price":"5","life_pool":"p","special":"Draw Cast 1","Tier":1,"hands":1,"class":"Magical"},
					],
				"Tier_2" : [
					{"name":"Staf","damage":2,"range":2,"price":"20","life_pool":"bp","special":"Draw Cast 2","Tier":2,"hands":1,"class":"Magical"},
					],
				"Tier_3" : [
					{"name":"Heavy Staf","damage":5,"range":2,"price":"35","life_pool":"bbbp","special":"Draw Cast 2","Tier":3,"hands":2,"class":"Magical"},
					],
				"Tier_4" : [
					{"name":"Blessed wand","damage":1,"range":1,"price":"90","life_pool":"psssss","special":"Draw Cast 3","Tier":4,"hands":1,"class":"Magical"},
					],
			}
	}
	
var armor = {
		"Cloth" :
				{
			"Tier_1" : [
				{"name":"Cloth Tunic","damage_reduction":0,"price":"10","life_pool":"","action_deck":"YARD"},
				],
			"Tier_2" : [
				{"name":"Cloth Tunic","damage_reduction":0,"price":"20","life_pool":"d","action_deck":"YARD"},
				],
			"Tier_3" : [
				{"name":"Enchanted Cloak","damage_reduction":0,"price":"40","life_pool":"dd","action_deck":"YARD"},
				],
			"Tier_4" : [
				{"name":"Arcane Vestments","damage_reduction":1,"price":"50","life_pool":"dd","action_deck":"YARD,YARD"},
				],
			},
		"Light" :
			{
			"Tier_1" : [
				{"name":"Leather Jerkin","damage_reduction":0,"price":"10","life_pool":"d","action_deck":""},
				],
			"Tier_2" : [
				{"name":"Studded Leather Armor","damage_reduction":0,"price":"20","life_pool":"dd","action_deck":""},
				],
			"Tier_3" : [
				{"name":"Elven Mail","damage_reduction":1,"price":"40","life_pool":"dd","action_deck":"YARD"},
				],
			"Tier_4" : [
				{"name":"Shadow Cloak","damage_reduction":1,"price":"50","life_pool":"ddd","action_deck":"YARD,YARD"},
				],
			},
		"Medium" :
			{
			"Tier_1" : [
				{"name":"Chainmail Hauberk","damage_reduction":1,"price":"20","life_pool":"dd","action_deck":"-YARD"},
				],
			"Tier_2" : [
				{"name":"Scalemail Vest","damage_reduction":1,"price":"30","life_pool":"ddd","action_deck":"-YARD"},
				],
			"Tier_3" : [
				{"name":"Dwarven Plate","damage_reduction":2,"price":"60","life_pool":"dddd","action_deck":"-YARD"},
				],
			"Tier_4" : [
				{"name":"Warlord's Harness","damage_reduction":2,"price":"100","life_pool":"dddd","action_deck":""},
				],
			},
		"Heavy" :
			{
			"Tier_1" : [
				{"name":"Plate Armor","damage_reduction":2,"price":"30","life_pool":"ddd","action_deck":"-YARD,-YARD"},
				],
			"Tier_2" : [
				{"name":"Knight's Plate","damage_reduction":2,"price":"50","life_pool":"dddd","action_deck":"-YARD,-YARD"},
				],
			"Tier_3" : [
				{"name":"Imperial Plate","damage_reduction":3,"price":"80","life_pool":"ddddd","action_deck":"-YARD,-YARD"},
				],
			"Tier_4" : [
				{"name":"Titan Forge Armor","damage_reduction":4,"price":"170","life_pool":"dddddd","action_deck":"-YARD,-YARD"},
				],
			},
		}

var backstories = {
		"Strength" :
				{
			"Tier_1" : [
				{"background":"Warrior's Heritage","alignement":"Lawful","trait":"strength","description":"You come from a lineage of formidable warriors, known for their physical prowess and indomitable spirit."},
				{"background":"Street Brawler","alignement":"Neutral","trait":"strength","description":"Growing up in tough neighborhoods, you learned to defend yourself through sheer strength and grit."},
				{"background":"Mercenary","alignement":"Chaotic","trait":"strength","description":"Your strength made you a valuable asset in battles for the highest bidder."},
				{"background":"Gladiator","alignement":"Neutral","trait":"strength","description":"Raised in the arena, you fought for the entertainment of others, honing your strength and endurance."},
				{"background":"Tribal Warrior","alignement":"Chaotic","trait":"strength","description":"Coming from a tribal culture, you were trained to defend your people and embrace physical prowess."},
				],
			},
		"Agility" :
			{
			"Tier_1" : [
				{"background":"Acrobat","alignement":"Lawful","trait":"agility","description":"Years of acrobatic training have granted you unparalleled speed and agility."},
				{"background":"Street Runner","alignement":"Neutral","trait":"agility","description":"Navigating the bustling streets and narrow alleys of the city honed your agility and quick thinking."},
				{"background":"Thief","alignement":"Chaotic","trait":"agility","description":"Your agility served you well in the shadows, helping you excel in pilfering and infiltration."},
				{"background":"Couriers Guild Member","alignement":"Lawful","trait":"agility","description":"You're a member of a prestigious guild that specializes in delivering messages quickly and discreetly."},
				{"background":"Daredevil","alignement":"Chaotic","trait":"agility","description":"Seeking thrills and excitement, you've embraced dangerous stunts and feats that showcase your agility."},
				],
			},
		"Intellect" :
			{
			"Tier_1" : [
				{"background":"Scholar","alignement":"Lawful","trait":"intellect","description":"Your thirst for knowledge led you to immerse yourself in books and magical lore."},
				{"background":"Street Mage","alignement":"Neutral","trait":"intellect","description":"You developed your magical abilities through trial and error on the streets, far from the halls of academia."},
				{"background":"Occultist","alignement":"Chaotic","trait":"intellect","description":"Delving into forbidden knowledge and ancient mysteries, you've embraced dark and arcane powers."},
				{"background":"Alchemist's Apprentice","alignement":"Lawful","trait":"intellect","description":"You learned the art of potion-making and alchemical secrets from a reclusive master."},
				{"background":"Seer","alignement":"Neutral","trait":"intellect","description":"Blessed with visions and foresight, you've honed your magical abilities to glean glimpses of the future."},
				],
			},
		"Charisma" :
			{
			"Tier_1" : [
				{"background":"Diplomat","alignement":"Lawful","trait":"intellect","description":"Your charismatic and logical nature led you to excel in negotiations and interpersonal relations."},
				{"background":"Street Hustler","alignement":"Neutral","trait":"intellect","description":"You honed your charm and wit navigating the intricate webs of city life and its diverse characters."},
				{"background":"Trickster","alignement":"Chaotic","trait":"intellect","description":"Your charisma and cunning make you a master manipulator, using your skills for your own amusement or profit."},
				{"background":"Courtier","alignement":"Lawful","trait":"intellect","description":"You've been groomed for courtly life, mastering the intricacies of etiquette and political manipulation."},
				{"background":"Charlatan","alignement":"Chaotic","trait":"intellect","description":"You delight in the chaos created by your schemes, prioritizing your interests."},
				],
			},
		}

# Called when the node enters the scene tree for the first time.
func _ready():
	loader()
	update_ui()

func loader():
	var file = FileAccess.open("res://saves/party_data_2.tres", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		if content:
			var data = JSON.parse_string(content)
			if data:
				characters = data["characters"]
				life_pools = data["life_pools"]
				action_decks = data["action_deck"]
				spells = data["spellnums"]
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

func update_ui():
	if(step==0):
		for n in range(0,4):
			var real = n+1
			characters[n]["name"] = names[n]
			characters[n]["life_pool"] = life_pools[n]
			characters[n]["action_deck"] = action_decks[n]
			characters[n]["spells"] = spells[n]
			characters[n]["abilities"] = abilities[n]
			characters[n]["weapons"] = []
			characters[n]["weapons_equiped"] = []
			characters[n]["armor"] = []
			characters[n]["backstory"] = []
			#print(characters[n])
			#print("\n")
			var hands = 0;
			for o in range(0,characters[n]["strength"]):
				hands += 1
			character_slots[n] = hands 
			var string2 = "GridContainer/GridContainer"+str(real)+"/BoxContainer/Label"
			get_node(string2).text += "Weapons for " + str(characters[n]["name"]) + " for : " + str(hands) + " slots "
			var characterweapons = weapon_finder(characters[n]["strength"],characters[n]["intellect"],characters[n]["agility"],characters[n]["charisma"])
			character_weapons.append(characterweapons)
			#character_weapons = flatten_array(character_weapons)
			#print(character_weapons)
			var string3 = "GridContainer/GridContainer"+str(real)
			for m in range(0,characterweapons.size()):
				#for p in range(0,characterweapons[m].size()):
					var label = Label.new()
					label.text =  str(characterweapons[m]["name"]) + " Damage : " + str(characterweapons[m]["damage"]) + " Price : " +  str(characterweapons[m]["price"])+ "\nRange :" +  str(characterweapons[m]["range"]) + " Life Pool Modif : " +  str(characterweapons[m]["life_pool"]) + " Special : " + str(characterweapons[m]["special"]) + "\n Slot cost : " + str(characterweapons[m]["hands"])
					var button = Button.new()
					button.text = "Choose the " + str(characterweapons[m]["name"])
					var parent_node = get_node(string3)
					parent_node.add_child(label)
					parent_node.add_child(button)
					#button.connect("pressed", on_weapon_button_pressed(n),2)
					button.pressed.connect(self.on_weapon_button_pressed.bind(m,characterweapons[m]["name"],n))
	if(step==1):
		print(step)
		for n in range(0,4):
			var real = n+1
			var hands = 1
			character_slots[n] = hands
			var string2 = "GridContainer2/GridContainer"+str(real)+"/BoxContainer/Label"
			get_node(string2).text += "Armor for " + str(characters[n]["name"]) + " for : " + str(hands) + " slots "
			var characterweapons = armor_finder(characters[n]["strength"],characters[n]["agility"])
			character_armor.append(characterweapons)
			var string3 = "GridContainer2/GridContainer"+str(real)
			for m in range(0,characterweapons.size()):
				#for p in range(0,characterweapons[m].size()):
					var label = Label.new()
					#print(characterweapons)
					label.text =  str(characterweapons[m]["name"]) + " Damage Reduction : " + str(characterweapons[m]["damage_reduction"]) + " Price : " +  str(characterweapons[m]["price"])+ "\nLife pool Modif : " +  str(characterweapons[m]["life_pool"]) + " Action deck Mod : " + str(characterweapons[m]["action_deck"])
					var button = Button.new()
					button.text = "Choose the " + str(characterweapons[m]["name"])
					var parent_node = get_node(string3)
					parent_node.add_child(label)
					parent_node.add_child(button)
					#button.connect("pressed", on_weapon_button_pressed(n),2)
					button.pressed.connect(self.on_weapon_button_pressed.bind(m,characterweapons[m]["name"],n))
	if(step==2):
		print(step)
		for n in range(0,4):
			var real = n+1
			var hands = 1
			character_slots[n] = hands
			var string2 = "GridContainer3/GridContainer"+str(real)+"/BoxContainer/Label"
			get_node(string2).text += "Backstories for " + str(characters[n]["name"]) + " for : " + str(hands) + " slots "
			var characterweapons = backstory_finder(characters[n]["strength"],characters[n]["intellect"],characters[n]["agility"],characters[n]["charisma"])
			character_backstory.append(characterweapons)
			var string3 = "GridContainer3/GridContainer"+str(real)
			for m in range(0,characterweapons.size()):
				#for p in range(0,characterweapons[m].size()):
					var label = Label.new()
					#print(characterweapons)
					label.text =  str(characterweapons[m]["background"]) + " -> Alignement : " + str(characterweapons[m]["alignement"]) + "\n Description : " +  str(characterweapons[m]["description"])
					var button = Button.new()
					button.text = "Choose the " + str(characterweapons[m]["background"])
					var parent_node = get_node(string3)
					parent_node.add_child(label)
					parent_node.add_child(button)
					#button.connect("pressed", on_weapon_button_pressed(n),2)
					button.pressed.connect(self.on_weapon_button_pressed.bind(m,characterweapons[m]["background"],n))

func weapon_finder(strength,intellect,agility,charisma):
	var result = []
	result.append(weapons["Normal"]["Tier_1"])
	if(charisma>=2):
		result.append(weapons["Shield"]["Tier_1"])
	if(strength>=2 and agility >= 2):
		result.append(weapons["Light"]["Tier_1"])
	if(strength>=3 and agility >= 2):
		result.append(weapons["Heavy"]["Tier_1"])
	if(strength>=4 and agility >= 2):
		result.append(weapons["Super Heavy"]["Tier_1"])
	if(intellect>=2):
		result.append(weapons["Magical"]["Tier_1"])
	return flatten_array(result)

func armor_finder(strength,agility):
	var result = []
	result.append(armor["Cloth"]["Tier_1"])
	if(strength>=2 and agility >= 3):
		result.append(armor["Light"]["Tier_1"])
	if(strength>=2 and agility >= 2):
		result.append(armor["Medium"]["Tier_1"])
	if(strength>=4):
		result.append(armor["Heavy"]["Tier_1"])
	return flatten_array(result)

func backstory_finder(strength,intellect,agility,charisma):
	var result = []
	if(agility>=3):
		result.append(backstories["Agility"]["Tier_1"])
	if(charisma>=3):
		result.append(backstories["Charisma"]["Tier_1"])
	if(strength>=3):
		result.append(backstories["Strength"]["Tier_1"])
	if(intellect>=3):
		result.append(backstories["Intellect"]["Tier_1"])
	return flatten_array(result)

func flatten_array(arr):
	var flat_array = []
	for item in arr:
		if item is Array:
			flat_array += flatten_array(item)
		else:
			flat_array.append(item)
	return flat_array

func on_weapon_button_pressed(m,weapon_name,n):
	var real = n+1
	if(character_slots[n]>0):
		print("Button clicked! "+ str(m) + " "+ str(weapon_name) + " step " +str(step))
		if(step==1 or step == 2):
			character_slots[n] = 0
		if(step==0 and character_slots[n] >= int(character_weapons[n][m]["hands"])):
			character_slots[n] -= int(character_weapons[n][m]["hands"])
		#print(character_weapons[n][m])
		if( step == 0):
			if(characters[n]["weapons_equiped"].size()<2):
				characters[n]["weapons_equiped"].append(character_weapons[n][m])
			characters[n]["weapons"].append(character_weapons[n][m])
			var string2 = "GridContainer/GridContainer"+str(real)+"/BoxContainer/Label"
			get_node(string2).text = "Weapons for " + str(characters[n]["name"]) + " for : " + str(character_slots[n]) + " slots "
		if( step == 1):
			print(character_slots[n])
			characters[n]["armor"].append(character_armor[n][m])
			var string2 = "GridContainer2/GridContainer"+str(real)+"/BoxContainer/Label"
			get_node(string2).text = "Armor for " + str(characters[n]["name"]) + " for : " + str(character_slots[n]) + " slots "
		if( step == 2):
			characters[n]["backstory"].append(character_backstory[n][m])
			var string2 = "GridContainer3/GridContainer"+str(real)+"/BoxContainer/Label"
			get_node(string2).text = "Backstory for " + str(characters[n]["name"]) + " for : " + str(character_slots[n]) + " slots "
			var string3 = "GridContainer3/GridContainer"+str(real)
			get_node(string3).hide()
	if(character_slots==[0,0,0,0] and step ==0):
		print("All characters have weapons !")
		var string2 = "GridContainer"
		step = 1
		#print(characters[n]["weapons_equiped"])
		get_node(string2).hide()
		update_ui()
	if(character_slots==[0,0,0,0] and step ==1):
		for j in range (0,4):
			print(characters[j]["armor"])
		var string2 = "GridContainer2"
		step = 2
		get_node(string2).hide()
		update_ui()
	if(character_slots==[0,0,0,0] and step == 2):
		for j in range (0,4):
			print(characters[j])
		var string2 = "GridContainer3"
		step = 2
		get_node(string2).hide()
		save_data()
		get_tree().change_scene_to_file("res://Levels/Level1.tscn")
		#update_ui()

func save_data():
	var data = {
		"characters": characters,
	}
	var json_string = JSON.stringify(data)
	save(json_string)

func save(content):
	var file = FileAccess.open("res://saves/party_data_3.tres", FileAccess.WRITE)
	file.store_string(content)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
