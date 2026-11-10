extends Control

signal flee(winner: Combatant, loser: Combatant)


@export var combatants_node: Node
@export var info_scene: PackedScene


func initialize() -> void:
	_apply_high_contrast(bool(Engine.get_meta("gab_high_contrast", false)))
	for combatant in combatants_node.get_children():
		var health := combatant.get_node(^"Health")
		var info := info_scene.instantiate()
		var health_info := info.get_node(^"VBoxContainer/HealthContainer/Health")
		health_info.value = health.life
		health_info.max_value = health.max_life
		info.get_node(^"VBoxContainer/NameContainer/Name").text = combatant.name
		health.health_changed.connect(health_info.set_value)
		$Combatants.add_child(info)

	$Buttons/GridContainer/Attack.grab_focus()


func _apply_high_contrast(enabled: bool) -> void:
	var panel := $Buttons as PanelContainer
	var commands := $Buttons/GridContainer
	if not enabled:
		panel.remove_theme_stylebox_override("panel")
		for button in commands.get_children():
			button.remove_theme_stylebox_override("normal")
			button.remove_theme_stylebox_override("hover")
			button.remove_theme_stylebox_override("focus")
			button.remove_theme_color_override("font_color")
			button.remove_theme_color_override("font_hover_color")
			button.remove_theme_color_override("font_focus_color")
		return
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color.BLACK
	panel_style.border_color = Color.WHITE
	panel_style.set_border_width_all(3)
	panel.add_theme_stylebox_override("panel", panel_style)
	for button in commands.get_children():
		var normal := StyleBoxFlat.new()
		normal.bg_color = Color.BLACK
		normal.border_color = Color.WHITE
		normal.set_border_width_all(2)
		var hover := normal.duplicate() as StyleBoxFlat
		hover.bg_color = Color(0.12, 0.12, 0.12)
		var focus := normal.duplicate() as StyleBoxFlat
		focus.border_color = Color.YELLOW
		focus.set_border_width_all(5)
		button.add_theme_stylebox_override("normal", normal)
		button.add_theme_stylebox_override("hover", hover)
		button.add_theme_stylebox_override("focus", focus)
		button.add_theme_color_override("font_color", Color.WHITE)
		button.add_theme_color_override("font_hover_color", Color.WHITE)
		button.add_theme_color_override("font_focus_color", Color.WHITE)


func _on_Attack_button_up() -> void:
	if not combatants_node.get_node(^"Player").active:
		return

	combatants_node.get_node(^"Player").attack(combatants_node.get_node(^"Opponent"))


func _on_Defend_button_up() -> void:
	if not combatants_node.get_node(^"Player").active:
		return

	combatants_node.get_node(^"Player").defend()


func _on_Flee_button_up() -> void:
	if not combatants_node.get_node(^"Player").active:
		return

	combatants_node.get_node(^"Player").flee()

	var loser: Combatant = combatants_node.get_node(^"Player")
	var winner: Combatant = combatants_node.get_node(^"Opponent")
	flee.emit(winner, loser)
