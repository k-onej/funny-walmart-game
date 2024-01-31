# AWESOME DEVELOPER NOTE TO SELF: THE THING WHERE YOU CAN SLIDE ON WALLS IS INTENTIONAL.
# I AM SURE THERE IS AN EASY FIX FOR IT BUT I THINK IT'S COOL SO IDC. :3

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

	# Handle switching gravity.
	if Input.is_action_just_pressed("switch_gravity") and is_on_floor():
		if up_direction == Vector2.UP:
			set_up_direction(Vector2.DOWN)
		elif up_direction == Vector2.DOWN:
			set_up_direction(Vector2.UP)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
func die():
	position = spawn_position
	set_up_direction(Vector2.UP)
	
func set_spawn(x:float = position.x, y:float = position.y):
	spawn_position = Vector2(x, y)
