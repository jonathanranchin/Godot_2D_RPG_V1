extends Resource
class_name Party

@export var party_number: int
@export var characters: Array = [
{ "strength": 1,"intellect": 1,"agility": 1,"charisma": 1},
{"strength": 1,"intellect": 1,"agility": 1,"charisma": 1},
{"strength": 1,"intellect": 1,"agility": 1,"charisma": 1},
{"strength": 1,"intellect": 1,"agility": 1,"charisma": 1}
]
@export var life_pools: Array = [["",""],["",""],["",""],["",""]]
@export var action_deck: Array = [[],[],[],[]]
@export var spellnums: Array = [
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
{ "T1S": [0,0],"T2S": [0,0],"T3S": [0,0],"T4S": [0,0]},
]
@export var abilities: Array = [
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
{ "T1A": [0,0],"T2A": [0,0],"T3A": [0,0],"T4A": [0,0]},
]
@export var names: Array = ["","","",""]
@export var progression: float = 1.0
@export var quests: Array = []

func create_characters():
	for n in range(0,4):
		var character = {
			"PartyNumber" = party_number,
			"Name" = names[n],
			"Strength" = characters[n]["strength"],
			"Intellect" = characters[n]["intellect"],
			"Agility" = characters[n]["agility"],
			"Charisma" = characters[n]["charisma"],
			"TheoriticalLifePool"  = life_pools[n][0],
			"TheoreticalActionDeck" = action_deck[n],
			
		}

