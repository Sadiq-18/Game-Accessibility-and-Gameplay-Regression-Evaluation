extends SceneTree

func has_physical_key(action: String, code: Key) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey and event.physical_keycode == code:
			return true
	return false

func has_non_keyboard_event(action: String) -> bool:
	for event in InputMap.action_get_events(action):
		if not event is InputEventKey:
			return true
	return false

func rebind(hud: Node, action: String, key: Key) -> void:
	hud.call("_on_remap_button_pressed", action)
	var event := InputEventKey.new()
	event.physical_keycode = key
	event.pressed = true
	hud.call("_unhandled_key_input", event)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud := main.get_node("HUD")
	for action in ["move_up", "move_down", "move_left", "move_right"]:
		assert(InputMap.has_action(action), "%s action exists" % action)
		assert(hud.get_node("InputRemap/%sButton" % action) != null, "%s remap control exists" % action)
	rebind(hud, "move_left", KEY_Q)
	assert(has_physical_key("move_left", KEY_Q), "left mapping updates")
	assert(hud.get_node("InputRemap/move_leftButton").text.ends_with("Q"), "left mapping displayed")
	var q_event := InputEventKey.new()
	q_event.physical_keycode = KEY_Q
	q_event.pressed = true
	Input.parse_input_event(q_event)
	await process_frame
	assert(Input.is_action_pressed("move_left"), "remapped key activates player movement action")
	Input.parse_input_event(q_event.duplicate())
	var release := InputEventKey.new()
	release.physical_keycode = KEY_Q
	Input.parse_input_event(release)
	rebind(hud, "move_up", KEY_I)
	rebind(hud, "move_down", KEY_K)
	rebind(hud, "move_right", KEY_L)
	assert(has_physical_key("move_up", KEY_I), "up mapping updates")
	assert(has_physical_key("move_down", KEY_K), "down mapping updates")
	assert(has_physical_key("move_right", KEY_L), "right mapping updates")
	assert(InputMap.has_action("start_game"), "start-game action remains registered")
	assert(main.get_node("Player").speed == 400, "player speed remains unchanged")
	print("PASS: 12 remapping and regression assertions")
	quit(0)
