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


func _linear_channel(value: float) -> float:
	return value / 12.92 if value <= 0.04045 else pow((value + 0.055) / 1.055, 2.4)


func _luminance(color: Color) -> float:
	return 0.2126 * _linear_channel(color.r) + 0.7152 * _linear_channel(color.g) + 0.0722 * _linear_channel(color.b)


func _contrast_ratio(first: Color, second: Color) -> float:
	var values := [_luminance(first), _luminance(second)]
	values.sort()
	return (values[1] + 0.05) / (values[0] + 0.05)


func _run_checks() -> void:
	var menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(menu)
	await process_frame
	_check(menu.high_contrast_toggle != null and menu.high_contrast_toggle.visible, "high-contrast toggle is available in the pause menu")
	menu.high_contrast_toggle.button_pressed = true
	menu.high_contrast_toggle.toggled.emit(true)
	var button := menu.resume_button
	var normal_style := button.get_theme_stylebox(&"normal") as StyleBoxFlat
	var focus_style := button.get_theme_stylebox(&"focus") as StyleBoxFlat
	_check(normal_style != null and button.get_theme_color(&"font_color") == Color.BLACK, "high-contrast mode uses black text on a white button")
	_check(_contrast_ratio(button.get_theme_color(&"font_color"), normal_style.bg_color) >= 4.5, "button text contrast is at least 4.5:1")
	_check(focus_style != null and focus_style.get_border_width(SIDE_LEFT) >= 4 and focus_style.border_color == Color.BLACK, "keyboard focus has a distinct thick outline")
	_check(_contrast_ratio(button.get_theme_color(&"font_color"), focus_style.bg_color) >= 4.5, "focused button text also meets the contrast threshold")
	_check(button.is_connected("pressed", Callable(menu, "_on_resume_button_pressed")), "Resume button signal remains connected")
	_check(menu.get_node("ColorRect/CenterContainer/VBoxContainer/QuitButton").is_connected("pressed", Callable(menu, "_on_quit_button_pressed")), "Quit button signal remains connected")
	_check(PauseMenu.high_contrast_enabled, "high-contrast setting is stored for new menu instances")
	menu.queue_free()
	await process_frame
	var next_menu := (load("res://gui/pause_menu.tscn") as PackedScene).instantiate() as PauseMenu
	root.add_child(next_menu)
	await process_frame
	_check(next_menu.high_contrast_toggle.button_pressed, "high-contrast setting persists in a new pause menu instance")
	_check(next_menu.resume_button.has_theme_stylebox_override(&"focus"), "focus outline remains active in the new instance")
	next_menu.high_contrast_toggle.button_pressed = false
	next_menu.high_contrast_toggle.toggled.emit(false)
	_check(not next_menu.resume_button.has_theme_stylebox_override(&"normal"), "Normal mode restores the shared theme styles")

	if failures == 0:
		print("RESULT: PASS; high-contrast acceptance and menu interaction checks passed.")
	else:
		print("RESULT: FAIL; ", failures, " check(s) failed.")
	for child in root.get_children():
		child.queue_free()
	await process_frame
	call_deferred("quit", 0 if failures == 0 else 1)
