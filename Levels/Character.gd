extends CharacterBody2D

const SPEED = 96.0

func _physics_process(delta):
	var horizontal_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Horizontal movement
	if horizontal_direction != 0:
		velocity.x = horizontal_direction * SPEED
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
		velocity.y = vertical_direction * SPEED
		if vertical_direction > 0:
			$AnimatedSprite2D.animation = "walk_down"
		else:
			$AnimatedSprite2D.animation = "walk_up"
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if horizontal_direction == 0 and vertical_direction == 0:
		$AnimatedSprite2D.animation = "default"
	move_and_slide()

func play_turn():
	print("Swag")
	return("Completed")
