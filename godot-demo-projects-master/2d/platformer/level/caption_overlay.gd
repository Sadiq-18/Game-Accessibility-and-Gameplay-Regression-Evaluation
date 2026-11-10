extends CanvasLayer

@onready var panel := $CaptionPanel as PanelContainer
@onready var caption_label := $CaptionPanel/CaptionLabel as Label
@onready var timer := $Timer as Timer

func show_caption(caption: String) -> void:
	caption_label.text = caption
	panel.show()
	timer.start()

func _on_timer_timeout() -> void:
	panel.hide()
