extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game: Node = load("res://game.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var buses := ["Background Music", "Battle Audio", "Interface SFX"]
	var indices: Array[int] = []
	for bus_name in buses:
		indices.append(AudioServer.get_bus_index(bus_name))
	assert(indices.all(func(index: int) -> bool: return index >= 0), "three named audio buses load")
	assert(indices[0] != indices[1] and indices[1] != indices[2] and indices[0] != indices[2], "audio buses are distinct")
	var options := game.get_node("AudioOptions")
	var music := options.get_node("AudioPanel/Margin/Controls/MusicRow/MusicSlider") as HSlider
	var battle := options.get_node("AudioPanel/Margin/Controls/BattleRow/BattleSlider") as HSlider
	var interface_sfx := options.get_node("AudioPanel/Margin/Controls/InterfaceRow/InterfaceSlider") as HSlider
	music.value = 50.0
	var music_db := AudioServer.get_bus_volume_db(indices[0])
	assert(is_equal_approx(music_db, linear_to_db(0.5)), "background music level updates")
	battle.value = 25.0
	assert(is_equal_approx(AudioServer.get_bus_volume_db(indices[1]), linear_to_db(0.25)), "battle level updates independently")
	assert(is_equal_approx(AudioServer.get_bus_volume_db(indices[0]), music_db), "battle change preserves music level")
	interface_sfx.value = 75.0
	assert(is_equal_approx(AudioServer.get_bus_volume_db(indices[2]), linear_to_db(0.75)), "interface SFX level updates independently")
	music.value = 0.0
	assert(is_equal_approx(AudioServer.get_bus_volume_db(indices[0]), -80.0), "zero slider mutes its channel")
	assert(AudioServer.get_bus_send(indices[0]) == "Master", "music bus routes to master")
	var players := game.find_children("*", "AudioStreamPlayer", true, false)
	assert(game.get_node("Exploration/Grid/Player") != null, "exploration scene remains present")
	print("PASS: 9 audio routing and configuration checks; audio players in game: %d" % players.size())
	quit(0)
