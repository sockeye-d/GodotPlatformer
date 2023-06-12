extends RayCast2D

@export var MAX_RAYCAST_DISTANCE := 2000.0

const GrappleState = preload("res://player.gd").GrappleState

var target_position_absolute: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_size = $"..".SIZE
	var player_position: Vector2 = $"..".position
	target_position = (get_global_mouse_position() - Vector2.ONE * player_size * 0.5 - player_position).normalized() * MAX_RAYCAST_DISTANCE
	position = Vector2.ONE * player_size * 0.5
	
	#$"../Label".text = str(get_collider_shape())
