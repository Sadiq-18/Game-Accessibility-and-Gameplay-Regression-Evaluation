extends CanvasLayer


func _ready() -> void:
	$Root/SettingsPanel/VBox/HighContrast.set_pressed_no_signal(bool(Engine.get_meta("gab_high_contrast", false)))


func _on_options_button_pressed() -> void:
	$Root/SettingsPanel.visible = not $Root/SettingsPanel.visible


func _on_close_button_pressed() -> void:
	$Root/SettingsPanel.hide()


func _on_high_contrast_toggled(enabled: bool) -> void:
	Engine.set_meta("gab_high_contrast", enabled)
