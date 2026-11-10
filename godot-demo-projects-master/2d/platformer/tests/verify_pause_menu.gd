extends SceneTree


func _initialize() -> void:
	call_deferred("_verify")


func _verify() -> void:
	var packed := load("res://gui/pause_menu.tscn") as PackedScene
	assert(packed != null, "Pause menu scene must load")
	var menu := packed.instantiate()
	root.add_child(menu)
	await process_frame

	var selector: OptionButton = menu.get_node("ColorRect/CenterContainer/VBoxContainer/TextSizeContainer/TextSizeSelector")
	var title: Label = menu.get_node("ColorRect/CenterContainer/VBoxContainer/Label")
	var resume: Button = menu.get_node("ColorRect/CenterContainer/VBoxContainer/ResumeButton")
	assert(selector.item_count == 2, "Selector should offer Normal and Large")
	assert(selector.get_item_text(0) == "Normal")
	assert(selector.get_item_text(1) == "Large")

	selector.select(1)
	selector.item_selected.emit(1)
	await process_frame
	assert(PauseMenu.current_text_size_index == 1, "Large choice should be stored")
	assert(title.get_theme_font_size("font_size") == 30, "Title should use large size")
	assert(resume.get_theme_font_size("font_size") == 24, "Button should use large size")

	selector.select(0)
	selector.item_selected.emit(0)
	await process_frame
	assert(PauseMenu.current_text_size_index == 0, "Normal choice should be stored")
	assert(not title.has_theme_font_size_override("font_size"), "Normal title should restore theme")
	assert(not resume.has_theme_font_size_override("font_size"), "Normal button should restore theme")

	print("PASS: pause menu loads; selector switches Normal/Large; font sizes apply and revert.")
	menu.free()
	await process_frame
	quit()
