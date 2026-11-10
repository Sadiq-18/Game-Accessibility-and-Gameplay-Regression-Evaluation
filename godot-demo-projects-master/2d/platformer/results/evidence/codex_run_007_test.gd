extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game: Node = load("res://game_singleplayer.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	var menu: PauseMenu = game.get_node("InterfaceLayer/PauseMenu")
	var parallax := game.get_node("Level/ParallaxBackground") as ParallaxBackground
	assert(parallax != null, "game contains parallax background")
	var original := parallax.scroll_base_scale
	var button := menu.get_node("ColorRect/CenterContainer/VBoxContainer/ReducedMotionButton") as CheckButton
	assert(button != null, "reduced motion option is visible in pause menu")
	button.button_pressed = true
	assert(parallax.scroll_base_scale == Vector2.ZERO, "reduced motion freezes base parallax")
	for layer in parallax.get_children():
		if layer is ParallaxLayer:
			assert(layer.motion_scale == Vector2.ZERO, "reduced motion freezes layer")
	button.button_pressed = false
	assert(parallax.scroll_base_scale == original, "turning off restores base parallax")
	assert(menu.reduced_motion_enabled == false, "setting tracks disabled state")
	assert(game.get_node("Level/Player").collision_mask == 30, "player collision mask preserved")
	print("PASS: 7 reduced-motion and regression assertions")
	quit(0)
