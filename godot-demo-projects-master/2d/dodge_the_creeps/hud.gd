extends CanvasLayer

signal start_game
@onready var caption_panel := $CaptionPanel as PanelContainer
@onready var caption_label := $CaptionPanel/CaptionLabel as Label
@onready var caption_timer := $CaptionTimer as Timer

func show_caption(text: String) -> void:
	caption_label.text = text
	caption_panel.show()
	caption_timer.start()


func _on_caption_timer_timeout() -> void:
	caption_panel.hide()

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Dodge the\nCreeps"
	$MessageLabel.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
