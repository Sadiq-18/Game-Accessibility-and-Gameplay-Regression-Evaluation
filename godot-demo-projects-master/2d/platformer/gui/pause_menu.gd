class_name PauseMenu
extends Control


@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var resume_button := center_cont.get_node(^"VBoxContainer/ResumeButton") as Button
@onready var coins_counter := $ColorRect/CoinsCounter as CoinsCounter
@onready var gamepad_jump_button := center_cont.get_node(^"VBoxContainer/GamepadRemap/JumpButton") as Button
@onready var gamepad_shoot_button := center_cont.get_node(^"VBoxContainer/GamepadRemap/ShootButton") as Button

const GAMEPAD_ACTIONS := ["jump", "shoot"]
var awaiting_gamepad_action := ""


func _ready() -> void:
	hide()
	_update_gamepad_buttons()
	set_process_unhandled_input(true)


func _on_gamepad_remap_pressed(action: String) -> void:
	if action not in GAMEPAD_ACTIONS:
		return
	awaiting_gamepad_action = action
	_gamepad_button(action).text = "%s: press a controller button" % action.capitalize()


func _unhandled_input(event: InputEvent) -> void:
	if awaiting_gamepad_action.is_empty() or not event is InputEventJoypadButton or not event.pressed:
		return
	var action := awaiting_gamepad_action
	for existing in InputMap.action_get_events(action):
		if existing is InputEventJoypadButton:
			InputMap.action_erase_event(action, existing)
	InputMap.action_add_event(action, event.duplicate())
	awaiting_gamepad_action = ""
	_update_gamepad_button(action)
	get_viewport().set_input_as_handled()


func _gamepad_button(action: String) -> Button:
	return gamepad_jump_button if action == "jump" else gamepad_shoot_button


func _update_gamepad_buttons() -> void:
	for action in GAMEPAD_ACTIONS:
		_update_gamepad_button(action)


func _update_gamepad_button(action: String) -> void:
	var label := "Not assigned"
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton:
			label = "Button %d" % (event.button_index + 1)
			break
	_gamepad_button(action).text = "%s controller button: %s" % [action.capitalize(), label]


func close() -> void:
	var tween := create_tween()
	get_tree().paused = false
	tween.tween_property(
			self,
			^"modulate:a",
			0.0,
			fade_out_duration
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
			center_cont,
			^"anchor_bottom",
			0.5,
			fade_out_duration
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)


func open() -> void:
	show()
	resume_button.grab_focus()

	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var tween := create_tween()
	tween.tween_property(
			self,
			^"modulate:a",
			1.0,
			fade_in_duration
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(
			center_cont,
			^"anchor_bottom",
			1.0,
			fade_out_duration
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_coin_collected() -> void:
	coins_counter.collect_coin()


func _on_resume_button_pressed() -> void:
	close()


func _on_singleplayer_button_pressed() -> void:
	if visible:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://game_singleplayer.tscn")


func _on_splitscreen_button_pressed() -> void:
	if visible:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://game_splitscreen.tscn")


func _on_quit_button_pressed() -> void:
	if visible:
		get_tree().quit()
