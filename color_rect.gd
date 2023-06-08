extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = ($"../GrappleRaycast".target_position - $"..".position) / $"../GrappleRaycast".MAX_RAYCAST_DISTANCE * 100.0
