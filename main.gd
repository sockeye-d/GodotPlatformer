extends Node

func reset():
	var pos := Vector2(0.0, -100.0)
	$Player.reset(pos)
	$MainCamera.reset(pos, 500.0)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(delta):
	pass

