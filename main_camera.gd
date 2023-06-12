extends Camera2D

@export var SMOOTHING := 0.1

var smooth_position: Vector2
var shake_position: Vector2

const _SQRT_2 = 1.4142135624
const _SQRT_3 = 1.7320508076

func shake(strength: float, speed: float, curve: float, time: float, interval: float):
	$ShakeTimer.start(time)
	while not $ShakeTimer.is_stopped():
		var pos_mult = (1 - ease(1 - $ShakeTimer.time_left / time, curve)) * strength
		var t = Time.get_ticks_msec() / 1000.0 * speed 
		shake_position = Vector2(sin(t) + sin(_SQRT_2 * t), cos(t) + cos(_SQRT_3 * t)) * pos_mult
		await get_tree().create_timer(interval).timeout
	shake_position = Vector2.ZERO
	return

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
	smooth_position.x = exp_damp(smooth_position.x, ($"../Player").position.x, SMOOTHING, delta)
	smooth_position.y = exp_damp(smooth_position.y, ($"../Player").position.y, SMOOTHING, delta)
	position = smooth_position + shake_position
	
