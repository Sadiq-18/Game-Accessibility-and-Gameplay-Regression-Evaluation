extends SceneTree

func has_key(action: String, key: Key) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey and (event.physical_keycode == key or event.keycode == key):
			return true
	return false

func rebind(menu: Node, action: String, key: Key) -> void:
	menu.call("_on_remap_pressed", action)
	var event := InputEventKey.new()
	event.physical_keycode = key
	event.pressed = true
	menu.call("_unhandled_key_input", event)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game: Node = load("res://game.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var menu: CanvasLayer = game.get_node("OptionsMenu")
	var panel := menu.get_node("Root/SettingsPanel") as PanelContainer
	assert(not panel.visible, "settings panel starts closed")
	menu.call("_on_options_button_pressed")
	assert(panel.visible, "Options button opens panel")
	for action in ["move_up", "move_down", "move_left", "move_right", "ui_accept", "ui_cancel"]:
		assert(menu.get_node("Root/SettingsPanel/Margin/VBox/RemapButtons/%sButton" % action) != null, "%s control exists" % action)
	assert(has_key("move_left", KEY_A), "baseline movement key exists")
	rebind(menu, "move_left", KEY_Q)
	assert(has_key("move_left", KEY_Q), "movement key remaps")
	var q := InputEventKey.new()
	q.physical_keycode = KEY_Q
	q.pressed = true
	Input.parse_input_event(q)
	await process_frame
	var player: Pawn = game.get_node("Exploration/Grid/Player")
	assert(player.get_input_direction().x == -1.0, "remapped key drives exploration movement")
	Input.action_release("move_left")
	rebind(menu, "ui_accept", KEY_ENTER)
	assert(has_key("ui_accept", KEY_ENTER), "menu confirm action remaps")
	rebind(menu, "ui_cancel", KEY_BACKSPACE)
	assert(has_key("ui_cancel", KEY_BACKSPACE), "menu cancel action remaps")
	var old_up := has_key("move_up", KEY_W)
	menu.call("_on_remap_pressed", "move_up")
	var escape := InputEventKey.new()
	escape.keycode = KEY_ESCAPE
	escape.pressed = true
	menu.call("_unhandled_key_input", escape)
	assert(has_key("move_up", KEY_W) == old_up, "Escape cancels capture without changing movement")
	menu.call("_on_close_button_pressed")
	assert(not panel.visible, "Close button closes options")
	print("PASS: 13 exploration and menu-remap assertions")
	quit(0)
