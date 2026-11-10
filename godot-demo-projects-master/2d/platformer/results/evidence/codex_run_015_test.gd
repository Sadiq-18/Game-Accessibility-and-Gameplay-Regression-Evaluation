extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var bgm_index := AudioServer.get_bus_index("BGM")
	var sfx_index := AudioServer.get_bus_index("SFX")
	assert(bgm_index >= 0 and sfx_index >= 0 and bgm_index != sfx_index, "independent BGM and SFX buses exist")
	assert(main.get_node("Music").bus == "BGM", "music routes to BGM bus")
	assert(main.get_node("DeathSound").bus == "SFX", "death sound routes to SFX bus")
	var hud := main.get_node("HUD")
	var music_slider := hud.get_node("AudioControls/MusicRow/MusicSlider") as HSlider
	var sfx_slider := hud.get_node("AudioControls/SFXRow/SFXSlider") as HSlider
	assert(music_slider != null and sfx_slider != null, "separate music and SFX controls exist")
	music_slider.value = 50.0
	var music_db := AudioServer.get_bus_volume_db(bgm_index)
	assert(is_equal_approx(music_db, linear_to_db(0.5)), "music slider sets BGM level")
	sfx_slider.value = 25.0
	var sfx_db := AudioServer.get_bus_volume_db(sfx_index)
	assert(is_equal_approx(sfx_db, linear_to_db(0.25)), "SFX slider sets SFX level")
	assert(is_equal_approx(AudioServer.get_bus_volume_db(bgm_index), music_db), "SFX control does not change music")
	assert(hud.get_node("ButtonSound").bus == "SFX", "button feedback routes to SFX")
	assert(main.get_node("Player") != null, "player remains in game scene")
	print("PASS: 8 audio-control and regression assertions")
	quit(0)
