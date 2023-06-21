extends Node2D

@export var PIXEL_SIZE: float = 1.0
#@export var MULT: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	_draw_pixel_circle(50.0, PIXEL_SIZE, Color.from_hsv(0, 0, 1, 1))

func _draw_pixel_circle(radius: float, pixel_size: float, color: Color):
	var mult = 0.75 + pixel_size / radius * 0.5
	var steps: float = radius * mult / pixel_size
	for i in range(steps):
		var pos: Vector2 = snapped(Vector2(i * pixel_size, _circle_pos(i * mult / steps) * radius), Vector2(pixel_size, pixel_size))
		_place_pixel((Vector2(pos.x, pos.y)), pixel_size, color)
		_place_pixel((Vector2(pos.y, pos.x)), pixel_size, color)
		_place_pixel((Vector2(pos.y, -pos.x)), pixel_size, color)
		_place_pixel((Vector2(pos.x, -pos.y)), pixel_size, color)
		_place_pixel((Vector2(-pos.x, pos.y)), pixel_size, color)
		_place_pixel((Vector2(-pos.y, pos.x)), pixel_size, color)
		_place_pixel((Vector2(-pos.y, -pos.x)), pixel_size, color)
		_place_pixel((Vector2(-pos.x, -pos.y)), pixel_size, color)


func _circle_pos(x: float):
	return sqrt(1.0 - x*x)


func _place_pixel(pos: Vector2, size: float, color: Color):
	draw_rect(Rect2(pos - Vector2(size, size) * 0.5,  Vector2(size, size)), color)
