extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("spike")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frame == 0:
		$Danger/Collision.set_deferred("disabled", false)
	else:
		$Danger/Collision.set_deferred("disabled", true)
