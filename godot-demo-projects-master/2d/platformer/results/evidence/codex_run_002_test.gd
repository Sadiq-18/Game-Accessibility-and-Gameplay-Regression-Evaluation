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
	var menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(menu)
	await process_frame
	menu.show()
	await process_frame
	var actions := ["move_left", "move_right", "jump", "shoot"]
	var buttons_visible := true
	for action in actions:
		var button := menu.get_node_or_null("ColorRect/CenterContainer/VBoxContainer/RemapControls/" + action + "Button") as Button
		if button == null or not button.visible:
			buttons_visible = false
	_check(buttons_visible, "remapping controls are visible for left, right, jump, and shoot")
	_check(InputMap.has_action("toggle_pause"), "pause action remains present before remapping")
	menu._on_remap_button_pressed("move_left")
	var escape := InputEventKey.new()
	escape.keycode = KEY_ESCAPE
	escape.pressed = true
	menu._unhandled_key_input(escape)
	_check(menu.awaiting_remap_action == "move_left", "Escape remains reserved for pause and does not consume a remap")
	var key_event := InputEventKey.new()
	key_event.physical_keycode = KEY_J
	key_event.pressed = true
	menu._unhandled_key_input(key_event)
	_check(menu.awaiting_remap_action.is_empty(), "a new key press completes the selected remap")
	_check(PauseMenu.remapped_physical_keys.get("move_left") == KEY_J, "the new physical key is recorded")
	var registered := false
	for event in InputMap.action_get_events("move_left"):
		if event is InputEventKey and (event as InputEventKey).physical_keycode == KEY_J:
			registered = true
	_check(registered, "the new key is registered in InputMap for move_left")
	var synthetic := InputEventKey.new()
	synthetic.physical_keycode = KEY_J
	_check(synthetic.is_action("move_left"), "the rebound key resolves to the move_left action")
	_check(InputMap.has_action("toggle_pause"), "remapping does not remove the pause action")
	menu.queue_free()
	await process_frame
	var second_menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(second_menu)
	await process_frame
	_check(second_menu._remap_button("move_left").text.contains("J"), "the remapped key is shown in a new pause menu instance")

	var game := (load("res://game_singleplayer.tscn") as PackedScene).instantiate() as Game
	root.add_child(game)
	var player := game.get_node("Level/Player") as Player
	player._double_jump_charged = true
	player.position.y -= 100.0
	await physics_frame
	player.velocity.x = 100.0
	player.try_jump()
	_check(is_equal_approx(player.velocity.y, Player.JUMP_VELOCITY) and is_equal_approx(player.velocity.x, 250.0), "double-jump behavior remains intact after remapping support")
	var pause_keys := InputMap.action_get_events("toggle_pause")
	_check(not pause_keys.is_empty(), "Escape/pause input mapping remains bound")

	if failures == 0:
		print("RESULT: PASS; keyboard remapping and selected gameplay regression checks passed.")
	else:
		print("RESULT: FAIL; ", failures, " check(s) failed.")
	for child in root.get_children():
		child.queue_free()
	await process_frame
	call_deferred("quit", 0 if failures == 0 else 1)
