extends Node

func reset():
	var pos := Vector2(0.0, -100.0)
	$Player.emit_death_particles()
	$Player.call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
	$Player/Visual.hide()
	$MainCamera.shake(2.0, 200.0, 0.2, $RespawnTimer.wait_time, 0.01)
	$DeathAudio.play()
	
	$RespawnTimer.start()
	await $RespawnTimer.timeout
	
	$Player.reset(pos)
	$MainCamera.reset(pos, 500.0)
	$Player.call_deferred("set_process_mode", PROCESS_MODE_INHERIT)
	$Player/Visual.show()


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(delta):
	pass

