extends CharacterBody2D


@export var max_speed := 500
@export var accel := 150
@export var decel := 0.2
@export var gravity := 5000
@export var max_fall_speed := 60000

@onready var spawn_position := position

@onready var sprite = $AnimatedSprite2D

@onready var player_globals = $"/root/PlayerGlobals"


func _physics_process(delta):
	print(player_globals.has_maxwell)
	if up_direction == Vector2.UP:
		sprite.flip_v = false
	elif up_direction == Vector2.DOWN:
		sprite.flip_v = true
	
	# Add the gravity, gravity direction changes based on up direction
	if not is_on_floor():
		if up_direction == Vector2.UP:
			velocity.y = min(velocity.y + gravity * delta, max_fall_speed * delta)
		if up_direction == Vector2.DOWN:
			velocity.y = max(velocity.y - gravity * delta, -max_fall_speed * delta)

	# Handle switching gravity.
	if Input.is_action_just_pressed("switch_gravity") and is_on_floor():
		if up_direction == Vector2.UP:
			set_up_direction(Vector2.DOWN)
			velocity.y = 1
		elif up_direction == Vector2.DOWN:
			set_up_direction(Vector2.UP)
			velocity.y = -1

	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		velocity.x = min(velocity.x + accel * direction, max_speed * direction)
		sprite.flip_h = false
		sprite.play("run")
	elif direction < 0:
		velocity.x = max(velocity.x + accel * direction, max_speed * direction)
		sprite.flip_h = true
		sprite.play("run")
	else:
		velocity.x = lerp(velocity.x, 0.0, decel)
		sprite.play("idle")
	
	move_and_slide()
	
func die():
	position = spawn_position
	set_up_direction(Vector2.UP)
	velocity = Vector2(0, 0)
	
func set_spawn(x:float = position.x, y:float = position.y):
	spawn_position = Vector2(x, y)
