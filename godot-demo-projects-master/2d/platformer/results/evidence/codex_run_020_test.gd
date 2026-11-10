extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud: CanvasLayer = main.get_node("HUD")
	var option := hud.get_node("UIScaleOption") as OptionButton
	assert(option.item_count == 3 and option.selected == 0, "100%, 125%, and 150% HUD choices exist")
	assert(is_equal_approx(hud.transform.x.x, 1.0), "HUD defaults to 100%")
	hud.call("_on_ui_scale_selected", 1)
	assert(is_equal_approx(hud.transform.x.x, 1.25), "125% scales horizontal HUD")
	assert(is_equal_approx(hud.transform.y.y, 1.25), "125% scales vertical HUD")
	assert(hud.transform.origin.x < 0.0 and hud.transform.origin.y < 0.0, "scale is centered on viewport")
	hud.call("_on_ui_scale_selected", 2)
	assert(is_equal_approx(hud.transform.x.x, 1.5), "150% scale works")
	hud.call("_on_ui_scale_selected", 0)
	assert(is_equal_approx(hud.transform.x.x, 1.0), "100% restores original scale")
	assert(main.get_node("Player").speed == 400, "player movement speed preserved")
	assert(main.get_node("MobTimer").wait_time == 0.5, "mob timer remains unchanged")
	print("PASS: 9 HUD-scaling and regression assertions")
	quit(0)
