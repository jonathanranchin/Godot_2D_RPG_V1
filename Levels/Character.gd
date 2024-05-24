extends CharacterBody2D

const SPEED = 96.0
var movecapital = 500 # Is set trhough action deck
var attacks = 70 # Animation timer for attacking
var casty = 70 # Animation timer for casting
var acty = 70 # Animation timer for acting
var attack_pool = 3
var actions
var casts = [0,0,0,0]
var attacking # animation keyword
var casting = 1 # animation keyword
var acting # animation keyword
var previous_position = Vector2.ZERO
var chara #stores all characters (allies)
var enemies #stores all enemies
var local #stores each character values
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D
var range_array = [30,35,40,46,56,65,75,85,95,105,115,124,134,144] # 14 ranges
var spell_ranges = [0,24,48,72,96,120,144,168,192,216,240,264,288,312] # 14 ranges
var move_array = [10,22,43,64,85,106,127,148,169,190,203] # 10 move length
var attack_target #Stores target for attacking
var check = false
var in_attack_range = false
var offensive_weapon #stores weapon for attack
var usable_spells = [] # Gets spells depending on casts available
var checked_spell # Stores spells
var chosen_spell # Stores active spell
var spell_target # Spells target either single or array
var warp_direction # TO DO
var usable_actions = [] #get actions if they are available
var checked_actions
var chosen_action
var action_target
var healed # animation keyword
var shield_active = 0
var shielded # animation keyword
var struck # animation keyword
var buffed # animation keyword
var debuffed # animation keyword
var populate = "spells"
var status = "alive"
# life pool is stored in this variable local["life_pool"] 0 is theoretical and 1 is current

func _ready():
	attacks = 70

func show_chara_stats(charac):
	#local = charac
	if(local!=null):
		categorize_cards(local["action_hand"])
		var string5 = "../../Active_Character/Label2"
		get_node(string5).text = str(local["name"])
		string5 = "../../Active_Character/Label4"
		get_node(string5).text = "Move points : "+str(movecapital) +'\n'
		string5 = "../../Active_Character/Label3"
		get_node(string5).text = "Action uses : "+str(actions) +'\n'
		string5 = "../../Active_Character/Label5"
		get_node(string5).text = "Casts : " + str(casts)+'\n'
		string5 = "../../Active_Character/Label6"
		get_node(string5).text = "Attacks : " + str(attack_pool)+'\n'
		#if check == false:
		populate_actions()
		populate_spells()
				#check = true 

func populate_spells():
	var displayed = false
	for n in range(0, 4):
		var real = n+1
		var string2 = "../../GridContainer/Label"
		var label_node = get_node(string2)
		if populate == "spells":
			label_node.text = "Spells"
		var string3 = "../../Spell_cont_t"+str(real)
		var string4 = "../../GridContainer/Button"+str(real)
		var parent_node = get_node(string3)
		if casts[n]>0:
			if parent_node.get_children().size()==0:
				for m in range(0,local["spells"][n].size()):
					var button = Button.new()
					button.text = str(local["spells"][n][m]["name"])
					parent_node.add_child(button)
					usable_spells.append(local["spells"][n][m])
					button.pressed.connect(self.on_target_spell_button_pressed.bind(spell_ranges[local["spells"][n][m]["range"][1]],spell_ranges[local["spells"][n][m]["range"][0]],local["spells"][n][m]))
		if casts[n] == 0:
			var btn_node = get_node(string4)
			btn_node.hide()
			parent_node.hide()
		else:
			var btn_node = get_node(string4)
			btn_node.show()
			if(displayed == false):
				parent_node.show()
				displayed = true
			else:
				parent_node.hide()

func populate_actions():
	if actions > 0:
		for n in range(0, 4):
			var real = n+1
			var string3 = "../../Action_cont_t"+str(real)
			var parent_node = get_node(string3)
			if actions>0:
				if parent_node.get_children().size()==0:
					for m in range(0,local["abilities"][n].size()):
						var button = Button.new()
						button.text = str(local["abilities"][n][m]["name"])
						parent_node.add_child(button)
						usable_actions.append(local["abilities"][n][m])
						button.pressed.connect(self.on_target_action_button_pressed.bind(spell_ranges[local["abilities"][n][m]["range"][1]],spell_ranges[local["abilities"][n][m]["range"][0]],local["abilities"][n][m]["target/test"][0],local["abilities"][n][m]))
						if populate == "actions":
							parent_node.show()
						else:
							parent_node.show()
			if populate == "actions":
				parent_node.show()
			else:
				parent_node.hide()

func on_target_spell_button_pressed(max_range,min_range,spell):#spell is complete
	if self == get_parent().get_parent().active_character:
		var arr = []
		var all = chara + enemies
		arr.append(range_finder(all,max_range,min_range,spell["type"]))
		#for enemy in enemies:
			#arr.append(range_finder(enemies,max_range,min_range,spell["type"]))
		print( str(max_range)+' '+str(min_range)+' '+str(spell["type"])+' '+str(enemies) )
		print(arr)
		in_attack_range = true
		#spell_target = attacked #chosen_spell = spell
		var button = Button.new()
		var string4 = "../../Spells_and_abilities/Spell_Container"
		var parent_node = get_node(string4)
		for m in parent_node.get_children():
						parent_node.remove_child(m)
						m.queue_free()
		button.text = str(spell["name"]+'\nTargets: '+str(arr[0].size()))
		parent_node.add_child(button)
		button.pressed.connect(self.spell_bind_chooser.bind(spell,arr))

func on_target_action_button_pressed(max_range,min_range,action):
	if self == get_parent().get_parent().active_character:
		var arr = []
		var all = chara + enemies
		arr.append(range_finder(all,max_range,min_range,action["target/test"][0]))
		print( str(max_range)+' '+str(min_range)+' '+str(action["target/test"][0])+' '+str(enemies) )
		print(arr)
		in_attack_range = true
		#spell_target = attacked #chosen_spell = spell
		var button = Button.new()
		var string4 = "../../Spells_and_abilities/Ability_Container"
		var parent_node = get_node(string4)
		for m in parent_node.get_children():
						parent_node.remove_child(m)
						m.queue_free()
		button.text = str(action["name"]+'\nTargets: '+str(arr[0].size()))
		parent_node.add_child(button)
		button.pressed.connect(self.action_bind_chooser.bind(action,arr))
		pass

func action_bind_chooser(spell,targets):
	checked_actions = spell
	if spell["name"] == "Inspirational Address" or spell["name"] == "Unified Purpose":
		spell_target = targets #chara
		if spell["name"] == "Inspirational Address":
			action_target = chara
		print(spell["name"] + " has "+ str(targets) + " as targets")
		var button = Label.new()
		var string4 = "../../Spells_and_abilities/Ability_Container"
		var parent_node = get_node(string4)
		for target in targets:
			button.text += "Added all in\ntargets range !"
		parent_node.add_child(button)
	else:
		for target in targets[0]:
			var button = Button.new()
			var string4 = "../../Spells_and_abilities/Ability_Container"
			var parent_node = get_node(string4)
			button.text = str(target.name)
			parent_node.add_child(button)
			button.pressed.connect(self.action_target_chooser.bind(target))
		pass
	pass

func spell_bind_chooser(spell,targets):
	checked_spell = spell
	if spell["name"] == "Shielding Aura" or spell["name"] == "Celestial Reckoning" or spell["name"]== "Frost Nova" or spell["name"] == "Inferno Burst":
		spell_target = targets
		print(spell["name"] + " has "+ str(targets) + " as targets")
		var button = Label.new()
		var string4 = "../../Spells_and_abilities/Spell_Container"
		var parent_node = get_node(string4)
		for target in targets:
			button.text += "Added all in\ntargets range !"
		parent_node.add_child(button)
	else:
		for target in targets[0]:
			var button = Button.new()
			var string4 = "../../Spells_and_abilities/Spell_Container"
			var parent_node = get_node(string4)
			button.text = str(target.name)
			parent_node.add_child(button)
			button.pressed.connect(self.spell_target_chooser.bind(target))
		if checked_spell["name"] == "Astral Step":
			var directions = ["top","right","bot","left"]
			for n in range (0,4):
				var button2 = Button.new()
				button2.text = str(directions[n])
				var string4 = "../../Spells_and_abilities/Spell_Container"
				var parent_node = get_node(string4)
				parent_node.add_child(button2)
				button2.pressed.connect(self.warp_direction_choice.bind(directions[n]))
		pass
	pass

func action_target_chooser(target):
	action_target = target
	var button = Label.new()
	var string4 = "../../Spells_and_abilities/Ability_Container"
	var parent_node = get_node(string4)
	button.text += checked_actions["name"]+ " has \n"+ str(action_target.name) + "\nas target"
	parent_node.add_child(button)
	print(checked_actions["name"]+ " has "+ str(action_target.name) + " as target")

func spell_target_chooser(target):
	spell_target = target
	var button = Label.new()
	var string4 = "../../Spells_and_abilities/Spell_Container"
	var parent_node = get_node(string4)
	button.text += checked_spell["name"]+ " has \n"+ str(spell_target.name) + "\nas target"
	parent_node.add_child(button)

func warp_direction_choice(choice):
	warp_direction = choice
	var button = Label.new()
	var string4 = "../../Spells_and_abilities/Spell_Container"
	var parent_node = get_node(string4)
	button.text += checked_spell["name"]+ " has\n"+ str(choice) + " as direction"
	parent_node.add_child(button)
	print(checked_spell["name"]+ " has "+ str(choice) + " as direction")

func change_spell_tier(tier):
	for n in range(1, 5):
		var string4 = "../../Spell_cont_t"+str(n)
		var node = get_node(string4)
		node.hide()
	var string3 = "../../Spell_cont_t"+str(tier)
	var parent_node = get_node(string3)
	parent_node.show()

func cycle_spells_actions():
	var to_populate = populate
	if(to_populate=="spells"):
		var string2 = "../../GridContainer/Label"
		var label_node = get_node(string2)
		label_node.text = "Actions"
		populate = "actions"
		for n in range(1, 5):
			var string4 = "../../Spell_cont_t"+str(n)
			var string5 = "../../GridContainer/Button" + str(n)
			var node = get_node(string4)
			var node2 = get_node(string5)
			node.hide()
			node2.hide()
		for n in range(1, 5):
			var string4 = "../../Action_cont_t"+str(n)
			var node = get_node(string4)
			node.show()
	if(to_populate=="actions"):
		var string2 = "../../GridContainer/Label"
		var label_node = get_node(string2)
		label_node.text = "Spells"
		populate = "spells"
		var count = 0
		for n in range(1, 5):
			var string4 = "../../Spell_cont_t"+str(n)
			var node = get_node(string4)
			var string5 = "../../GridContainer/Button" + str(n)
			var node2 = get_node(string5)
			var real = n-1
			categorize_cards(get_parent().get_parent().active_character.local["action_hand"])
			if self.casts[real] >= 1 and count == 0:
				node.show()
				node2.show()
				#print(self.casts)
				count += 1
			else:
				if self.casts[real] >= 1:
					#print(casts)
					node2.show()
					node.hide()
		for n in range(1, 5):
			var string4 = "../../Action_cont_t"+str(n)
			var node = get_node(string4)
			node.hide()
		#print("____________")

func cast_spells(spell,caster,targets) ->bool:
	casting = true
	#$AnimatedSprite2D.play("casting")
	if casty > 0:
		$AnimatedSprite2D.play("casting")
		if spell["type"]=="HEAL":
			if targets is CharacterBody2D:
				targets.healed = 1
			else:
				for target in targets[0]:
					target.healed = 1
		if spell["type"]=="SHD":
			if targets is CharacterBody2D:
				targets.shielded = 1
				targets.shield_active = 1
			else:
				for target in targets[0]:
					target.shielded = 1
					target.shield_active = 1
		if spell["type"]=="ATK":
			if targets is CharacterBody2D:
				print("struck")
				#targets.struck = 1
			else:
				for target in targets[0]:
					print("struck")
					#target.struck = 1
		casty -= 1
		return false
	if casty == 0:
		casting = false
		casty = 70
		spell_target = null
		checked_spell = null
		if spell["name"] == "Minor Heal" and targets is CharacterBody2D:
			targets.gain_to_life_pool(3,0,0,0,0);
		if spell["name"] == "Stone Skin" and targets is CharacterBody2D:
			targets.gain_to_life_pool(0,0,0,3,0);
		if spell["name"] == "Mystic Shield" and targets is CharacterBody2D:
			targets.gain_to_life_pool(0,0,0,4,0);
		if spell["name"] == "Elemental Shield" and targets is CharacterBody2D:
			targets.gain_to_life_pool(0,0,0,7,0);
		if spell["name"] == "Shielding Aura" and targets.size()>=1: 
			for target in targets[0]: #need to sort allies and ennemies
				target.gain_to_life_pool(0,0,0,1,0);
		if spell["name"] == "Celestial Reckoning" and targets.size()>=1:
			for target in targets[0]: #need to sort allies and ennemies
				target.gain_to_life_pool(1,0,0,4,0);
				target.take_damage(8,"magic")
		if spell["name"] == "Arcane Bolt" and targets is CharacterBody2D:
			targets.take_damage(3,"magic")
		if spell["name"] == "Elemental Dart" and targets is CharacterBody2D:
			targets.take_damage(3,"magic")
		if spell["name"] == "Life Siphon" and targets is CharacterBody2D:
			targets.take_damage(5,"magic")
			caster.gain_to_life_pool(5,0,0,0,0);
		if spell["name"] == "Frost Nova" and targets.size()>=1:
			for target in targets[0]: #need to sort allies and ennemies
				target.take_damage(2,"magic")
				target.lose_to_action_hand(0,1,0,0,0,0,0,0)
		if spell["name"] == "Astral Step" and targets is CharacterBody2D:
				targets.warp(2,warp_direction)
				targets.gain_to_action_hand(0,0,0,0,0,0,0,1)
		if spell["name"] == "Energy Surge" and targets is CharacterBody2D:
				targets.gain_to_action_hand(0,0,0,1,0,0,0,0)
				if(local["intellect"]>2):
					targets.gain_to_action_hand(0,0,0,0,1,0,0,0)
		if spell["name"] == "Break Morale" and targets.size()>=1:
			for target in targets: #need to sort allies and ennemies
				target[0].lose_to_action_hand(0,0,0,0,0,0,0,3)
		if spell["name"] == "Inferno Burst" and targets.size()>=1:
			for target in targets[0]: #need to sort allies and ennemies
				target.take_damage(6,"magic")
		if(spell["tier"]=="1"):
			casts[0] -= 1
			print(casts)
			local["action_hand"] = remove_first_card(local["action_hand"], "T1C")
			print(local["action_hand"])
		if(spell["tier"]=="2"):
			casts[1] -= 1
			local["action_hand"] = remove_first_card(local["action_hand"], "T2C")
		if(spell["tier"]=="3"):
			casts[2] -= 1
			local["action_hand"] = remove_first_card(local["action_hand"], "T3C")
		if(spell["tier"]=="4"):
			casts[3] -= 1
			local["action_hand"] = remove_first_card(local["action_hand"], "T4C")
		var string5 = "../../Active_Character/Label5"
		get_node(string5).text = "Casts : " + str(casts)+'\n'
		populate_spells()
		var string4 = "../../Spells_and_abilities/Spell_Container"
		var parent_node = get_node(string4)
		for m in parent_node.get_children():
						parent_node.remove_child(m)
						m.queue_free()
		print("Cast Complete")
		$AnimatedSprite2D.animation = "default"
		if targets is CharacterBody2D:
			targets.healed = 0
			targets.struck = 0
			targets.shielded = 0
			var target_sprite = targets.get_node("AnimatedSprite2D")
			target_sprite.play("default")
		else:
			for target in targets[0]:
				target.healed = 0
				target.struck = 0
				target.shielded = 0
				var target_sprite = target.get_node("AnimatedSprite2D")
				target_sprite.play("default")
		return true
	return false

func use_action(action,actor,targets) -> bool:
	acting = true
	print(acty)
	print(action["target/test"][0])
	if acty > 0 and action["target/test"][0]=="Ally":
		#$AnimatedSprite2D.play("acting_positive")
		$AnimatedSprite2D.animation = "acting_positive"
		if targets is CharacterBody2D:
			targets.buffed = 1
		else:
			for target in targets[0]:
				target.buffed = 1
		acty -= 1
		return false
	if acty>0 and action["target/test"][0]=="Enemy":
		print("de_buffing")
		$AnimatedSprite2D.play("acting_negative")
		#$AnimatedSprite2D.animation = "acting_positive"
		if targets is CharacterBody2D:
			targets.debuffed = 1
		else:
			for target in targets[0]:
				target.debuffed = 1
		acty -= 1
		return false
	if acty == 0 or acty > 0:
		acting = false
		acty = 70
		return true
	return false

func warp(meters,direction): #neeed to research
	print(position)
	#var position = Vector2(position[0] + spell_ranges[meters-1], position[1])
	var new_position
	if direction == 'bot':
		new_position = Vector2(position[0], position[1] + spell_ranges[meters])
	elif direction == 'top':
		new_position = Vector2(position[0], position[1] - spell_ranges[meters])
	elif direction == 'right':
		new_position = Vector2(position[0] + spell_ranges[meters], position[1])
	elif direction == 'left':
		new_position = Vector2(position[0] - spell_ranges[meters], position[1])
	position = new_position
	print(position)
	$AnimatedSprite2D.animation = "default"
	pass

func gain_to_life_pool(lives,blocks,parries,shields,buffs): #Todo *4
	if lives>0:
		if lifepool_checker(local["life_pool"][1],"l")< lifepool_checker(local["life_pool"][0],"l"):
			if lifepool_checker(local["life_pool"][0],"l") - (lifepool_checker(local["life_pool"][1],"l") + lives) <= 0:
				for life in lives:
					local["life_pool"][1] += "l"
			else: 
				var missing_life = lifepool_checker(local["life_pool"][0],"l") - lifepool_checker(local["life_pool"][1],"l")
				for life in missing_life:
					local["life_pool"][1] += "l"
		else:
			print("Character has full lifepoints and cannot be healed")
			return
		print(local["life_pool"][1])
		return
	if blocks>0:
		if lifepool_checker(local["life_pool"][1],"b")< lifepool_checker(local["life_pool"][0],"b")+1:
			if lifepool_checker(local["life_pool"][0],"b")+1 - (lifepool_checker(local["life_pool"][1],"b") +blocks) <= 0:
				for blockss in blocks:
					local["life_pool"][1] += "b"
			else: 
				var missing_blocks = (lifepool_checker(local["life_pool"][0],"b")+1) - lifepool_checker(local["life_pool"][1],"b")
				for blockss in missing_blocks:
					local["life_pool"][1] += "b"
		else:
			print("Character has full blocks and cannot get anymore")
			return
		print(local["life_pool"][1])
		return
	if parries>0:
		if lifepool_checker(local["life_pool"][1],"p")< lifepool_checker(local["life_pool"][0],"p")+4:
			if lifepool_checker(local["life_pool"][0],"p")+4 - (lifepool_checker(local["life_pool"][1],"p")+ parries) <= 0:
				for blockss in parries:
					local["life_pool"][1] += "p"
			else: 
				var missing_parries = (lifepool_checker(local["life_pool"][0],"p")+4) - lifepool_checker(local["life_pool"][1],"p")
				for blockss in missing_parries:
					local["life_pool"][1] += "p"
		else:
			print("Character has maximum parries and cannot get anymore")
			return
		print(local["life_pool"][1])
		return
	if shields>0:
		if local["life_pool"][1].length()< local["life_pool"][0].length()*2:
			if local["life_pool"][0].length()*2 - (local["life_pool"][1].length() + shields) <= 0:
				for blockss in shields:
					local["life_pool"][1] += "s"
			else: 
				for blockss in shields/2:
					local["life_pool"][1] += "s"
		else:
			print("Character has maximum shields and cannot get anymore")
			return
		print(local["life_pool"][1])
		return
	if buffs>0:
		if lifepool_checker(local["life_pool"][1],"u")< lifepool_checker(local["life_pool"][0],"u")+3:
			if lifepool_checker(local["life_pool"][0],"u")+3 - (lifepool_checker(local["life_pool"][1],"u")+ parries) <= 0:
				for blockss in buffs:
					local["life_pool"][1] += "u"
			else: 
				var missing_parries = (lifepool_checker(local["life_pool"][0],"u")+3) - lifepool_checker(local["life_pool"][1],"u")
				for blockss in missing_parries:
					local["life_pool"][1] += "u"
		else:
			print("Character has maximum buffs and cannot get anymore")
			return
		print(local["life_pool"][1])
		return
	print(local["life_pool"][1])
	return

#not implemented to characters (must be added to enemies for alpha)
func lose_to_life_pool(lives,blocks,parries,shields,buffs):
	if lives>0:
		pass
	if blocks>0:
		pass
	if parries>0:
		pass
	if shields>0:
		pass
	if buffs>0:
		pass
	print(local["life_pool"][1])

func gain_to_action_hand(yards,move,action_cards,T1casts,T2casts,T3casts,T4casts,random):
	if yards>0:
		for yard in yards:
			movecapital += 15
	if move>0:
		for yard in move:
			movecapital += 25
	if action_cards>0:
		for ac in action_cards:
			actions += 1
	if T1casts>0:
		for T1C in T1casts:
			casts[0] +=1
	if T2casts>0:
		for T2C in T2casts:
			casts[1] +=1
	if T3casts>0:
		for T3C in T3casts:
			casts[2] +=1
	if T4casts>0:
		for T4C in T4casts:
			casts[3] +=1
	if random>0:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		for ran in random:
			var random_number = rng.randi_range(0, 59)
			if random_number < 10 and random_number >=0:
				movecapital += 25
			if random_number < 20 and random_number >=10:
				actions += 1
			if random_number < 30 and random_number >=20:
				casts[0] +=1
			if random_number < 40 and random_number >=30:
				casts[1] +=1
			if random_number < 50 and random_number >=40:
				casts[2] +=1
			if random_number < 60 and random_number >=50:
				casts[3] +=1
	print(local["action_hand"])
	print(str(local["action_pool"][0].size())+' '+str(local["action_pool"][1].size()))
	print("Action gain")

func lose_to_action_hand(yards,move,action_cards,T1casts,T2casts,T3casts,T4casts,random):
	if yards>0:
		pass
	if move>0:
		pass
	if action_cards>0:
		pass
	if T1casts>0:
		pass
	if T2casts>0:
		pass
	if T3casts>0:
		pass
	if T4casts>0:
		pass
	if random>0:
		pass
	print(local["action_hand"])
	print(str(local["action_pool"][0].size())+' '+str(local["action_pool"][1].size()))
	print("Action lost")
	pass

func draw_card_deck_hand():
	print(local["action_hand"])
	print(str(local["action_pool"][0].size())+' '+str(local["action_pool"][1].size()))
	print("Draw done")
	pass

func take_damage(damage_amount,special):
	var random = RandomNumberGenerator.new()  # Create a random number generator
	random.randomize()  # Seed the RNG with a random value

	# Convert the life pool string into an array for easier manipulation
	var life_pool_array = []
	for char in local["life_pool"][1]:
		life_pool_array.append(char)

	# Randomly remove 'damage_amount' characters from the life pool
	while damage_amount > 0 and len(life_pool_array) > 0:
		var index = random.randi_range(0, len(life_pool_array) - 1)  # Get a random index
		var blocked = false
		var parried = false
		if special == "critical" and life_pool_array[index]=="l":
			damage_amount += 1 
			pass
		print(life_pool_array[index])
		if(life_pool_array[index]=="p"):
			parried = true
		if(life_pool_array[index]=="b"):
			blocked = true
		life_pool_array.remove_at(index)  # Remove the character at the random index
		damage_amount -= 1  # Decrement the damage amount
		if blocked==true and special != "rend":
			break
		if life_pool_array.size() == 0:
			$AnimatedSprite2D.animation = "death"
			while $AnimatedSprite2D.is_playing():
				await(get_tree().create_timer(0.1).timeout)
			$CollisionShape2D.set_deferred("disabled", true)
			$AnimatedSprite2D.stop()
			status = "dead"
			return "Dead"
	# Convert the modified array back to a string
	local["life_pool"][1] = "".join(life_pool_array)

	# Check if there are any 'l' characters left in the updated life pool
	if 'l' not in local["life_pool"][1]:
		$AnimatedSprite2D.animation = "death"
		while $AnimatedSprite2D.is_playing():
			await(get_tree().create_timer(0.1).timeout)
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.stop()
		status = "dead"
		return "Dead"
	print(local["life_pool"][1])
	return local["life_pool"][1]  # Otherwise, return the updated life pool

# used for hand processing
func categorize_cards(card_array):
	var move = 0
	var atk = 0
	var action = 0
	var spl = [0,0,0,0]
	for card in card_array:
		if card == "YARD":
			move += 1
			remove_first_card(local["action_hand"], "YARD")
		if card == "-YARD" or card == "-YARD,-YARD":
			if(move>0):
				move -= 1
			#yard_cards.append(card)
		elif card.begins_with("T") and card.ends_with("C"):
			if(card == "T1C"):
				spl[0] += 1
			if(card == "T2C"):
				spl[1] += 1
			if(card == "T3C"):
				spl[2] += 1
			if(card == "T4C"):
				spl[3] += 1
			#cast_cards.append(card)
		elif card == "AC":
			action += 1
			#action_cards.append(card)
		elif card == "ATK":
			atk += 1
			#attack_cards.append(card)
	casts += spl
	actions += action
	attack_pool += atk
	movecapital += move_array[move]
	#print(str(casts)+' '+ str(actions)+' '+str(attack_pool)+ ' '+str(movecapital))

func lifepool_checker(string_to_check: String, letter_to_check: String) -> int:
	# Ensure that the letter_to_check is a single character
	if letter_to_check.length() != 1:
		push_error("letter_to_check should be a single character")
		return -1
	
	# Initialize a counter
	var count = 0
	
	# Loop through the string and count occurrences of letter_to_check
	for i in range(string_to_check.length()):
		if string_to_check[i] == letter_to_check:
			count += 1
	
	return count

# General Movement and animation processsing
func _physics_process(delta):
	var horizontal_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	attacking = Input.get_action_strength("attack")
	casting = Input.get_action_strength("cast")
	acting = Input.get_action_strength("action")
	#var healing = healed
	# Only move if this character is the active character
	if self == get_parent().get_parent().active_character:
		# Horizontal movement
		if horizontal_direction != 0:
			if(movecapital>0):
				velocity.x = horizontal_direction * SPEED
				movecapital = movecapital -1
				var string5 = "../../Active_Character/Label4"
				get_node(string5).text = "Move points : "+str(movecapital) +'\n'
			if(movecapital==0):
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if horizontal_direction > 0:
				$AnimatedSprite2D.animation = "walk_right"
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.animation = "walk_left"
				$AnimatedSprite2D.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Vertical movement
		if vertical_direction != 0:
			if(movecapital>0):
				velocity.y = vertical_direction * SPEED
				movecapital = movecapital -1
				#print("Vertical move " + str(movecapital))
			if(movecapital==0):
				velocity.y = move_toward(velocity.y, 0, SPEED)
			if vertical_direction > 0:
				$AnimatedSprite2D.animation = "walk_down"
			else:
				$AnimatedSprite2D.animation = "walk_up"
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
			
		# Set default attack
		if horizontal_direction == 0 and vertical_direction == 0:
			if(int(attacking)>0):
				if(attacks>0 and attack_pool>0 and in_attack_range==true):
					var v = false
					if(v==false):
						v = attack()
				else:
					print("No attacks remaining !")
		# Set spell actions
		if horizontal_direction == 0 and vertical_direction == 0 and int(attacking) == 0:
			if(int(casting)>0):
				if(casts!=[0,0,0,0] and spell_target and int(checked_spell['tier'])>0):
					var v = false
					#$AnimatedSprite2D.play("casting")
					if(v==false):
						v = cast_spells(checked_spell,self,spell_target) #spell,caster,targets
				else:
					print("No casts remaining !")
			#else:
				#$AnimatedSprite2D.animation = "default"
		if horizontal_direction == 0 and vertical_direction == 0 and int(attacking) == 0 and int(casting)==0:
			if(int(acting) >0):
				if(action_target is Array or action_target is CharacterBody2D and int(actions)>0):
					if checked_actions["target/test"][0]=="Enemy" or checked_actions["target/test"][0]=="Ally":
						var v = false
						if(v==false):
							v = use_action(checked_actions,self,action_target)
				else:
					print("No actions remaining !")
			else:
				$AnimatedSprite2D.animation = "default"
		#else:
			#$AnimatedSprite2D.animation = "default"
		move_and_slide()
	if self != get_parent().get_parent().active_character:
		if healed == 1:
			$AnimatedSprite2D.animation = "healing"
		if shielded == 1 or shield_active == 1:
			$AnimatedSprite2D.animation = "shielding"
		#else:
			#$AnimatedSprite2D.animation = "default"

var detection_radius = 30

func range_finder(characters,max_range,min_range,target) -> Array:
	var result = []
	if self == get_parent().get_parent().active_character:
		var active_character_position = get_parent().get_parent().active_character.global_position
		var detection_radius = max_range  # Adjust this value as needed
		var close_radius = min_range
		for character in characters:
			if character != get_parent().get_parent().active_character:
				var tar
				var dist = 100000
				#navigation_agent.target_position = $"../../Characters/character1".global_position
				navigation_agent.target_position = character.global_position
				var distance = navigation_agent.distance_to_target()
				if distance<=detection_radius and distance >= close_radius:
					if target == "SHD" or target == "HEAL":
						result.append(character)
				if(distance<dist):
					dist = distance
					tar = character
				#print(get_parent().get_parent().active_character.name+ " " + str(distance)+ " " + character.name)
		#print("____________________________________________________")
		for enemy in enemies:
			if enemy:
				var tar
				var dist = 100000
				#navigation_agent.target_position = $"../../Characters/character1".global_position
				navigation_agent.target_position = enemy.global_position
				var distance = navigation_agent.distance_to_target()
				if distance<=detection_radius and distance >= close_radius and target == "ATK":
						result.append(enemy)
				if(distance<dist):
					dist = distance
					tar = enemy
					#print(get_parent().get_parent().active_character.name+ " " + str(distance)+ " " + enemy.name)
		#print("____________________________________________________")
		if result != []:
			if close_radius == 0:
				if target == "SHD" or target == "HEAL" or target == "UTI":
					result.append(get_parent().get_parent().active_character)
			#print(result)
		if max_range==0 and min_range == 0:
			result.append(get_parent().get_parent().active_character)
	return(result)

func attack() -> bool:
	attacking = true
	$AnimatedSprite2D.play("attack")
	attacks -= 1
	if(attacks == 0):
		attacking = false
		attack_pool -= 1
		remove_first_card(local["action_hand"], "ATK")
		var string5 = "../../Active_Character/Label6"
		get_node(string5).text = "Attacks : " + str(attack_pool)+'\n'
		attacks = 70
		if offensive_weapon:
			print(offensive_weapon["damage"])
			attack_target.take_damage(local["damage"]+offensive_weapon["damage"],offensive_weapon["special"])
		else:
			attack_target.take_damage(local["damage"]+local["weapons_equiped"][0]["damage"],local["weapons_equiped"][0]["special"])
		$AnimatedSprite2D.animation = "default"
		return true
	return false

func remove_first_card(card_array, card_type):
	var return_arr = []
	for card in card_array:
		if card != card_type:
			return_arr.append(card)
			break
	print(return_arr)
	return return_arr

func _process(delta):
	if self == get_parent().get_parent().active_character:
		if(chara and local):
			var weapon_range = local["weapons_equiped"][0]["range"]
			if local["weapons_equiped"].size()>1:
				if local["weapons_equiped"][0]["range"] < local["weapons_equiped"][1]["range"]:
					weapon_range = local["weapons_equiped"][1]["range"]
			var arr = range_finder(chara,range_array[weapon_range],0,"ATK")
			#print(arr)
			var string4 = "../../Active_Character/Attack_container"
			var parent_node = get_node(string4)
			if parent_node.get_children().size()==0 and attacks > 0:
				if arr.size()>0:
					var string3 = "../../Active_Character/Label7"
					var node = get_node(string3)
					node.text = "You are in attack range !"
					for target in arr:
						var button = Button.new()
						button.text = str(target.Name)
						parent_node.add_child(button)
						button.pressed.connect(self.on_target_button_pressed.bind(get_parent().get_parent().active_character,target))
					#print(arr)
			if (arr.size()==0):
				var string3 = "../../Active_Character/Label7"
				var node = get_node(string3)
				node.text = ""
				string4 = "../../Active_Character/Attack_container"
				node = get_node(string4)
				for m in node.get_children():
					node.remove_child(m)
					m.queue_free()
				in_attack_range = false
				attack_target = null

# Function to handle the end turn action
func end_turn():
	if movecapital>22:
		pass
	if attacks > 1:
		pass
	if casts != [0,0,0,0]:
		pass
	if actions != 0:
		pass
	movecapital = 105
	for n in range(0, 4):
		var real = n+1
		var string3 = "../../Spell_cont_t"+str(real)
		var node = get_node(string3)
		var string4 = "../../Action_cont_t"+str(real)
		var node2 = get_node(string4)
		for m in node.get_children():
			node.remove_child(m)
			m.queue_free()
		for m in node2.get_children():
			node2.remove_child(m)
			m.queue_free()
	var string4 = "../../Spells_and_abilities/Spell_Container"
	var parent_node = get_node(string4)
	for m in parent_node.get_children():
					parent_node.remove_child(m)
					m.queue_free()
	string4 = "../../Spells_and_abilities/Ability_Container"
	parent_node = get_node(string4)
	for m in parent_node.get_children():
					parent_node.remove_child(m)
					m.queue_free()
	for n in range(1, 5):
			var string5 = "../../GridContainer"
			var node = get_node(string5)
			var count = 0
			for m in node.get_children():
				if count < 0:
					m.hide()
					count += 1
	var level = get_parent().get_parent()
	level.next_character()

func on_target_button_pressed(attacker,attacked):
	print(str(attacker.name)+" can attack "+attacked.name)
	in_attack_range = true
	attack_target = attacked
	if(local["weapons_equiped"].size()>1):
		for weapon in local["weapons_equiped"]:
			var button = Button.new()
			var string4 = "../../Active_Character/Attack_container"
			var parent_node = get_node(string4)
			button.text = str(weapon["name"])
			parent_node.add_child(button)
			button.pressed.connect(self.weapon_chooser.bind(weapon))
			pass
	else:
		offensive_weapon = local["weapons_equiped"][0]

func weapon_chooser(weapon):
	offensive_weapon = weapon
	pass
