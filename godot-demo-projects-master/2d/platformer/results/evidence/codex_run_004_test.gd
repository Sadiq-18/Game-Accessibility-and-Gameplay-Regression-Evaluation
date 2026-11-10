extends SceneTree

var failures := 0


func _initialize() -> void:
	call_deferred("_run_checks")


func _check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: ", message)
	else:
		failures += 1
		push_error("FAIL: " + message)


func _run_checks() -> void:
	var buses := ["Master", "Music", "SFX"]
	var buses_exist := true
	for bus_name in buses:
		if AudioServer.get_bus_index(bus_name) < 0:
			buses_exist = false
	_check(buses_exist, "Master, Music, and SFX buses are available")
	var menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(menu)
	await process_frame
	var controls := {
		"Master": menu.mute_controls.get_node("MasterMute") as CheckButton,
		"Music": menu.mute_controls.get_node("MusicMute") as CheckButton,
		"SFX": menu.mute_controls.get_node("SFXMute") as CheckButton,
	}
	_check(controls.size() == 3 and controls["Master"].visible and controls["Music"].visible and controls["SFX"].visible, "mute toggles for all three buses are visible")
	var sfx_index := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, -7.0)
	controls["SFX"].button_pressed = true
	controls["SFX"].toggled.emit(true)
	_check(AudioServer.is_bus_mute(sfx_index), "SFX mute toggle mutes the selected bus")
	_check(is_equal_approx(AudioServer.get_bus_volume_db(sfx_index), -7.0), "muting preserves the prior SFX volume")
	var music_index := AudioServer.get_bus_index("Music")
	controls["Music"].button_pressed = true
	controls["Music"].toggled.emit(true)
	_check(AudioServer.is_bus_mute(music_index) and AudioServer.is_bus_mute(sfx_index), "Music and SFX mute independently")
	controls["SFX"].button_pressed = false
	controls["SFX"].toggled.emit(false)
	_check(not AudioServer.is_bus_mute(sfx_index), "unmuting restores SFX output")
	_check(is_equal_approx(AudioServer.get_bus_volume_db(sfx_index), -7.0), "unmuting restores the exact previous SFX volume")
	var master_index := AudioServer.get_bus_index("Master")
	controls["Master"].button_pressed = true
	controls["Master"].toggled.emit(true)
	_check(AudioServer.is_bus_mute(master_index) and AudioServer.is_bus_mute(music_index), "Master mute affects the full mix without clearing Music's mute state")
	menu.queue_free()
	await process_frame
	var second_menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(second_menu)
	await process_frame
	_check(second_menu.mute_controls.get_node("MasterMute").button_pressed, "mute preference persists into a new pause menu instance")
	_check(AudioServer.is_bus_mute(master_index), "bus mute state persists across menu instances")
	var game := (load("res://game_singleplayer.tscn") as PackedScene).instantiate() as Game
	root.add_child(game)
	var pause_event := InputEventAction.new()
	pause_event.action = &"toggle_pause"
	pause_event.pressed = true
	game._unhandled_input(pause_event)
	game._unhandled_input(pause_event)
	_check(not paused and AudioServer.is_bus_mute(master_index), "pause/resume and muted audio state remain independent")
	var player := game.get_node("Level/Player") as Player
	await physics_frame
	await physics_frame
	player.position.y -= 100.0
	player._double_jump_charged = true
	await physics_frame
	player.try_jump()
	_check(player.velocity.y < 0.0, "jump/gameplay logic still runs while audio is muted")

	if failures == 0:
		print("RESULT: PASS; mute controls and selected gameplay regression checks passed.")
	else:
		print("RESULT: FAIL; ", failures, " check(s) failed.")
	for child in root.get_children():
		child.queue_free()
	await process_frame
	call_deferred("quit", 0 if failures == 0 else 1)
