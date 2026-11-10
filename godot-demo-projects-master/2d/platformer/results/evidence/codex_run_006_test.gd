extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene = load("res://game_splitscreen.tscn")
	assert(scene != null, "split-screen scene loads")
	var game = scene.instantiate()
	root.add_child(game)
	await process_frame
	var p1 = game.get_node("Black/SplitContainer/ViewportContainer1/Viewport1/Player1")
	var p2 = game.get_node("Black/SplitContainer/ViewportContainer1/Viewport1/Player2")
	assert(p1.get_node("PlayerBadge").visible, "P1 badge visible")
	assert(p2.get_node("PlayerBadge").visible, "P2 badge visible")
	assert(p1.get_node("PlayerBadge/BadgeText").text == "P1", "P1 label")
	assert(p2.get_node("PlayerBadge/BadgeText").text == "P2", "P2 label")
	assert(p1.collision_mask == 30 and p2.collision_mask == 30, "collision masks preserved")
	assert(game.get_node("Black/SplitContainer/ViewportContainer1/Viewport1").size == Vector2i(399, 480), "viewport 1 size preserved")
	assert(game.get_node("Black/SplitContainer/ViewportContainer2/Viewport2").size == Vector2i(399, 480), "viewport 2 size preserved")
	print("PASS: 7 split-screen identity and regression assertions")
	quit(0)
