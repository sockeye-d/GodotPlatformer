extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position =  round($"..".position) + Vector2.ONE * $"..".SIZE * 0.5 - $"..".position
