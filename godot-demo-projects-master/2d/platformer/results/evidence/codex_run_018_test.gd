extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	AudioServer.set_bus_mute(0, false)
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud := main.get_node("HUD")
	var button := hud.get_node("MuteAudioButton") as CheckButton
	assert(button != null and button.text == "Mute audio", "one-click mute control exists")
	assert(not AudioServer.is_bus_mute(0), "master audio starts unmuted")
	hud.call("_on_mute_toggled", true)
	assert(AudioServer.is_bus_mute(0), "toggle mutes master output immediately")
	assert(main.get_node("Music").bus == "Master", "music routes through muted master")
	assert(main.get_node("DeathSound").bus == "Master", "death sound routes through muted master")
	hud.call("_on_mute_toggled", false)
	assert(not AudioServer.is_bus_mute(0), "toggle restores all game audio")
	assert(main.get_node("Player") != null, "player remains available after muting")
	AudioServer.set_bus_mute(0, false)
	print("PASS: 7 mute and regression assertions")
	quit(0)
