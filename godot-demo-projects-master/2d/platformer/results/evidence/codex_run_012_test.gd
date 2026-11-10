extends SceneTree

func has_pad_button(action: String, button_index: int) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton and event.button_index == button_index:
			return true
	return false

func has_keyboard(action: String) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			return true
	return false

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game: Node = load("res://game_singleplayer.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var menu: Control = game.get_node("InterfaceLayer/PauseMenu")
	var jump_button := menu.get_node("ColorRect/CenterContainer/VBoxContainer/GamepadRemap/JumpButton") as Button
	var shoot_button := menu.get_node("ColorRect/CenterContainer/VBoxContainer/GamepadRemap/ShootButton") as Button
	assert(has_pad_button("jump", 0), "baseline jump gamepad mapping exists")
	assert(has_keyboard("jump"), "keyboard jump mapping exists")
	menu.call("_on_gamepad_remap_pressed", "jump")
	assert(jump_button.text.contains("press a controller button"), "jump enters capture mode")
	var jump_event := InputEventJoypadButton.new()
	jump_event.button_index = JOY_BUTTON_X
	jump_event.pressed = true
	menu.call("_unhandled_input", jump_event)
	assert(has_pad_button("jump", JOY_BUTTON_X), "jump controller mapping updated")
	assert(has_keyboard("jump"), "keyboard jump mapping preserved")
	assert(jump_button.text.contains("Button 3"), "jump mapping shown in UI")
	Input.parse_input_event(jump_event)
	await process_frame
	assert(Input.is_action_pressed("jump"), "new jump button triggers action")
	Input.action_release("jump")
	menu.call("_on_gamepad_remap_pressed", "shoot")
	var shoot_event := InputEventJoypadButton.new()
	shoot_event.button_index = JOY_BUTTON_Y
	shoot_event.pressed = true
	menu.call("_unhandled_input", shoot_event)
	assert(has_pad_button("shoot", JOY_BUTTON_Y), "shoot controller mapping updated")
	assert(has_keyboard("shoot"), "keyboard shoot mapping preserved")
	assert(shoot_button.text.contains("Button 4"), "shoot mapping shown in UI")
	assert(game.get_node("Level/Player").collision_mask == 30, "player collision mask preserved")
	print("PASS: 10 controller-remap and regression assertions")
	quit(0)
