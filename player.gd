extends CharacterBody2D

signal death

@export var GROUND_SPEED := 400.0
@export var AIR_SPEED := 400.0
@export var JUMP_VELOCITY := 400.0
@export var GROUND_FRICTION := 8.0
@export var AIR_FRICTION := 1.0
@export var MOVE_WHEN_IN_AIR := true
@export var COYOTE_TIME := 0.2
@export var GRAVITY_MULT := 1.0
@export var GRAPPLE_STRENGTH := 50.0
@export var VELOCITY_MULTIPLY := 1.0
@export var SIZE := 16
@export var MAX_VELOCITY := 1000.0

enum GrappleState {
	NOT_GRAPPLED,
	ANIMATING_TO,
	GRAPPLED,
	ANIMATING_FROM,
}

var coyote_time := COYOTE_TIME
var jumped := false

var grapple_state := GrappleState.NOT_GRAPPLED
var grapple_position := Vector2.ZERO

var frame_aligned_position: Vector2 = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Do standard platformer physics
	var on_floor := is_on_floor()
	var friction := GROUND_FRICTION if on_floor else AIR_FRICTION
	var speed := GROUND_SPEED if on_floor else AIR_SPEED
	if not on_floor:
		velocity.y += gravity * delta * GRAVITY_MULT
	
	if on_floor:
		coyote_time = COYOTE_TIME
	else:
		coyote_time -= delta

	if Input.is_action_pressed("up") and coyote_time > 0.0 and not jumped:
		velocity.y = -JUMP_VELOCITY
		jumped = true
	
	if not Input.is_action_pressed("up"):
		jumped = false

	var direction = Input.get_axis("left", "right")
	if direction:
		if MOVE_WHEN_IN_AIR:
			velocity.x += (speed * friction * direction * delta)
		elif on_floor:
			velocity.x += (speed * friction * direction * delta)
		
	velocity.x += (0.0 - velocity.x) * delta * (GROUND_FRICTION if on_floor else AIR_FRICTION)
	
	# Now do grappling hook physics
	if Input.is_action_just_pressed("grapple") and $GrappleRaycast.is_colliding():
		grapple_state = GrappleState.ANIMATING_TO
		grapple_position = $GrappleRaycast.get_collision_point()
		$GrappleAnimationTimer.start()
	elif Input.is_action_just_released("grapple") and not grapple_state == GrappleState.NOT_GRAPPLED:
		grapple_state = GrappleState.ANIMATING_FROM
		$GrappleAnimationTimer.start()
	


	#var grapple_collision_point = $GrappleRaycast.get_collision_point()
	
	#if abs(grapple_collision_point - grapple_position).length() > 1:
	#	if position.distance_squared_to(grapple_collision_point) < position.distance_squared_to(grapple_position):
	#		grapple_position = grapple_collision_point

	var grapple_direction: Vector2 = ((position + Vector2.ONE*SIZE*0.5) - grapple_position)
	grapple_direction = grapple_direction.normalized() * min(1.0, grapple_direction.length())
	
	if grapple_state == GrappleState.ANIMATING_TO or grapple_state == GrappleState.GRAPPLED:
		velocity -= grapple_direction * GRAPPLE_STRENGTH * delta
	
	velocity = velocity.limit_length(MAX_VELOCITY)
	
	velocity *= VELOCITY_MULTIPLY
	move_and_slide()
	velocity /= VELOCITY_MULTIPLY
	
	_set_animation()

func _set_animation():
	var direction = Input.get_axis("left", "right")
	if direction:
		$Visual.flip_h = direction < 0
	if direction and is_on_floor():
		$Visual.play("walk")
	else:
		$Visual.play("idle")


func _process(delta):
	frame_aligned_position = position


func reset(pos: Vector2):
	velocity = Vector2.ZERO
	position = pos
	frame_aligned_position = position
	grapple_state = GrappleState.NOT_GRAPPLED


func emit_death_particles():
	var particles = $DeathParticles.duplicate()
	particles.process_mode = Node.PROCESS_MODE_ALWAYS
	particles.show()
	particles.emitting = true
	add_child(particles)
	while true:
		if not particles.emitting
			particles.queue_free()
			break
		await get_tree().create_timer(0.5).timeout

func _on_danger_body_entered(body):
	death.emit()


func _on_grapple_animation_timer_timeout() -> void:
	if grapple_state == GrappleState.ANIMATING_TO:
		grapple_state = GrappleState.GRAPPLED
	elif grapple_state == GrappleState.ANIMATING_FROM:
		grapple_state = GrappleState.NOT_GRAPPLED
