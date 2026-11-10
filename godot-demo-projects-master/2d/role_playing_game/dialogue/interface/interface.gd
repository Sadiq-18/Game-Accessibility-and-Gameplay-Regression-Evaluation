extends Control

var dialogue_node: Node = null

func _ready() -> void:
	visible = false
	_apply_high_contrast(bool(Engine.get_meta("gab_high_contrast", false)))


func _apply_high_contrast(enabled: bool) -> void:
	var panel_style := StyleBoxFlat.new()
	if enabled:
		panel_style.bg_color = Color.BLACK
		panel_style.border_color = Color.WHITE
		panel_style.set_border_width_all(3)
		$Panel2.add_theme_stylebox_override("panel", panel_style)
		$Panel.add_theme_stylebox_override("panel", panel_style.duplicate())
		$Name.add_theme_color_override("default_color", Color.WHITE)
		$Text.add_theme_color_override("default_color", Color.WHITE)
		var focus_style := StyleBoxFlat.new()
		focus_style.bg_color = Color.BLACK
		focus_style.border_color = Color.YELLOW
		focus_style.set_border_width_all(4)
		$Button.add_theme_stylebox_override("normal", panel_style.duplicate())
		$Button.add_theme_stylebox_override("focus", focus_style)
		$Button.add_theme_color_override("font_color", Color.WHITE)
		$Button.add_theme_color_override("font_focus_color", Color.WHITE)
	else:
		$Panel2.remove_theme_stylebox_override("panel")
		$Panel.remove_theme_stylebox_override("panel")
		$Name.remove_theme_color_override("default_color")
		$Text.remove_theme_color_override("default_color")
		$Button.remove_theme_stylebox_override("normal")
		$Button.remove_theme_stylebox_override("focus")
		$Button.remove_theme_color_override("font_color")
		$Button.remove_theme_color_override("font_focus_color")


func show_dialogue(player: Pawn, dialogue: Node) -> void:
	visible = true
	$Button.grab_focus()
	dialogue_node = dialogue

	for c in dialogue.get_signal_connection_list(&"dialogue_started"):
		if player == c.callable.get_object():
			dialogue_node.start_dialogue()
			$Name.text = "[center]" + dialogue_node.dialogue_name + "[/center]"
			$Text.text = dialogue_node.dialogue_text
			return

	dialogue_node.dialogue_started.connect(player.set_active.bind(false))
	dialogue_node.dialogue_finished.connect(player.set_active.bind(true))
	dialogue_node.dialogue_finished.connect(hide)
	dialogue_node.dialogue_finished.connect(_on_dialogue_finished.bind(player))
	dialogue_node.start_dialogue()
	$Name.text = "[center]" + dialogue_node.dialogue_name + "[/center]"
	$Text.text = dialogue_node.dialogue_text


func _on_Button_button_up() -> void:
	dialogue_node.next_dialogue()
	$Name.text = "[center]" + dialogue_node.dialogue_name + "[/center]"
	$Text.text = dialogue_node.dialogue_text


func _on_dialogue_finished(player: Pawn) -> void:
	dialogue_node.dialogue_started.disconnect(player.set_active)
	dialogue_node.dialogue_finished.disconnect(player.set_active)
	dialogue_node.dialogue_finished.disconnect(hide)
	dialogue_node.dialogue_finished.disconnect(_on_dialogue_finished)
