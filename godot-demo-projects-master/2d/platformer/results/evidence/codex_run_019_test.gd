extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	HUD.text_size_index = 0
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud: Node = main.get_node("HUD")
	var score := hud.get_node("ScoreLabel") as Label
	var message := hud.get_node("MessageLabel") as Label
	var option := hud.get_node("TextSizeOption") as OptionButton
	assert(option.item_count == 2 and option.selected == 0, "Normal and Large options exist with Normal default")
	assert(score.get_theme_font_size("font_size") == 60, "score uses baseline text size")
	assert(message.get_theme_font_size("font_size") == 60, "message uses baseline text size")
	hud.call("_on_text_size_selected", 1)
	assert(score.get_theme_font_size("font_size") == 84, "score grows to Large")
	assert(message.get_theme_font_size("font_size") == 84, "message grows to Large")
	hud.call("show_message", "Dodge the\nCreeps")
	await process_frame
	assert(message.visible and message.get_minimum_size().x <= 480.0, "large message fits base viewport width")
	var second_hud: Node = load("res://hud.tscn").instantiate()
	root.add_child(second_hud)
	await process_frame
	assert(second_hud.get_node("TextSizeOption").selected == 1, "large text preference persists across HUD instances")
	assert(second_hud.get_node("ScoreLabel").get_theme_font_size("font_size") == 84, "persisted score size is applied")
	hud.call("_on_text_size_selected", 0)
	assert(score.get_theme_font_size("font_size") == 60, "Normal restores baseline")
	assert(main.get_node("Player").speed == 400, "player movement speed preserved")
	print("PASS: 10 text-size and regression assertions")
	quit(0)
