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
var shielded # animation keyword
var struck # animation keyword
var buffed # animation keyword
var debuffed # animation keyword
var populate = "spells"

func _ready():
	attacks = 70

func show_chara_stats(charac):
	local = charac
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
			#print(local["abilities"])
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
					button.pressed.connect(self.on_target_spell_button_pressed.bind(spell_ranges[local["spells"][n][m]["range"][1]],spell_ranges[local["spells"][n][m]["range"][0]],local["spells"][n][m]["type"],local["spells"][n][m]))
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

func on_target_spell_button_pressed(max_range,min_range,spell_type,spell):#spell is complete
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

func on_target_action_button_pressed(max_range,min_range,action_type,action):
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
	var string4 = "../../Spells_and_abilities/Action_Container"
	var parent_node = get_node(string4)
	button.text += checked_actions["name"]+ " has \n"+ str(action_target.name) + "\nas target"
	parent_node.add_child(button)
	print(checked_spell["name"]+ " has "+ str(action_target) + " as target")

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
			else:
				for target in targets[0]:
					target.shielded = 1
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
			targets.gain_to_life_pool(0,0,4,0,0);
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
	if acty>0:
		acty -= 1
		$AnimatedSprite2D.play("acting")
		if action["target/test"][0]=="Ally":
			if targets is CharacterBody2D:
				targets.buffed = 1
			else:
				for target in targets[0]:
					target.buffed = 1
		if action["target/test"][0]=="Enemy":
			if targets is CharacterBody2D:
				targets.debuffed = 1
			else:
				for target in targets[0]:
					target.debuffed = 1
		return false
	if acty ==0:
		acty=70
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
	#var time = 1000
	#healed = 1
	#while(time>0):
		#$AnimatedSprite2D.animation = "healing"
		#time -= 1
		#print(time)
	#healed = 0
	print("Completed")
	pass

func lose_to_life_pool(lives,blocks,parries,shields,buffs):
	print("Lose to life")
	pass

func gain_to_action_hand(yards,move,action_cards,T1casts,T2casts,T3casts,T4casts,random):
	print("Gain to action")
	pass

func lose_to_action_hand(yards,move,action_cards,T1casts,T2casts,T3casts,T4casts,random):
	print("Lose to action")
	pass

func categorize_cards(card_array):
	var move = 0
	var atk = 0
	var action = 0
	var spl = [0,0,0,0]
	for card in card_array:
		if card == "YARD":
			move += 1
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
	casts = spl
	actions = action
	attack_pool = atk
	movecapital = move_array[move]
	print(str(casts)+' '+ str(actions)+' '+str(attack_pool)+ ' '+str(movecapital))

func _physics_process(delta):
	var horizontal_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	attacking = Input.get_action_strength("attack")
	casting = Input.get_action_strength("cast")
	acting = Input.get_action_strength("action")
	var healing = healed
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
			else:
				$AnimatedSprite2D.animation = "default"
		if horizontal_direction == 0 and vertical_direction == 0 and int(attacking) == 0 and int(casting)==0:
			if(int(actions)>0):
				if(action_target and chosen_action):
					var v = false
					#$AnimatedSprite2D.play("casting")
					if(v==false):
						v = use_action(checked_spell,self,spell_target)
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
