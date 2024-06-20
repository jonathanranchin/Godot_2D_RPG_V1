extends CharacterBody2D

var chara
var enemies
const SPEED = 96.0
var movecapital
var range_array = [26,35,40,46,56,65,75,85,95,105,115,124,134,144] #14 ranges
var life_pool = "lbplllll"
var status = "active"
var healed # animation keyword
var shielded # animation keyword
var struck # animation keyword
var buffed # animation keyword
var debuffed # animation keyword
var shield_active
var local
var en_storage = [
	[
		{
			"name":"Luther",
			"class":"Axe",
			"behavior":"def_leader",
			"strength":2,
			"intellect":1,
			"agility":4,
			"charisma":1,
			"life_pool":["lllllllllbbpppb","lllllllllbbpppb"],
			"action_pool":[["T1C","ATK","ATK","ATK","ATK","YARD","YARD","YARD","YARD","YARD","AC","YARD"],[]],
			"action_hand":[],
			"background":"Former soldier from the countryside, joined the Black Hand for adventure.",
			"weapon":{"name":"Hatchet","damage":2,"range":2},
			"armor":{"name":"Sailors' Garb","life_pool":"b","action_deck":"YARD","damage_reduction":0,"price":5},
			"dialogue": "Gytro be a liar! \n Varik will be skining him soon enarhf!",
			"surrendered": "All I be knowing iz that,\n the captain had a letter somewhere.",
		},
		{
			"name":"Vera",
			"class":"Axe",
			"behavior":"def_leader",
			"strength":1,
			"intellect":2,
			"agility":3,
			"charisma":3,
			"life_pool":["llllllbppb","llllllbppb"],
			"action_pool":[["T1C","T1C","T1C","T2C","T2C","T3C","ATK","ATK","YARD","YARD","YARD","AC","AC","AC","YARD"],[]],
			"action_hand":[],
			"background":"Former barmaid with a knack for getting into trouble, joined the Black Hand for excitement.",
			"weapon":{"name":"Hatchet","damage":2,"range":2},
			"armor":{"name":"Sailors' Garb","life_pool":"b","action_deck":"YARD","damage_reduction":0,"price":5},
			"dialogue": "You look good stranger. \n Surrender I'll take good care of you !",
			#medium CH-LO check.
			"surrendered": "Twas a nobleman, who hired the cap. I never saw.",
		},
		{
			"name":"Captain Varik",
			"class":"Enemy_Leader",
			"behavior":"slay_neutral",
			"strength":4,
			"intellect":1,
			"agility":2,
			"charisma":1,
			"life_pool":["lllllllllllllbbbppbbp","lllllllllllllbbbppbbp"],
			"action_pool":[["T1C","ATK","ATK","YARD","YARD","YARD","AC","YARD"],[]],
			"action_hand":[],
			"background":"Former soldier from the countryside, joined the Black Hand recently.",
			"weapon":{"name":"Heavy Longsword","damage":4,"range":3},
			"armor":{"name":"Armored sailor's suit","life_pool":"bbp","action_deck":"YARD","damage_reduction":1,"price":50},
			"dialogue": "I'll have yer head Gytro.\n Surrender, I'll take good care of yee !",
			#medium CH-LO check.
			"surrendered": "Twas a nobleman, who hired the cap. I never saw.",
		},
		{
			"name":"Kara",
			"class":"Bow",
			"behavior":"kiter",
			"strength":1,
			"intellect":2,
			"agility":3,
			"charisma":2,
			"life_pool":["llllllbppb","llllllbppb"],
			"action_pool":[["T1C","T1C","T2C","ATK","ATK","ATK","YARD","YARD","YARD","YARD","AC","AC","YARD"],[]],
			"action_hand":[],
			"background":"Street-smart and agile, used to be a scout for a noble's household.",
			"weapon":{"name":"Short Bow","damage":2,"range":12},
			"armor":{"name":"Sailors' Garb","life_pool":"b","action_deck":"YARD","damage_reduction":0,"price":5},
			"dialogue": "Stays silent.",
			"surrendered": "Remains silent.",
		},
		{
			"name":"Braxton",
			"class":"Bow",
			"behavior":"kiter",
			"strength":2,
			"intellect":1,
			"agility":3,
			"charisma":1,
			"life_pool":["lllllllllbbppb","lllllllllbbppb"],
			"action_pool":[["T1C","ATK","ATK","ATK","YARD","YARD","YARD","YARD","AC","YARD"],[]],
			"action_hand":[],
			"background":" Ex-forester with a knack for survival, joined the pirates for a chance at riches.",
			"weapon":{"name":"Short Bow","damage":2,"range":12},
			"armor":{"name":"Sailors' Garb","life_pool":"b","action_deck":"YARD","damage_reduction":0,"price":5},
			"dialogue": "I'll feather ya full of arrows.",
			"surrendered": "I'm just here for coin,\nplease let ma go!",
		}
	]
]
@export var player: CharacterBody2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	for elements in en_storage:
		for element in elements:
			if element.name == name:
				local = element
				#prints(local.name, local.agility)
	

func _physics_process(_delta: float) -> void:
	if movecapital == 105:
		makepath()
	if self == get_parent().get_parent().active_character and status=="active":
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		if(movecapital>0):
			$AnimatedSprite2D.flip_h = true
			velocity = dir*SPEED
			movecapital = movecapital -1
			$AnimatedSprite2D.animation = "walk_left"
		if(movecapital==0):
			$AnimatedSprite2D.animation = "default"
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			end_turn()
	else:
		$AnimatedSprite2D.animation = "default"
		if struck == 1:
			$AnimatedSprite2D.animation = "struck"
	move_and_slide()

func makepath() -> void:
	var tar
	var dist = 100000
	for character in chara:
		#navigation_agent.target_position = $"../../Characters/character1".global_position
		navigation_agent.target_position = character.global_position
		var distance = navigation_agent.distance_to_target()
		if(distance<dist):
			dist = distance
			tar = character
		#print(distance)
	navigation_agent.target_position = tar.global_position

# Function to simulate taking damage by randomly removing characters from the life pool
func take_damage(damage_amount,special):
	var random = RandomNumberGenerator.new()  # Create a random number generator
	random.randomize()  # Seed the RNG with a random value

	# Convert the life pool string into an array for easier manipulation
	var life_pool_array = []
	for char in life_pool:
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
	life_pool = "".join(life_pool_array)

	# Check if there are any 'l' characters left in the updated life pool
	if 'l' not in life_pool:
		$AnimatedSprite2D.animation = "death"
		while $AnimatedSprite2D.is_playing():
			await(get_tree().create_timer(0.1).timeout)
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.stop()
		status = "dead"
		return "Dead"
	print(life_pool)
	return life_pool  # Otherwise, return the updated life pool

func end_turn():
	var level = get_parent().get_parent()
	level.next_character()
