extends CharacterBody2D


@export var speed := 1000
@export var accel := 1400
@export var gravity := 70000
@export var max_fall_speed := 120000

@onready var spawn_position = position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if up_direction == Vector2.UP:
			velocity.y = min(velocity.y + gravity * delta, max_fall_speed * delta)
		if up_direction == Vector2.DOWN:
			velocity.y = max(velocity.y - gravity * delta, -max_fall_speed * delta)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if up_direction == Vector2.UP:
			set_up_direction(Vector2.DOWN)
		elif up_direction == Vector2.DOWN:
			set_up_direction(Vector2.UP)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if Input.is_action_just_pressed("ui_cancel"):
		die()
	if Input.is_action_just_pressed("ui_focus_next"):
		spawn_position = position
	
	move_and_slide()
	
func die():
	position = spawn_position
	set_up_direction(Vector2.UP)
