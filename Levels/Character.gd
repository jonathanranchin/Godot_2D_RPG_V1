extends CharacterBody2D

const SPEED = 96.0
var movecapital = 105
var val1 = 0 
var val2 = 0
var previous_position = Vector2.ZERO

func _ready():
	print(movecapital)

func _physics_process(delta):
	var horizontal_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Only move if this character is the active character
	if self == get_parent().active_character:
		# Horizontal movement
		#position = Vector2(179.0, 156.0)
		if horizontal_direction != 0:
			if(movecapital>0):
				velocity.x = horizontal_direction * SPEED
				movecapital = movecapital -1
				#print("Horizontal move "+ str(movecapital))
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
		
		# Set default animation if not moving
		if horizontal_direction == 0 and vertical_direction == 0:
			$AnimatedSprite2D.animation = "default"
		
		move_and_slide()


# Function to handle the end turn action
func end_turn():
	movecapital = 105
	var level = get_parent()
	level.next_character()

