extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	Engine.set_meta("gab_pointer_follow", false)
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var player: Area2D = main.get_node("Player")
	var hud := main.get_node("HUD")
	var toggle := hud.get_node("PointerFollowToggle") as CheckButton
	assert(toggle != null, "pointer-follow setting is available")
	assert(player.speed == 400, "baseline player speed is preserved")
	player.start(Vector2(220, 360))
	Input.warp_mouse(Vector2(450, 360))
	await process_frame
	var target := player.get_global_mouse_position()
	var distance_before := player.global_position.distance_to(target)
	hud.call("_on_pointer_follow_toggled", true)
	player._process(0.1)
	var distance_after := player.global_position.distance_to(player.get_global_mouse_position())
	assert(distance_after < distance_before, "enabled player moves smoothly toward pointer")
	assert(player.position != Vector2(220, 360), "pointer-follow changes player position")
	hud.call("_on_pointer_follow_toggled", false)
	player.position = Vector2(100, 100)
	Input.action_press("move_right")
	player._process(0.1)
	assert(player.position.x > 100.0, "keyboard movement remains available when pointer mode is off")
	Input.action_release("move_right")
	player.position = Vector2(10000, 10000)
	player._process(0.1)
	assert(player.position.x <= player.screen_size.x and player.position.y <= player.screen_size.y, "player remains clamped to screen")
	assert(player.get_node("CollisionShape2D") != null, "player collision remains present")
	print("PASS: 8 pointer-follow and regression assertions; pointer=%s" % str(target))
	quit(0)
