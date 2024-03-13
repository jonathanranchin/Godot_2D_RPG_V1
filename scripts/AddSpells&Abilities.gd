extends Node2D

var characters
var life_pools
var action_deck
var spellnums
var abilities
var names
var spells = []
var ability = []

var T1Spells = [
	{ "name": "Arcane Bolt","type": "ATK","range": [3,10],"effect": "Inflict 3 damage on a single foe"},
	{ "name": "Shielding Aura","type": "SHD","range": [0,4],"effect": "Add 1 Shielding card to all allies' HP pools"},
	{ "name": "Elemental Dart","type": "ATK","range": [3,8],"effect": "Inflict 3 damage on a single foe. If the target is adjacent to a wall, add 1 extra damage."},
	{ "name": "Blink","type": "MVE","range": [0,0],"effect": "Move yourself up to 2 meters away"},
	{ "name": "Minor Heal","type": "HEAL","range": [0,2],"effect": "Heal 3 HP for a single ally."},
	{ "name": "Resonating Shield","type": "SHD","range": [0,2],"effect": "Add 2 Shielding cards to a single ally's HP pool and grant them 1 Parry card."},
	{ "name": "Energy Surge","type": "UTI","range": [0,0],"effect": "Add a cast of any tier to your action pool."},
	{ "name": "Arcane Insight","type": "UTI","range": [0,0],"effect": "Draw 2 additional cards from your action pool discard this turn."},
	{ "name": "Frost Nova","type": "ATK","range": [0,3],"effect": "Inflict 3 damage on all foes within 2 meters and discard 1 random movement card from their action pools."},
	{ "name": "Stone Skin","type": "SHD","range": [0,2],"effect": "Add 3 Shielding cards to a single ally's HP pool."},
	{ "name": "Wind Gust","type": "UTI","range": [3,12],"effect": "Push a single foe up to 2 meters away."},
	{ "name": "Arcane Pulsation","type": "UTI","range": [0,0],"effect": "Draw 1 additional card from your action pool this turn and next turn."},
]

var T2Spells = [
	{ "name": "Flame Burst","type": "ATK","range": [3,6],"effect": "Inflict 4 damage to a single foe and add 1 extra damage on their next action."},
	{ "name": "Chain Lightning","type": "ATK","range": [2,5],"effect": "Inflict 4 damage to 2 targets within 3 meters of each other. Discard 1 cast or attack card from each target's action pool."},
	{ "name": "Icy Grasp","type": "ATK","range": [3,9],"effect": "Inflict 4 damage to a single foe and discard 1 movement card from their action pool."},
	{ "name": "Vitalizing Surge","type": "HEAL","range": [0,3],"effect": "Heal 4 HP for a single ally and grant them +1 damage bonus to their next attack"},
	{ "name": "Break Morale","type": "UTI","range": [3,6],"effect": "Discard 2 random cast cards from a single foe's action pool."},
	{ "name": "Gust of Wind","type": "UTI","range": [3,15],"effect": "Move a single foe up to 4 meters away and discard 1 movement card from their action pool."},
	{ "name": "Mystic Shield","type": "SHD","range": [0,2],"effect": "Add 4 Parry cards to a single ally's HP pool."},
	{ "name": "Astral Step","type": "UTI","range": [0,2],"effect": "Move yourself up to 3 meters away and draw 1 additional card from your action pool."},
	{ "name": "Crippling Blow","type": "ATK","range": [3,6],"effect": "Inflict 5 damage to a single foe and discard 1 attack card from their action pool."},
	{ "name": "Fire of the Hearth","type": "HEAL","range": [0,2],"effect": "Add 5 life cards to an allies health pool"},
]

var T3Spells = [
	{ "name": "Inferno Burst","type": "ATK","range": [1,3],"effect": "Unleash a burst of flames, dealing 6 damage to all foes"},
	{ "name": "Cryomancy","type": "UTI","range": [1,4],"effect": "Freeze the ground. Any character in the zone discards two random cards from their action pool."},
	{ "name": "Windstorm","type": "UTI","range": [0,4],"effect": "Create a powerful windstorm that pushes all foes 3 meters from self."},
	{ "name": "Gravity Well","type": "UTI","range": [3,8],"effect": "Create a localized gravitational field within a 4-meter radius area, pulling all characters and foes within 1 meter toward a target tile and immobilizing them for one round."},
	{ "name": "Life Siphon","type": "ATK","range": [1,3],"effect": "Drain the life force of a single foe within 2 meters, dealing 5 damage and healing yourself for the same amount."},
	{ "name": "Elemental Shield","type": "SHD","range": [0,3],"effect": "Envelop a single ally within 3 meters in an elemental shield that grants them 7 shield."},
]

var T4Spells = [
	{ "name": "Celestial Reckoning","type": "ATK/HEAL","range": [0,10],"effect": "Call upon the power of the heavens to rain down celestial energy upon a chosen location (2 on 2 area) within 10 meters. All enemies within the area suffer 8 damage, and all allies gain 4 shielding and 1 life to their life pools."},
	{ "name": "Eternal Resurgence","type": "HEAL","range": [0,2],"effect": "Harness the energy of life itself to resurrect a fallen ally within 5 meters. The ally returns to the battle with half of their maximum HP and gains 6 magical protection for the next three rounds."},
	{ "name": "Time Dilation","type": "UTI","range": [0,7],"effect": "Manipulate the fabric of time around an ally within 7 meters, granting them an additional turn immediately after their current turn. This effect lasts for the next two rounds."},
	{ "name": "Searing Tempest","type": "ATK","range": [3,10],"effect": "Summon a raging storm of fire and lightning that engulfs a target area within 10 meters (3 out 3 area). All enemies within the area suffer 14 damage and draw 2 miss cards. The storm persists, dealing 4 damage to enemies within the area for the next three rounds."},
]

var T1Abilities = [
	{ "name": "Inspiring Words","target/test": ["Ally","agility"],"range": [1,5],"effect": "Target ally performs an easy SP test. If successful, add 1 action card to their action pool."},
	{ "name": "Uncooth Remark","target/test": ["Enemy","agility"],"range": [1,5],"effect": "Target foe performs an easy SP test. If failed, remove 1 action card from their action pool."},
	{ "name": "Charming Compliment","target/test": ["Ally","agility"],"range": [1,5],"effect": "Target ally performs an easy SP test. If successful, add 1 movement card to their action pool."},
	{ "name": "Taunting Words","target/test": ["Enemy","strength"],"range": [1,5],"effect": "Target foe performs an easy ST test. If failed, remove 1 attack card from their action pool"},
	{ "name": "Distracting Gesture","target/test":["Enemy","agility"],"range": [1,4],"effect": "Target foe performs an easy SP test. If failed, remove 1 parry card from their HP pool."},
	{ "name": "Tricky Illusion","target/test": ["Enemy","intellect"],"range": [1,6],"effect": "Target foe performs an easy KN-PO test. If failed, discard 1 random cast card from their action pool."},
	{ "name": "Mischievous Whistle","target/test": ["Enemy","agility"],"range": [1,9],"effect": "Target foe performs an easy SP test. If failed, discard 1 random action card from their action pool."},
	{ "name": "Confounding Distraction","target/test": ["Enemy","agility"],"range": [1,4],"effect": "Perform an easy SP test. If successful, remove 1 random movement card from the target foe's action pool."},
	{ "name": "Inspiring Command","target/test": ["Ally","agility"],"range": [1,4],"effect": "Target ally performs an easy SP test. If successful, add 2 movement card to their action pool."},
	{ "name": "Encouraging Shout","target/test": ["Ally","strength"],"range": [0,0],"effect": "Perform an easy SP test. If successful, target ally draws 1 additional cast card."},
	{ "name": "Motivating Presence","target/test": ["Ally","agility"],"range": [1,5],"effect": "Target ally performs an easy SP test. If successful, add 1 action card to their action pool."},
	{ "name": "Tactical Insight","target/test": ["Ally","Intellect"],"range": [0,0],"effect": "Perform an easy KN-PO test. If successful, the target ally gains +2 parry cards."},
]

var T2Abilities = [
	{ "name": "Misdirection","target/test": ["Enemy","agilitymed"],"range": [1,4],"effect": "Target foe performs a medium SP test. If failed, they discard 2 movement cards from their action pool."},
	{ "name": "Startling Feint","target/test": ["Enemy","agilitymed"],"range": [0,0],"effect": "Perform a medium SP test. If successful, target foe discards 2 cast cards from their action pool."},
	{ "name": "Deceptive Whisper","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs a medium KN-PO test. If failed, they discard 1 attack card and 2 movement card from their action pool."},
	{ "name": "Confidence Boost","target/test": ["Ally","intellectmedium"],"range": [0,0],"effect": "Perform a medium KN-PO test. If successful, the target ally adds 1 evade card and 1 block card to their HP pool."},
	{ "name": "Enthralling Gaze","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs an easy KN-PO test. If failed, they discard 2 cast cards from their action pool and become stunned for 1 turn."},
	{ "name": "Mind Control","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs an easy KN-PO test. If failed, you gain control of their next action, deciding what they do."},
	{ "name": "Distracting Monologue","target/test": ["Enemy","intellectmedium"],"range": [1,5],"effect": "Target foe performs a medium KN-PO test. If failed, they discard 2 action (attack or movement) cards from their action pool"},
	{ "name": "Charm of Persuasion","target/test": ["Ally","agilitymedium"],"range": [0,0],"effect": " Perform a medium SP test. If successful, the target ally adds 2 cards (movement or attack) to their action pool."},
]

var T3Abilities = [
	{ "name": "Paralyzing Whispers","target/test": ["Enemy","intellect"],"range": [1,3],"effect": "Target foe performs an easy KN-PO test. If failed, they become paralyzed for 1 turn, unable to take any actions."},
	{ "name": "Inspirational Address","target/test": ["Ally","intellect"],"range": [1,5],"effect": "Perform an easy KN-PO test. If successful, two allies add 3 attack cards to their action pool."},
	{ "name": "Eloquent Negotiation","target/test": ["Ally","intellect"],"range": [1,5],"effect": " Perform an easy KN-PO test. If successful, add 3 additional tier 1 cast cards to an ally's action pool."},
	{ "name": "Confounding Gesture","target/test": ["Enemy","strength"],"range": [1,7],"effect": "Target foe performs a hard ST test. If failed, they discard 3 action (attack or movement) cards from their action pool."},
	{ "name": "Unified Purpose","target/test": ["Ally","charismamedium"],"range": [0,0],"effect": "Perform a medium CH-LO test. If successful, all allies add 2 attack cards and 2 movement cards to their action pool."},
]

var T4Abilities = [
	{ "name": "Demoralisation","target/test": ["Ally","charismahard"],"range": [0,0],"effect": "Perform a hard CH-LO test. If successful, all foes within 4 range discard 3 cast cards from their action pool."},
	{ "name": "Chaotic Blunders","target/test": ["Enemy","agilityhard"],"range": [1,4],"effect": "All foes within 4 range perform a hard SP test. If failed, they discard 3 attack cards from their action pool."},
	{ "name": "Stand and Fight","target/test": ["Ally","charismahard"],"range": [0,0],"effect": "Perform a hard CH-LO test. If successful, one ally within 4 range adds 5 attack cards to their action pool."},
	{ "name": "Mental Anahilation","target/test": ["Enemy","intellecthard"],"range": [0,0],"effect": "Perform a hard KN-PO test. If successful, all foes within 4 range switch sides for the current turn."},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	loader()
	#print(abilities)
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
