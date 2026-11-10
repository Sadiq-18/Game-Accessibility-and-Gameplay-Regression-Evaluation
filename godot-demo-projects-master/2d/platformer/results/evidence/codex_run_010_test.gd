extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func count_bullets(gun: Node) -> int:
	var count := 0
	for child in gun.get_children():
		if child is Bullet:
			count += 1
	return count

func run() -> void:
	Engine.set_meta("gab_auto_fire", false)
	var game: Node = load("res://game_singleplayer.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var player: Player = game.get_node("Level/Player")
	var menu: PauseMenu = game.get_node("InterfaceLayer/PauseMenu")
	assert(not Engine.get_meta("gab_auto_fire"), "auto-fire defaults off")
	menu.call("_on_auto_fire_toggled", true)
	assert(Engine.get_meta("gab_auto_fire"), "menu enables auto-fire")
	Input.action_press("shoot")
	await create_timer(1.0).timeout
	Input.action_release("shoot")
	var bullets := count_bullets(player.gun)
	assert(bullets >= 2, "holding shoot generates repeated bullets")
	assert(player.collision_mask == 30, "player collision mask preserved")
	menu.call("_on_auto_fire_toggled", false)
	assert(not Engine.get_meta("gab_auto_fire"), "auto-fire can be disabled")
	assert(not Input.is_action_pressed("shoot"), "input released after trial")
	print("PASS: 6 auto-fire and regression assertions; bullets observed: %d" % bullets)
	quit(0)
