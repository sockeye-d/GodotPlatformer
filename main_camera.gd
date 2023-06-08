extends Camera2D

var smooth_position: Vector2

func reset(pos: Vector2, threshold: float):
	if position.distance_to(pos) > threshold:
		position = pos
		smooth_position = pos

func exp_damp(source: float, target: float, smoothing: float, dt: float):
	return lerp(source, target, 1 - (smoothing ** dt))

# Called when the node enters the scene tree for the first time.
func _ready():
	smooth_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	smooth_position.x = exp_damp(smooth_position.x, ($"../Player").position.x, 0.1, delta)
	smooth_position.y = exp_damp(smooth_position.y, ($"../Player").position.y, 0.1, delta)
	position = smooth_position
	
