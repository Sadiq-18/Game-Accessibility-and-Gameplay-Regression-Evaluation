extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	Engine.remove_meta("gab_rpg_dialogue_opacity")
	Engine.remove_meta("gab_rpg_dialogue_color")
	var dialogue: Control = load("res://dialogue/interface/interface.tscn").instantiate()
	root.add_child(dialogue)
	await process_frame
	var opacity := dialogue.get_node("BackgroundOpacity") as HSlider
	var color_option := dialogue.get_node("TextColorOption") as OptionButton
	var background := dialogue.get_node("Panel2") as Panel
	var text := dialogue.get_node("Text") as RichTextLabel
	assert(color_option.item_count == 3 and color_option.selected == 0, "white, yellow, and cyan text options exist")
	assert(is_equal_approx(float(Engine.get_meta("gab_rpg_dialogue_opacity")), 0.85), "dialogue background starts at 85% opacity")
	opacity.value = 0.4
	assert(is_equal_approx(background.self_modulate.a, 0.4), "opacity slider immediately changes dialogue backdrop")
	assert(is_equal_approx(float(Engine.get_meta("gab_rpg_dialogue_opacity")), 0.4), "opacity preference is stored")
	dialogue.call("_on_text_color_selected", 1)
	assert(text.get_theme_color("default_color") == Color(1.0, 0.9, 0.2), "yellow text option applies")
	assert(dialogue.get_node("Name").get_theme_color("default_color") == Color(1.0, 0.9, 0.2), "speaker name follows text color")
	dialogue.call("_on_text_color_selected", 2)
	assert(text.get_theme_color("default_color") == Color(0.3, 1.0, 1.0), "cyan text option applies")
	var second: Control = load("res://dialogue/interface/interface.tscn").instantiate()
	root.add_child(second)
	await process_frame
	assert(is_equal_approx(second.get_node("Panel2").self_modulate.a, 0.4), "opacity persists to next dialogue")
	assert(second.get_node("TextColorOption").selected == 2, "text color persists to next dialogue")
	assert(dialogue.get_node("Button").text == "Next", "dialogue controls remain usable")
	print("PASS: 10 dialogue appearance assertions")
	quit(0)
