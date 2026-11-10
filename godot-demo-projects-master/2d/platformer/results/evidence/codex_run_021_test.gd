extends SceneTree

func count_mobs(main: Node) -> int:
	return main.find_children("*", "RigidBody2D", true, false).size()

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud := main.get_node("HUD")
	var indicator := hud.get_node("SpawnWarning") as PanelContainer
	var before := count_mobs(main)
	main.call("_on_MobTimer_timeout")
	assert(indicator.visible, "warning appears before mob enters")
	assert(hud.get_node("WarningFlashTimer").time_left > 0.0, "border indicator flashes")
	assert(main.get_node("SpawnWarningTimer").time_left > 0.0, "mob waits for warning interval")
	assert(count_mobs(main) == before, "mob is not spawned immediately")
	var arrow := hud.get_node("SpawnWarning/Arrow") as Label
	assert(["<", ">", "^", "v"].has(arrow.text), "directional arrow points toward spawn edge")
	assert(indicator.position.x <= 4.0 or indicator.position.x >= 428.0 or indicator.position.y <= 4.0 or indicator.position.y >= 668.0, "indicator is on viewport border")
	await create_timer(0.36).timeout
	assert(count_mobs(main) == before + 1, "mob enters after warning delay")
	assert(not indicator.visible, "warning hides when mob spawns")
	var mobs := main.find_children("*", "RigidBody2D", true, false)
	assert(mobs[0].linear_velocity.length() >= 150.0 and mobs[0].linear_velocity.length() <= 250.0, "baseline mob speed preserved")
	assert(main.get_node("Player").speed == 400, "player speed preserved")
	print("PASS: 10 incoming-mob indicator and regression assertions")
	quit(0)
