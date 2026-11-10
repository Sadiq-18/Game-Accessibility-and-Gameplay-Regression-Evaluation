extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	Engine.set_meta("gab_assist_mode", false)
	var game: Node = load("res://game_singleplayer.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var player: Player = game.get_node("Level/Player")
	var enemies := game.find_children("*", "Enemy", true, false)
	assert(not enemies.is_empty(), "game contains a patrol enemy")
	var enemy: Enemy = enemies[0]
	var menu: PauseMenu = game.get_node("InterfaceLayer/PauseMenu")
	assert(is_equal_approx(player._gravity_multiplier(), 1.0), "default gravity unchanged")
	assert(is_equal_approx(enemy._effective_walk_speed(), Enemy.WALK_SPEED), "default enemy speed unchanged")
	menu.call("_on_assist_mode_toggled", true)
	assert(Engine.get_meta("gab_assist_mode"), "assist preference is enabled")
	assert(is_equal_approx(player._gravity_multiplier(), 0.7), "assist reduces player gravity")
	assert(is_equal_approx(enemy._effective_walk_speed(), Enemy.WALK_SPEED * 0.5), "assist halves enemy speed")
	menu.call("_on_assist_mode_toggled", false)
	assert(is_equal_approx(player._gravity_multiplier(), 1.0), "gravity returns to default")
	assert(is_equal_approx(enemy._effective_walk_speed(), Enemy.WALK_SPEED), "enemy speed returns to default")
	assert(player.collision_mask == 30, "player collision mask preserved")
	print("PASS: 8 assist-mode and regression assertions")
	quit(0)
