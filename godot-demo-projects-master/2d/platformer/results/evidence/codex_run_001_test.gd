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
	var pause_scene := load("res://gui/pause_menu.tscn") as PackedScene
	var menu := pause_scene.instantiate() as PauseMenu
	root.add_child(menu)
	await process_frame
	await process_frame

	var selector := menu.get_node("ColorRect/CenterContainer/VBoxContainer/TextSizeContainer/TextSizeSelector") as OptionButton
	_check(selector.item_count == 2, "pause menu exposes Normal and Large text sizes")
	_check(selector.get_item_text(0) == "Normal" and selector.get_item_text(1) == "Large", "text size options have the expected labels")
	_check(selector.selected == 0 and not menu.resume_button.has_theme_font_size_override(&"font_size"), "Normal is the default and preserves theme font sizing")
	selector.select(1)
	selector.item_selected.emit(1)
	await process_frame
	_check(PauseMenu.text_size_index == 1, "selecting Large updates the session preference")
	_check(menu.title_label.get_theme_font_size(&"font_size") == 30, "Large applies 30 px title text immediately")
	_check(menu.resume_button.get_theme_font_size(&"font_size") == 24, "Large applies 24 px menu button text immediately")
	_check(menu.text_size_selector.get_theme_font_size(&"font_size") == 24, "Large applies 24 px selector text immediately")
	_check(menu.get_node("ColorRect/CenterContainer/VBoxContainer/TextSizeContainer/TextSizeLabel").get_theme_font_size(&"font_size") == 24, "Large applies 24 px setting label text")
	menu.show()
	await process_frame
	await process_frame
	var viewport_size := root.get_visible_rect().size
	var controls := [menu.title_label, menu.resume_button, menu.text_size_selector]
	var fits_viewport := true
	for control in controls:
		var rect := (control as Control).get_global_rect()
		if rect.position.x < 0.0 or rect.position.y < 0.0 or rect.end.x > viewport_size.x or rect.end.y > viewport_size.y:
			fits_viewport = false
	_check(fits_viewport, "Large text controls remain inside the game viewport")
	var text_fits_controls := true
	for control in menu.find_children("*", "Control", true, false):
		if control is Label or control is Button:
			var text_control := control as Control
			var minimum_size := text_control.get_combined_minimum_size()
			if text_control.size.x + 0.5 < minimum_size.x or text_control.size.y + 0.5 < minimum_size.y:
				text_fits_controls = false
	_check(text_fits_controls, "Large text labels and buttons meet their content-driven minimum sizes")
	var vbox := menu.get_node("ColorRect/CenterContainer/VBoxContainer") as VBoxContainer
	var menu_rows: Array[Control] = []
	for child in vbox.get_children():
		if child is Control and (child as Control).size.x > 0.0 and (child as Control).size.y > 0.0:
			menu_rows.append(child as Control)
	var rows_overlap := false
	for first_index in range(menu_rows.size()):
		for second_index in range(first_index + 1, menu_rows.size()):
			if menu_rows[first_index].get_global_rect().intersects(menu_rows[second_index].get_global_rect()):
				rows_overlap = true
	_check(not rows_overlap, "Large text menu rows do not overlap")
	menu.queue_free()
	await process_frame
	var second_menu := pause_scene.instantiate() as PauseMenu
	root.add_child(second_menu)
	await process_frame
	_check(second_menu.text_size_selector.selected == 1, "Large preference persists when a new pause menu instance is created")
	second_menu.text_size_selector.select(0)
	second_menu.text_size_selector.item_selected.emit(0)
	await process_frame
	_check(not second_menu.resume_button.has_theme_font_size_override(&"font_size"), "Normal restores the theme's original button size")

	var game_scene := load("res://game_singleplayer.tscn") as PackedScene
	var game := game_scene.instantiate() as Game
	root.add_child(game)
	current_scene = game
	await process_frame
	await physics_frame
	var player := game.get_node("Level/Player") as Player
	_check(player != null, "baseline single-player scene loads its player")
	_check(Player.WALK_SPEED == 300.0 and Player.JUMP_VELOCITY == -725.0, "movement and jump constants match the unmodified baseline")
	Input.action_press("move_right")
	await physics_frame
	await physics_frame
	Input.action_release("move_right")
	_check(player.velocity.x > 0.0, "baseline right-movement input still moves the player")
	_check(player.is_on_floor(), "baseline player remains grounded before the first jump")
	player.try_jump()
	_check(is_equal_approx(player.velocity.y, Player.JUMP_VELOCITY), "baseline first jump still applies the expected jump velocity")
	player.position.y -= 100.0
	await physics_frame
	player._double_jump_charged = true
	player.velocity.x = 100.0
	player.try_jump()
	_check(is_equal_approx(player.velocity.y, Player.JUMP_VELOCITY) and is_equal_approx(player.velocity.x, 250.0), "baseline double-jump behavior is preserved")
	_check(player.gun.shoot(1.0), "baseline shooting creates a bullet")
	_check(not player.gun.shoot(1.0), "baseline shooting cooldown still prevents an immediate second shot")
	_check(Gun.BULLET_VELOCITY == 850.0, "baseline bullet speed is unchanged")
	var enemy := (load("res://enemy/enemy.tscn") as PackedScene).instantiate() as Enemy
	enemy.global_position = Vector2(450.0, 300.0)
	root.add_child(enemy)
	var bullet := (load("res://player/bullet.tscn") as PackedScene).instantiate() as Bullet
	bullet.global_position = Vector2(425.0, 300.0)
	bullet.linear_velocity = Vector2(Gun.BULLET_VELOCITY, 0.0)
	root.add_child(bullet)
	for _frame in range(8):
		await physics_frame
	_check(enemy.get_new_animation() == "destroy", "bullet contact still triggers the enemy destruction state")
	var coins_before := game._pause_menu.coins_counter._coins_collected
	var coin := (load("res://level/coin.tscn") as PackedScene).instantiate() as Coin
	game.get_node("Level").add_child(coin)
	coin.global_position = player.global_position
	for _frame in range(3):
		await physics_frame
	_check(game._pause_menu.coins_counter._coins_collected == coins_before + 1, "physical coin pickup still updates the pause-menu counter")
	var pause_event := InputEventAction.new()
	pause_event.action = &"toggle_pause"
	pause_event.pressed = true
	game._unhandled_input(pause_event)
	_check(paused, "baseline pause action pauses the game tree")
	game._unhandled_input(pause_event)
	_check(not paused, "baseline pause action resumes the game tree")
	game._pause_menu.visible = true
	game._pause_menu._on_splitscreen_button_pressed()
	await process_frame
	await process_frame
	_check(current_scene != null and current_scene.scene_file_path == "res://game_splitscreen.tscn", "pause-menu transition to splitscreen still loads")
	var splitscreen_menu := current_scene.get_node("InterfaceLayer/PauseMenu") as PauseMenu
	splitscreen_menu.visible = true
	splitscreen_menu._on_singleplayer_button_pressed()
	await process_frame
	await process_frame
	_check(current_scene != null and current_scene.scene_file_path == "res://game_singleplayer.tscn", "pause-menu transition back to singleplayer still loads")

	if failures == 0:
		print("RESULT: PASS; all accessibility acceptance and selected gameplay regression checks passed.")
	else:
		print("RESULT: FAIL; ", failures, " check(s) failed.")
	current_scene = null
	for child in root.get_children():
		child.queue_free()
	await process_frame
	await process_frame
	call_deferred("quit", 0 if failures == 0 else 1)
