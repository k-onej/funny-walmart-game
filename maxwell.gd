extends Area2D

@onready var model = $SubViewport/Sketchfab_Scene/Sketchfab_model

@onready var player_globals = get_node("/root/PlayerGlobals")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	model.rotate_y(0.0125)


func _on_body_entered(body):
	if body.name == "Player":
		player_globals.has_maxwell = true
		print("you got maxwell!")
		queue_free()
