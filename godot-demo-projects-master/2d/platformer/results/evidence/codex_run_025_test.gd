extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	Engine.set_meta("gab_rpg_large_text", false)
	var dialogue: Control = load("res://dialogue/interface/interface.tscn").instantiate()
	var combat: Node2D = load("res://combat/combat.tscn").instantiate()
	root.add_child(dialogue)
	root.add_child(combat)
	await process_frame
	var dialogue_option := dialogue.get_node("TextSizeOption") as OptionButton
	var dialogue_text := dialogue.get_node("Text") as RichTextLabel
	var combat_ui: Control = combat.get_node("CombatCanvas/UI")
	var battle_option := combat_ui.get_node("TextSizeOption") as OptionButton
	var attack := combat_ui.get_node("Buttons/GridContainer/Attack") as Button
	assert(dialogue_option.item_count == 2 and battle_option.item_count == 2, "both menus offer Normal and Large")
	assert(dialogue_text.get_theme_font_size("normal_font_size") == 32, "dialogue Normal size is baseline")
	assert(attack.get_theme_font_size("font_size") == 32, "battle command Normal size is baseline")
	dialogue.call("_on_text_size_selected", 1)
	assert(dialogue_text.get_theme_font_size("normal_font_size") == 44, "dialogue text expands")
	assert(dialogue.get_node("Name").get_theme_font_size("normal_font_size") == 44, "dialogue name expands")
	combat_ui.call("_on_text_size_selected", 1)
	assert(attack.get_theme_font_size("font_size") == 44, "combat command text expands")
	assert(combat_ui.get_node("Buttons/GridContainer/Defend").get_theme_font_size("font_size") == 44, "all combat choices expand")
	var next_dialogue: Control = load("res://dialogue/interface/interface.tscn").instantiate()
	root.add_child(next_dialogue)
	await process_frame
	assert(next_dialogue.get_node("TextSizeOption").selected == 1, "large setting persists across dialogue instances")
	assert(next_dialogue.get_node("Text").get_theme_font_size("normal_font_size") == 44, "persisted size is applied")
	print("PASS: 9 dialogue and battle text-size assertions")
	quit(0)
