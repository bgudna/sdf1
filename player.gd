extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const FRICTION = 1000
const ACCELERATION = 800

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var c_jump_timer = $CJumpTimer

func _physics_process(delta):
	add_gravity(delta)
	handle_jumping()
	var input_axis = Input.get_axis("ui_left", "ui_right")
	
	handle_speedup(input_axis, delta)
	apply_some_friction(input_axis, delta)
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		c_jump_timer.start()

func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jumping():
		if is_on_floor() or c_jump_timer.time_left > 0.0:
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2 :
				velocity.y = JUMP_VELOCITY / 2

func apply_some_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func handle_speedup(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)

func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")
