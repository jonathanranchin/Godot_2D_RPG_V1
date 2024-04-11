extends Node2D

var characters
var life_pools
var action_deck
var spellnums
var abilities
var names
var spells = [[],[],[],[]]
var ability = [[],[],[],[]]
var rerolls = []
var draftedspells = []
var draftedabilities = []
var validation = [false,false,false,false]

var current_char = 0
var spellsdone = 0

var T1Spells = [
	{ "name": "Arcane Bolt","type": "ATK","range": [3,10],"effect": "Inflict 3 damage on a single foe","tier":"1"},
	{ "name": "Shielding Aura","type": "SHD","range": [0,4],"effect": "Add 1 Shielding card to all allies' HP pools","tier":"1"},
	{ "name": "Elemental Dart","type": "ATK","range": [3,8],"effect": "Inflict 3 damage on a single foe. If the target is adjacent to a wall, add 1 extra damage.","tier":"1"},
	{ "name": "Blink","type": "MVE","range": [0,0],"effect": "Move yourself up to 2 meters away","tier":"1"},
	{ "name": "Minor Heal","type": "HEAL","range": [0,2],"effect": "Heal 3 HP for a single ally.","tier":"1"},
	{ "name": "Resonating Shield","type": "SHD","range": [0,2],"effect": "Add 2 Shielding cards to a single ally's HP pool and grant them 1 Parry card.","tier":"1"},
	{ "name": "Energy Surge","type": "UTI","range": [0,0],"effect": "Add a cast of any tier to your action pool.","tier":"1"},
	{ "name": "Arcane Insight","type": "UTI","range": [0,0],"effect": "Draw 2 additional cards from your action pool discard this turn.","tier":"1"},
	{ "name": "Frost Nova","type": "ATK","range": [0,3],"effect": "Inflict 3 damage on all foes within 2 meters and discard 1 random movement card from their action pools.","tier":"1"},
	{ "name": "Stone Skin","type": "SHD","range": [0,2],"effect": "Add 3 Shielding cards to a single ally's HP pool.","tier":"1"},
	{ "name": "Wind Gust","type": "UTI","range": [3,12],"effect": "Push a single foe up to 2 meters away.","tier":"1"},
	{ "name": "Arcane Pulsation","type": "UTI","range": [0,0],"effect": "Draw 1 additional card from your action pool this turn and next turn.","tier":"1"},
]

var T2Spells = [
	{ "name": "Flame Burst","type": "ATK","range": [3,6],"effect": "Inflict 4 damage to a single foe and add 1 extra damage on their next action.","tier":"2"},
	{ "name": "Chain Lightning","type": "ATK","range": [2,5],"effect": "Inflict 4 damage to 2 targets within 3 meters of each other. Discard 1 cast or attack card from each target's action pool.","tier":"2"},
	{ "name": "Icy Grasp","type": "ATK","range": [3,9],"effect": "Inflict 4 damage to a single foe and discard 1 movement card from their action pool.","tier":"2"},
	{ "name": "Vitalizing Surge","type": "HEAL","range": [0,3],"effect": "Heal 4 HP for a single ally and grant them +1 damage bonus to their next attack","tier":"2"},
	{ "name": "Break Morale","type": "UTI","range": [3,6],"effect": "Discard 2 random cast cards from a single foe's action pool.","tier":"2"},
	{ "name": "Gust of Wind","type": "UTI","range": [3,15],"effect": "Move a single foe up to 4 meters away and discard 1 movement card from their action pool.","tier":"2"},
	{ "name": "Mystic Shield","type": "SHD","range": [0,2],"effect": "Add 4 Parry cards to a single ally's HP pool.","tier":"2"},
	{ "name": "Astral Step","type": "UTI","range": [0,2],"effect": "Move yourself up to 3 meters away and draw 1 additional card from your action pool.","tier":"2"},
	{ "name": "Crippling Blow","type": "ATK","range": [3,6],"effect": "Inflict 5 damage to a single foe and discard 1 attack card from their action pool.","tier":"2"},
	{ "name": "Fire of the Hearth","type": "HEAL","range": [0,2],"effect": "Add 5 life cards to an allies health pool","tier":"2"},
]

var T3Spells = [
	{ "name": "Inferno Burst","type": "ATK","range": [1,3],"effect": "Unleash a burst of flames, dealing 6 damage to all foes","tier":"3"},
	{ "name": "Cryomancy","type": "UTI","range": [1,4],"effect": "Freeze the ground. Any character in the zone discards two random cards from their action pool.","tier":"3"},
	{ "name": "Windstorm","type": "UTI","range": [0,4],"effect": "Create a powerful windstorm that pushes all foes 3 meters from self.","tier":"3"},
	{ "name": "Gravity Well","type": "UTI","range": [3,8],"effect": "Create a localized gravitational field within a 4-meter radius area, pulling all characters and foes within 1 meter toward a target tile and immobilizing them for one round.","tier":"3"},
	{ "name": "Life Siphon","type": "ATK","range": [1,3],"effect": "Drain the life force of a single foe within 2 meters, dealing 5 damage and healing yourself for the same amount.","tier":"3"},
	{ "name": "Elemental Shield","type": "SHD","range": [0,3],"effect": "Envelop a single ally within 3 meters in an elemental shield that grants them 7 shield.","tier":"3"},
]

var T4Spells = [
	{ "name": "Celestial Reckoning","type": "ATK/HEAL","range": [0,10],"effect": "Call upon the power of the heavens to rain down celestial energy upon a chosen location (2 on 2 area) within 10 meters. All enemies within the area suffer 8 damage, and all allies gain 4 shielding and 1 life to their life pools.","tier":"4"},
	{ "name": "Eternal Resurgence","type": "HEAL","range": [0,2],"effect": "Harness the energy of life itself to resurrect a fallen ally within 5 meters. The ally returns to the battle with half of their maximum HP and gains 6 magical protection for the next three rounds.","tier":"4"},
	{ "name": "Time Dilation","type": "UTI","range": [0,7],"effect": "Manipulate the fabric of time around an ally within 7 meters, granting them an additional turn immediately after their current turn. This effect lasts for the next two rounds.","tier":"4"},
	{ "name": "Searing Tempest","type": "ATK","range": [3,10],"effect": "Summon a raging storm of fire and lightning that engulfs a target area within 10 meters (3 out 3 area). All enemies within the area suffer 14 damage and draw 2 miss cards. The storm persists, dealing 4 damage to enemies within the area for the next three rounds.","tier":"4"},
]

var spellbook = {
		"T1Spells" : [
			{ "name": "Arcane Bolt","type": "ATK","range": [3,10],"effect": "Inflict 3 damage on a single foe","tier":"1"},
			{ "name": "Shielding Aura","type": "SHD","range": [0,4],"effect": "Add 1 Shielding card to all allies' HP pools","tier":"1"},
			{ "name": "Elemental Dart","type": "ATK","range": [3,8],"effect": "Inflict 3 damage on a single foe. If the target is adjacent to a wall, add 1 extra damage.","tier":"1"},
			{ "name": "Blink","type": "MVE","range": [0,0],"effect": "Move yourself up to 2 meters away","tier":"1"},
			{ "name": "Minor Heal","type": "HEAL","range": [0,2],"effect": "Heal 3 HP for a single ally.","tier":"1"},
			{ "name": "Resonating Shield","type": "SHD","range": [0,2],"effect": "Add 2 Shielding cards to a single ally's HP pool and grant them 1 Parry card.","tier":"1"},
			{ "name": "Energy Surge","type": "UTI","range": [0,0],"effect": "Add a cast of any tier to your action pool.","tier":"1"},
			{ "name": "Arcane Insight","type": "UTI","range": [0,0],"effect": "Draw 2 additional cards from your action pool discard this turn.","tier":"1"},
			{ "name": "Frost Nova","type": "ATK","range": [0,3],"effect": "Inflict 3 damage on all foes within 2 meters and discard 1 random movement card from their action pools.","tier":"1"},
			{ "name": "Stone Skin","type": "SHD","range": [0,2],"effect": "Add 3 Shielding cards to a single ally's HP pool.","tier":"1"},
			{ "name": "Wind Gust","type": "UTI","range": [3,12],"effect": "Push a single foe up to 2 meters away.","tier":"1"},
			{ "name": "Arcane Pulsation","type": "UTI","range": [0,0],"effect": "Draw 1 additional card from your action pool this turn and next turn.","tier":"1"},
		],
		"T2Spells" : [
			{ "name": "Flame Burst","type": "ATK","range": [3,6],"effect": "Inflict 4 damage to a single foe and add 1 extra damage on their next action.","tier":"2"},
			{ "name": "Chain Lightning","type": "ATK","range": [2,5],"effect": "Inflict 4 damage to 2 targets within 3 meters of each other. Discard 1 cast or attack card from each target's action pool.","tier":"2"},
			{ "name": "Icy Grasp","type": "ATK","range": [3,9],"effect": "Inflict 4 damage to a single foe and discard 1 movement card from their action pool.","tier":"2"},
			{ "name": "Vitalizing Surge","type": "HEAL","range": [0,3],"effect": "Heal 4 HP for a single ally and grant them +1 damage bonus to their next attack","tier":"2"},
			{ "name": "Break Morale","type": "UTI","range": [3,6],"effect": "Discard 2 random cast cards from a single foe's action pool.","tier":"2"},
			{ "name": "Gust of Wind","type": "UTI","range": [3,15],"effect": "Move a single foe up to 4 meters away and discard 1 movement card from their action pool.","tier":"2"},
			{ "name": "Mystic Shield","type": "SHD","range": [0,2],"effect": "Add 4 Parry cards to a single ally's HP pool.","tier":"2"},
			{ "name": "Astral Step","type": "UTI","range": [0,2],"effect": "Move yourself up to 3 meters away and draw 1 additional card from your action pool.","tier":"2"},
			{ "name": "Crippling Blow","type": "ATK","range": [3,6],"effect": "Inflict 5 damage to a single foe and discard 1 attack card from their action pool.","tier":"2"},
			{ "name": "Fire of the Hearth","type": "HEAL","range": [0,2],"effect": "Add 5 life cards to an allies health pool","tier":"2"},
		],
		"T3Spells" : 
		[
			{ "name": "Inferno Burst","type": "ATK","range": [1,3],"effect": "Unleash a burst of flames, dealing 6 damage to all foes","tier":"3"},
			{ "name": "Cryomancy","type": "UTI","range": [1,4],"effect": "Freeze the ground. Any character in the zone discards two random cards from their action pool.","tier":"3"},
			{ "name": "Windstorm","type": "UTI","range": [0,4],"effect": "Create a powerful windstorm that pushes all foes 3 meters from self.","tier":"3"},
			{ "name": "Gravity Well","type": "UTI","range": [3,8],"effect": "Create a localized gravitational field within a 4-meter radius area, pulling all characters and foes within 1 meter toward a target tile and immobilizing them for one round.","tier":"3"},
			{ "name": "Life Siphon","type": "ATK","range": [1,3],"effect": "Drain the life force of a single foe within 2 meters, dealing 5 damage and healing yourself for the same amount.","tier":"3"},
			{ "name": "Elemental Shield","type": "SHD","range": [0,3],"effect": "Envelop a single ally within 3 meters in an elemental shield that grants them 7 shield.","tier":"3"},
		],
		"T4Spells" : 
			[
				{ "name": "Celestial Reckoning","type": "ATK/HEAL","range": [0,10],"effect": "Call upon the power of the heavens to rain down celestial energy upon a chosen location (2 on 2 area) within 10 meters. All enemies within the area suffer 8 damage, and all allies gain 4 shielding and 1 life to their life pools.","tier":"4"},
				{ "name": "Eternal Resurgence","type": "HEAL","range": [0,2],"effect": "Harness the energy of life itself to resurrect a fallen ally within 5 meters. The ally returns to the battle with half of their maximum HP and gains 6 magical protection for the next three rounds.","tier":"4"},
				{ "name": "Time Dilation","type": "UTI","range": [0,7],"effect": "Manipulate the fabric of time around an ally within 7 meters, granting them an additional turn immediately after their current turn. This effect lasts for the next two rounds.","tier":"4"},
				{ "name": "Searing Tempest","type": "ATK","range": [3,10],"effect": "Summon a raging storm of fire and lightning that engulfs a target area within 10 meters (3 out 3 area). All enemies within the area suffer 14 damage and draw 2 miss cards. The storm persists, dealing 4 damage to enemies within the area for the next three rounds.","tier":"4"},
			],
		}

var T1Abilities = [
	{ "name": "Inspiring Words","target/test": ["Ally","agility"],"range": [1,5],"effect": "Target ally performs an easy SP test. If successful, add 1 action card to their action pool.","tier":"1"},
	{ "name": "Uncooth Remark","target/test": ["Enemy","agility"],"range": [1,5],"effect": "Target foe performs an easy SP test. If failed, remove 1 action card from their action pool.","tier":"1"},
	{ "name": "Charming Compliment","target/test": ["Ally","agility"],"range": [1,5],"effect": "Target ally performs an easy SP test. If successful, add 1 movement card to their action pool.","tier":"1"},
	{ "name": "Taunting Words","target/test": ["Enemy","strength"],"range": [1,5],"effect": "Target foe performs an easy ST test. If failed, remove 1 attack card from their action pool","tier":"1"},
	{ "name": "Distracting Gesture","target/test":["Enemy","agility"],"range": [1,4],"effect": "Target foe performs an easy SP test. If failed, remove 1 parry card from their HP pool.","tier":"1"},
	{ "name": "Tricky Illusion","target/test": ["Enemy","intellect"],"range": [1,6],"effect": "Target foe performs an easy KN-PO test. If failed, discard 1 random cast card from their action pool.","tier":"1"},
	{ "name": "Mischievous Whistle","target/test": ["Enemy","agility"],"range": [1,9],"effect": "Target foe performs an easy SP test. If failed, discard 1 random action card from their action pool.","tier":"1"},
	{ "name": "Confounding Distraction","target/test": ["Enemy","agility"],"range": [1,4],"effect": "Perform an easy SP test. If successful, remove 1 random movement card from the target foe's action pool.","tier":"1"},
	{ "name": "Inspiring Command","target/test": ["Ally","agility"],"range": [1,4],"effect": "Target ally performs an easy SP test. If successful, add 2 movement card to their action pool.","tier":"1"},
	{ "name": "Encouraging Shout","target/test": ["Ally","strength"],"range": [0,0],"effect": "Perform an easy SP test. If successful, target ally draws 1 additional cast card.","tier":"1"},
	{ "name": "Motivating Presence","target/test": ["Ally","agility"],"range": [1,5],"effect": "Target ally performs an easy SP test. If successful, add 1 action card to their action pool.","tier":"1"},
	{ "name": "Tactical Insight","target/test": ["Ally","Intellect"],"range": [0,0],"effect": "Perform an easy KN-PO test. If successful, the target ally gains +2 parry cards.","tier":"1"},
]

var T2Abilities = [
	{ "name": "Misdirection","target/test": ["Enemy","agilitymed"],"range": [1,4],"effect": "Target foe performs a medium SP test. If failed, they discard 2 movement cards from their action pool.","tier":"2"},
	{ "name": "Startling Feint","target/test": ["Enemy","agilitymed"],"range": [0,0],"effect": "Perform a medium SP test. If successful, target foe discards 2 cast cards from their action pool.","tier":"2"},
	{ "name": "Deceptive Whisper","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs a medium KN-PO test. If failed, they discard 1 attack card and 2 movement card from their action pool.","tier":"2"},
	{ "name": "Confidence Boost","target/test": ["Ally","intellectmedium"],"range": [0,0],"effect": "Perform a medium KN-PO test. If successful, the target ally adds 1 evade card and 1 block card to their HP pool.","tier":"2"},
	{ "name": "Enthralling Gaze","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs an easy KN-PO test. If failed, they discard 2 cast cards from their action pool and become stunned for 1 turn.","tier":"2"},
	{ "name": "Mind Control","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs an easy KN-PO test. If failed, you gain control of their next action, deciding what they do.","tier":"2"},
	{ "name": "Distracting Monologue","target/test": ["Enemy","intellectmedium"],"range": [1,5],"effect": "Target foe performs a medium KN-PO test. If failed, they discard 2 action (attack or movement) cards from their action pool","tier":"2"},
	{ "name": "Charm of Persuasion","target/test": ["Ally","agilitymedium"],"range": [0,0],"effect": " Perform a medium SP test. If successful, the target ally adds 2 cards (movement or attack) to their action pool.","tier":"2"},
]

var T3Abilities = [
	{ "name": "Paralyzing Whispers","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs an easy KN-PO test. If failed, they become paralyzed for 1 turn, unable to take any actions.","tier":"3"},
	{ "name": "Inspirational Address","target/test": ["Ally","intellect"],"range": [1,5],"effect": "Perform an easy KN-PO test. If successful, two allies add 3 attack cards to their action pool.","tier":"3"},
	{ "name": "Eloquent Negotiation","target/test": ["Ally","intellect"],"range": [1,5],"effect": " Perform an easy KN-PO test. If successful, add 3 additional tier 1 cast cards to an ally's action pool.","tier":"3"},
	{ "name": "Confounding Gesture","target/test": ["Enemy","strength"],"range": [1,7],"effect": "Target foe performs a hard ST test. If failed, they discard 3 action (attack or movement) cards from their action pool.","tier":"3"},
	{ "name": "Unified Purpose","target/test": ["Ally","charismamedium"],"range": [0,0],"effect": "Perform a medium CH-LO test. If successful, all allies add 2 attack cards and 2 movement cards to their action pool.","tier":"3"},
]

var T4Abilities = [
	{ "name": "Demoralisation","target/test": ["Ally","charismahard"],"range": [0,0],"effect": "Perform a hard CH-LO test. If successful, all foes within 4 range discard 3 cast cards from their action pool.","tier":"4"},
	{ "name": "Chaotic Blunders","target/test": ["Enemy","agilityhard"],"range": [1,4],"effect": "All foes within 4 range perform a hard SP test. If failed, they discard 3 attack cards from their action pool.","tier":"4"},
	{ "name": "Stand and Fight","target/test": ["Ally","charismahard"],"range": [0,0],"effect": "Perform a hard CH-LO test. If successful, one ally within 4 range adds 5 attack cards to their action pool.","tier":"4"},
	{ "name": "Mental Anahilation","target/test": ["Enemy","intellecthard"],"range": [0,0],"effect": "Perform a hard KN-PO test. If successful, all foes within 4 range switch sides for the current turn.","tier":"4"},
]

func spell_validate(tier: int):
	if(spellsdone==0):
		var character = current_char
		spellnums[character]["T"+str(tier)+"S"][0] = 0
		var string5 = "GridContainer/GridContainer/GridContainer/Validate_Spell_"+str(tier)
		get_node(string5).text = "This batch of spells for Tier "+str(tier)+" has been validated"
		string5 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(tier)
		get_node(string5).text = "This batch of spells for Tier "+str(tier)+" has been validated"
		validation[tier-1] = true
		if (validation == [true,true,true,true] and spellsdone == 0):
			spells[current_char].append(draftedspells[0])
			spells[current_char].append(draftedspells[1])
			spells[current_char].append(draftedspells[2])
			spells[current_char].append(draftedspells[3])
			#print(draftedspells)
			current_char += 1
				#get_tree().change_scene_to_file("res://Menus/AddSpells&Abilities.tscn")
			print(spells.size())
			draftedspells = []
			rerolls = []
			validation = [false,false,false,false]
			if(current_char!=4):
				print(names[current_char])
			if(current_char==4 and spellsdone==0):
				print("All characters have spells")
				current_char = 0 
				spellsdone = 1
				#print(spells)
				ability_setup_subset(current_char)
				return
			else:
				spell_setup_subset(current_char)
	if(spellsdone==1):
		var character = current_char
		abilities[character]["T"+str(tier)+"A"][0] = 0
		var string5 = "GridContainer/GridContainer/GridContainer/Validate_Spell_"+str(tier)
		get_node(string5).text = "This batch of abilities for Tier "+str(tier)+" has been validated"
		string5 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(tier)
		get_node(string5).text = "This batch of abilities for Tier "+str(tier)+" has been validated"
		validation[tier-1] = true
		if (validation == [true,true,true,true] and spellsdone == 1):
			ability[current_char].append(draftedabilities[0])
			ability[current_char].append(draftedabilities[1])
			ability[current_char].append(draftedabilities[2])
			ability[current_char].append(draftedabilities[3])
			current_char += 1
			print(ability.size())
			draftedabilities = []
			rerolls = []
			validation = [false,false,false,false]
			if(current_char==4 and spellsdone==1):
				print("All characters have abilities")
				save_data()
				get_tree().change_scene_to_file("res://Menus/ChooseEquipment&Backstories.tscn")
			else:
				ability_setup_subset(current_char)

func save_data():
	var data = {
		"characters": characters,
		"life_pools": life_pools,
		"action_deck": action_deck,
		"spellnums": spells,
		"abilities": ability,
		"names": names
	}
	var json_string = JSON.stringify(data)
	save(json_string)

func save(content):
	var file = FileAccess.open("res://saves/party_data_2.tres", FileAccess.WRITE)
	file.store_string(content)

# Perform rerolls
func spell_reroll(tier: int):
	if(spellsdone==0):
		var character = current_char
		var tries = spellnums[character]["T"+str(tier)+"S"][0]
		var real = tier
		var j = character
		if (tries<1):
			var string4 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(real)
			get_node(string4).text = "This batch of spells for Tier "+str(real)+" you have no rerolls remaining"
			spell_validate(tier)
			return
		var subset = []
		var rerolled = generate_random_subset(spellbook["T"+str(tier)+"Spells"],spellnums[character]["T"+str(tier)+"S"][1])
		var new_subset = generate_random_subset(rerolled, spellnums[character]["T"+str(tier)+"S"][1])
		spellnums[character]["T"+str(tier)+"S"][0] -= 1
		tries = spellnums[character]["T"+str(tier)+"S"][0]
		var string2 = "GridContainer/GridContainer/GridContainer/Spells_"+str(real)
		get_node(string2).text = "Tier " + str(real) + " Spells either choose this batch or reroll\n"
		draftedspells[j] = new_subset
		for m in range(0,draftedspells[j].size()):
			get_node(string2).text += "Name: " + draftedspells[j][m]["name"]+ " Type: "+draftedspells[j][m]["type"] + " "
			get_node(string2).text += "Range: " + str(draftedspells[j][m]["range"][0]) + "/" + str(draftedspells[j][m]["range"][1]) + "\nEffect: " + draftedspells[j][m]["effect"] +"\n"
			var string = "GridContainer/GridContainer/GridContainer/Validate_Spell_"+str(real)
			get_node(string).text = "Keep this batch of spells for Tier"+str(real)
			var string3 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(real)
			get_node(string3).text = "Reroll this batch of spells for Tier "+str(real)+" you have "+ str(tries) +" remaining"
	if(spellsdone==1):
		var character = current_char
		var tries = abilities[character]["T"+str(tier)+"A"][0]
		var real = tier
		var j = character
		if (tries<1):
			var string4 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(real)
			get_node(string4).text = "This batch of abilities for Tier "+str(real)+" you have no rerolls remaining"
			spell_validate(tier)
			return
		var subset = []
		var abilitiesbook = {}
		abilitiesbook["T1A"] = T1Abilities
		abilitiesbook["T2A"] = T2Abilities
		abilitiesbook["T3A"] = T3Abilities
		abilitiesbook["T4A"] = T4Abilities
		var rerolled = generate_random_subset(abilitiesbook["T"+str(tier)+"A"],abilities[character]["T"+str(tier)+"A"][1])
		var new_subset = generate_random_subset(rerolled, abilities[character]["T"+str(tier)+"A"][1])
		abilities[character]["T"+str(tier)+"A"][0] -= 1
		tries = abilities[character]["T"+str(tier)+"A"][0]
		var string2 = "GridContainer/GridContainer/GridContainer/Spells_"+str(real)
		get_node(string2).text = "Tier " + str(real) + " Abilities either choose this batch or reroll\n"
		draftedabilities[j] = new_subset
		for m in range(0,draftedabilities[j].size()):
			get_node(string2).text += "Name: " + draftedabilities[j][m]["name"]+ " Type: " + str(draftedabilities[j][m]["target/test"][0]) + "/" + str(draftedabilities[j][m]["target/test"][1]) + " "
			get_node(string2).text += "Range: " + str(draftedabilities[j][m]["range"][0]) + "/" + str(draftedabilities[j][m]["range"][1]) + "\nEffect: " + draftedabilities[j][m]["effect"] +"\n"
			var string = "GridContainer/GridContainer/GridContainer/Validate_Spell_"+str(real)
			get_node(string).text = "Keep this batch of abilities for Tier"+str(real)
			var string3 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(real)
			get_node(string3).text = "Reroll this batch of abilities for Tier "+str(real)+" you have "+ str(tries) +" remaining"

func generate_random_subset(array_data: Array, subset_size: int) -> Array:
	var subset = []
	var remaining_indices = []

	# Populate remaining_indices with indices of array_data
	for i in range(array_data.size()):
		remaining_indices.append(i)

	while subset.size() < subset_size and remaining_indices.size() > 0:
		var index = randi() % remaining_indices.size()
		var element_index = remaining_indices[index]
		var element = array_data[element_index]

		subset.append(element)

		# Remove the selected index from remaining_indices
		remaining_indices.remove_at(index)

	return subset

func spell_setup_subset(n):
	var string4 = "GridContainer/GridContainer/Name_Label_1"
	get_node(string4).text = names[current_char]
	draftedspells.append(generate_random_subset(T1Spells,spellnums[n]["T1S"][1]))
	draftedspells.append(generate_random_subset(T2Spells,spellnums[n]["T2S"][1]))
	draftedspells.append(generate_random_subset(T3Spells,spellnums[n]["T3S"][1]))
	draftedspells.append(generate_random_subset(T4Spells,spellnums[n]["T4S"][1]))
	rerolls.append([spellnums[n]["T1S"][0],spellnums[n]["T2S"][0],spellnums[n]["T3S"][0],spellnums[n]["T4S"][0]])
	var picks = [spellnums[n]["T1S"][1],spellnums[n]["T2S"][1],spellnums[n]["T3S"][1],spellnums[n]["T4S"][1]]
	#print(rerolls)
	#print(picks.size())
	for j in range(0,draftedspells.size()):
		if(draftedspells[j].size()==0):
			spell_validate(j+1)
		for m in range(0,draftedspells[j].size()):
			var real = j+1
			var string2 = "GridContainer/GridContainer/GridContainer/Spells_"+str(real)
			if(m==0):
				get_node(string2).text = "Tier " + str(real) + " Spells either choose this batch or reroll\n"
			get_node(string2).text += "Name: " + draftedspells[j][m]["name"]+ " Type: "+draftedspells[j][m]["type"] + " "
			get_node(string2).text += "Range: " + str(draftedspells[j][m]["range"][0]) + "/" + str(draftedspells[j][m]["range"][1]) + "\nEffect: " + draftedspells[j][m]["effect"] +"\n"
			var string = "GridContainer/GridContainer/GridContainer/Validate_Spell_"+str(real)
			get_node(string).text = "Keep this batch of spells for Tier"+str(real)
			var string3 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(real)
			get_node(string3).text = "Reroll this batch of spells for Tier "+str(real)+" you have "+ str(spellnums[n]["T"+str(real)+"S"][0]) +" remaining"

func ability_setup_subset(n):
	var string4 = "GridContainer/GridContainer/Name_Label_1"
	get_node(string4).text = names[current_char]
	draftedabilities.append(generate_random_subset(T1Abilities,abilities[n]["T1A"][1]))
	draftedabilities.append(generate_random_subset(T2Abilities,abilities[n]["T2A"][1]))
	draftedabilities.append(generate_random_subset(T3Abilities,abilities[n]["T3A"][1]))
	draftedabilities.append(generate_random_subset(T4Abilities,abilities[n]["T4A"][1]))
	rerolls.append([abilities[n]["T1A"][0],abilities[n]["T2A"][0],abilities[n]["T3A"][0],abilities[n]["T4A"][0]])
	var picks = [abilities[n]["T1A"][1],abilities[n]["T2A"][1],abilities[n]["T3A"][1],abilities[n]["T4A"][1]]
	#print(rerolls)
	#print(picks.size())
	for j in range(0,draftedabilities.size()):
		if(draftedabilities[j].size()==0):
			spell_validate(j+1)
		for m in range(0,draftedabilities[j].size()):
			var real = j+1
			var string2 = "GridContainer/GridContainer/GridContainer/Spells_"+str(real)
			if(m==0):
				get_node(string2).text = "Tier " + str(real) + " Abilities either choose this batch or reroll\n"
			get_node(string2).text += "Name: " + draftedabilities[j][m]["name"]+ " Type: " + str(draftedabilities[j][m]["target/test"][0]) + " " + str(draftedabilities[j][m]["target/test"][1])
			get_node(string2).text += "Range: " + str(draftedabilities[j][m]["range"][0]) + "/" + str(draftedabilities[j][m]["range"][1]) + "\nEffect: " + draftedabilities[j][m]["effect"] +"\n"
			var string = "GridContainer/GridContainer/GridContainer/Validate_Spell_"+str(real)
			get_node(string).text = "Keep this batch of abilities for Tier"+str(real)
			var string3 = "GridContainer/GridContainer/GridContainer/Reroller_Spell_"+str(real)
			get_node(string3).text = "Reroll this batch of abilities for Tier "+str(real)+" you have "+ str(abilities[n]["T"+str(real)+"A"][0]) +" remaining"


# Called when the node enters the scene tree for the first time.
func _ready():
	loader()
	spell_setup_subset(0)
	update_ui()
	#pass # Replace with function body.

func update_ui():
	for o in range(0,1):
		var string4 = "GridContainer/GridContainer/Name_Label_1"
		get_node(string4).text = names[o]
	pass

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
