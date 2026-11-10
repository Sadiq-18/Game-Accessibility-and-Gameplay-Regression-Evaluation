extends SceneTree

func run() -> void:
	var options: Node = load("res://menus/options_menu.tscn").instantiate()
	root.add_child(options)
	await process_frame
	var toggle := options.get_node("Root/SettingsPanel/VBox/HighContrast") as CheckButton
	assert(toggle != null, "high contrast setting exists in options")
	toggle.set_pressed(true)
	assert(bool(Engine.get_meta("gab_high_contrast", false)), "settings toggle saves the enabled preference")

	var combat: Node2D = load("res://combat/combat.tscn").instantiate()
	root.add_child(combat)
	await process_frame
	var combatants := combat.get_node("Combatants")
	var player: Node = load("res://combat/combatants/player.tscn").instantiate()
	player.name = "Player"
	var opponent: Node = load("res://combat/combatants/opponent.tscn").instantiate()
	opponent.name = "Opponent"
	combatants.add_child(player)
	combatants.add_child(opponent)
	var ui := combat.get_node("CombatCanvas/UI")
	ui.initialize()
	var panel := ui.get_node("Buttons") as PanelContainer
	var attack := ui.get_node("Buttons/GridContainer/Attack") as Button
	var panel_style := panel.get_theme_stylebox("panel") as StyleBoxFlat
	var button_style := attack.get_theme_stylebox("normal") as StyleBoxFlat
	var focus_style := attack.get_theme_stylebox("focus") as StyleBoxFlat
	assert(panel_style.bg_color == Color.BLACK and panel_style.border_color == Color.WHITE, "battle menu panel is black with white border")
	assert(button_style.bg_color == Color.BLACK and button_style.border_color == Color.WHITE, "battle buttons use black background and white border")
	assert(attack.get_theme_color("font_color") == Color.WHITE, "battle command text is white")
	assert(focus_style.border_color == Color.YELLOW and focus_style.get_border_width(SIDE_LEFT) == 5, "focused selection has a prominent yellow outline")

	var dialogue: Control = load("res://dialogue/interface/interface.tscn").instantiate()
	root.add_child(dialogue)
	await process_frame
	var dialogue_panel := dialogue.get_node("Panel2") as Panel
	var dialogue_style := dialogue_panel.get_theme_stylebox("panel") as StyleBoxFlat
	assert(dialogue_style.bg_color == Color.BLACK, "dialogue text box has an opaque black background")
	assert(dialogue.get_node("Text").get_theme_color("default_color") == Color.WHITE, "dialogue text is white")

	var before: float = opponent.get_node("Health").life
	player.active = true
	ui._on_Attack_button_up()
	assert(opponent.get_node("Health").life == before - player.damage, "battle command remains functional under high contrast")

	toggle.set_pressed(false)
	assert(not bool(Engine.get_meta("gab_high_contrast", true)), "setting can disable high contrast")
	print("PASS: 10 high-contrast and gameplay assertions")
	quit(0)

func _initialize() -> void:
	call_deferred("run")
