extends CharacterBody2D


@export var max_speed := 1000
@export var accel := 300
@export var decel := 0.4
@export var gravity := 70000
@export var max_fall_speed := 120000

@onready var spawn_position = position

@onready var sprite = $Sprite2D

func _physics_process(delta):
	print(velocity.x)
	# Add the gravity, gravity direction changes based on up direction
	# BUG: player slides slowly and is_on_floor() returns true when switching gravity while moving against wall
	if not is_on_floor():
		if up_direction == Vector2.UP:
			velocity.y = min(velocity.y + gravity * delta, max_fall_speed * delta)
			sprite.flip_v = false
		if up_direction == Vector2.DOWN:
			velocity.y = max(velocity.y - gravity * delta, -max_fall_speed * delta)
			sprite.flip_v = true

	# Handle switching gravity.
	if Input.is_action_just_pressed("switch_gravity") and is_on_floor():
		if up_direction == Vector2.UP:
			set_up_direction(Vector2.DOWN)
		elif up_direction == Vector2.DOWN:
			set_up_direction(Vector2.UP)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		velocity.x = min(velocity.x + accel * direction, max_speed)
		sprite.flip_h = false
	elif direction < 0:
		velocity.x = max(velocity.x + accel * direction, -max_speed)
		sprite.flip_h = true
	else:
		velocity.x = lerp(velocity.x, 0.0, decel)
	
	move_and_slide()
	
func die():
	position = spawn_position
	set_up_direction(Vector2.UP)
	
func set_spawn(x:float = position.x, y:float = position.y):
	spawn_position = Vector2(x, y)
