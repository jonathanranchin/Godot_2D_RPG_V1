extends CharacterBody2D

var chara
var enemies
const SPEED = 96.0
var movecapital
var range_array = [26,35,40,46,56,65,75,85,95,105,115,124,134,144] #14 ranges
var Name = "Jack"
var life_pool = "lbplllll"
var status = "active"
var healed # animation keyword
var shielded # animation keyword
var struck # animation keyword
var buffed # animation keyword
var debuffed # animation keyword
var shield_active
@export var player: CharacterBody2D
@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D


func _physics_process(_delta: float) -> void:
	if movecapital == 105:
		makepath()
	if self == get_parent().get_parent().active_character and status=="active":
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		if(movecapital>0):
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


func _ready():
	#makepath()
	pass

func end_turn():
	var level = get_parent().get_parent()
	level.next_character()
