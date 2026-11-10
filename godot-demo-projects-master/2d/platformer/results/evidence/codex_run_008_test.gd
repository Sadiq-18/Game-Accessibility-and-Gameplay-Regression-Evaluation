extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game: Node = load("res://game_singleplayer.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var menu: Control = game.get_node("InterfaceLayer/PauseMenu")
	var canvas := game.get_node("InterfaceLayer") as CanvasLayer
	var option := menu.get_node("ColorRect/CenterContainer/VBoxContainer/UIScaleOption") as OptionButton
	assert(option.item_count == 3, "100%, 125%, and 150% options exist")
	assert(is_equal_approx(canvas.transform.x.x, 1.0), "default scale is 100%")
	option.select(1)
	menu.call("_on_ui_scale_selected", 1)
	assert(is_equal_approx(canvas.transform.x.x, 1.25), "125% scales canvas")
	assert(is_equal_approx(canvas.transform.y.y, 1.25), "125% scales both axes")
	assert(canvas.transform.origin.x < 0 and canvas.transform.origin.y < 0, "scale is centered to limit clipping")
	option.select(2)
	menu.call("_on_ui_scale_selected", 2)
	assert(is_equal_approx(canvas.transform.x.x, 1.5), "150% scale works")
	option.select(0)
	menu.call("_on_ui_scale_selected", 0)
	assert(is_equal_approx(canvas.transform.x.x, 1.0), "100% restores baseline")
	assert(game.get_node("Level/Player").collision_mask == 30, "player collision mask preserved")
	print("PASS: 8 UI scaling and regression assertions")
	quit(0)
