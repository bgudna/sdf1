extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const FRICTION = 1000
const ACCELERATION = 800

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	add_gravity(delta)
	handle_jumping()
	var input_axis = Input.get_axis("ui_left", "ui_right")
	
	handle_speedup(input_axis, delta)
	apply_some_friction(input_axis, delta)


	move_and_slide()

func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jumping():
		if is_on_floor():
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
		else:
			if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2 :
				velocity.y = JUMP_VELOCITY / 2

func apply_some_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func handle_speedup(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
