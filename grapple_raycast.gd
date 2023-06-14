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
	if $"..".grapple_state == GrappleState.NOT_GRAPPLED:
		target_position_absolute = get_global_mouse_position() - Vector2.ONE * player_size * 0.5
	else:
		target_position_absolute = $"..".grapple_position - Vector2.ONE * player_size * 0.5
	target_position = (target_position_absolute  - player_position).normalized() * MAX_RAYCAST_DISTANCE
	position = Vector2.ONE * player_size * 0.5
