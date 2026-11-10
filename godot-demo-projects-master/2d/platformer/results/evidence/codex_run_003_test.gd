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
	var music_bus := AudioServer.get_bus_index("Music")
	var sfx_bus := AudioServer.get_bus_index("SFX")
	_check(music_bus >= 0 and sfx_bus >= 0 and music_bus != sfx_bus, "Music and SFX have independent audio buses")
	var menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(menu)
	await process_frame
	_check(menu.master_slider != null and menu.music_slider != null and menu.sfx_slider != null, "Master, Music, and SFX sliders appear in the pause menu")
	var sfx_before := AudioServer.get_bus_volume_db(sfx_bus)
	menu.music_slider.value = 0.25
	await process_frame
	_check(is_equal_approx(AudioServer.get_bus_volume_db(music_bus), linear_to_db(0.25)), "Music slider immediately changes the Music bus")
	_check(is_equal_approx(AudioServer.get_bus_volume_db(sfx_bus), sfx_before), "changing Music volume leaves SFX volume unchanged")
	menu.sfx_slider.value = 0.4
	menu.master_slider.value = 0.6
	await process_frame
	_check(is_equal_approx(AudioServer.get_bus_volume_db(sfx_bus), linear_to_db(0.4)), "SFX slider changes only the SFX bus")
	_check(is_equal_approx(AudioServer.get_bus_volume_db(0), linear_to_db(0.6)), "Master slider controls the Master bus")
	var music_player := (load("res://music.tscn") as PackedScene).instantiate() as AudioStreamPlayer
	_check(music_player.bus == "Music", "background music routes to the Music bus")
	music_player.queue_free()
	var player_scene := load("res://player/player.tscn") as PackedScene
	var player := player_scene.instantiate() as Player
	root.add_child(player)
	_check(player.jump_sound.bus == "SFX" and player.gun.sound_shoot.bus == "SFX", "jump and shoot effects route to SFX")
	var coin := (load("res://level/coin.tscn") as PackedScene).instantiate() as Coin
	root.add_child(coin)
	_check(coin.get_node("Pickup").bus == "SFX", "coin pickup effect routes to SFX")
	menu.queue_free()
	player.queue_free()
	coin.queue_free()
	await process_frame
	var next_scene_menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(next_scene_menu)
	await process_frame
	_check(is_equal_approx(next_scene_menu.music_slider.value, 0.25) and is_equal_approx(next_scene_menu.sfx_slider.value, 0.4), "Music and SFX levels persist into a new scene's menu")
	_check(is_equal_approx(AudioServer.get_bus_volume_db(music_bus), linear_to_db(0.25)), "Music bus level persists across menu instances")

	if failures == 0:
		print("RESULT: PASS; independent audio controls and persistence checks passed.")
	else:
		print("RESULT: FAIL; ", failures, " check(s) failed.")
	for child in root.get_children():
		child.queue_free()
	await process_frame
	call_deferred("quit", 0 if failures == 0 else 1)
