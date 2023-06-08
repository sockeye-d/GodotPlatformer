extends Line2D

@export var PIXEL_SIZE := 10
@export var STRETCH := 0.01

const GrappleState = preload("res://player.gd").GrappleState


func _ready():
	pass


func _process(delta: float):
	if $"..".grapple_state == GrappleState.GRAPPLED:
		show()
	else:
		hide()
	queue_redraw()


func _draw():	
	var origin: Vector2 = ($"../GrappleRaycast").position
	var end: Vector2 = $"..".grapple_position - ($"..").position
	var thickness_function = func (x):
		return 2 + (1 - (2 * x - 1) ** 2) ** 2 / (-max(1, origin.distance_to(end)*STRETCH))
	_draw_line(origin, end, thickness_function)

	#width_curve.set_point_value(1, 1 / (max(1, origin.distance_to(end)*STRETCH)))


func _draw_line(start: Vector2, end: Vector2, thickness):
	var offset = abs(end - start)
	if offset.x > offset.y:
		_draw_line_x(start, end, thickness)
	else:
		_draw_line_y(start, end, thickness)


func _draw_line_x(start: Vector2, end: Vector2, thickness):
	var loop = abs(end.x - start.x) / PIXEL_SIZE
	for i in range(loop):
			var pos: Vector2
			pos.x = start.x + i * PIXEL_SIZE * sign(end.x - start.x)
			pos.y = snapped(lerp(start.y, end.y, i / loop), PIXEL_SIZE)
			var thickness_real = thickness.call(i / loop)
			draw_rect(Rect2(pos, Vector2(PIXEL_SIZE, PIXEL_SIZE) * thickness_real), Color.WHITE)


func _draw_line_y(start: Vector2, end: Vector2, thickness):
	start = Vector2(start.y, start.x)
	end = Vector2(end.y, end.x)
	var loop = abs(end.x - start.x) / PIXEL_SIZE
	for i in range(loop):
			var pos: Vector2
			pos.y = start.x + i * PIXEL_SIZE * sign(end.x - start.x)
			pos.x = snapped(lerp(start.y, end.y, i / loop), PIXEL_SIZE)
			var thickness_real = thickness.call(i / loop)
			draw_rect(Rect2(pos, Vector2(PIXEL_SIZE, PIXEL_SIZE) * thickness_real), Color.WHITE)