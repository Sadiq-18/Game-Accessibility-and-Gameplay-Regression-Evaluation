extends SceneTree

func run_caption(overlay: Node, expected: String) -> bool:
	return overlay.get_node("CaptionPanel/CaptionLabel").text == expected and overlay.get_node("CaptionPanel").visible

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game: Node = load("res://game_singleplayer.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var overlay := get_first_node_in_group("captions")
	assert(overlay != null, "caption overlay is present")
	var player: Player = game.get_node("Level/Player")
	player._double_jump_charged = true
	player.try_jump()
	assert(run_caption(overlay, "Jump"), "jump event displays caption")
	assert(overlay.get_node("Timer").time_left > 0.0, "caption has timed dismissal")
	player.gun.shoot(1.0)
	assert(run_caption(overlay, "Shoot"), "shoot event displays caption")
	var enemies := game.find_children("*", "Enemy", true, false)
	assert(not enemies.is_empty(), "game contains an enemy")
	(enemies[0] as Enemy).destroy()
	assert(run_caption(overlay, "Enemy Explode"), "enemy event displays caption")
	var coins := game.find_children("*", "Coin", true, false)
	assert(not coins.is_empty(), "game contains a coin")
	(coins[0] as Coin)._on_body_entered(player)
	assert(run_caption(overlay, "Coin Pickup"), "coin event displays caption")
	assert(player.collision_mask == 30, "player collision mask preserved")
	print("PASS: 9 caption and regression assertions")
	quit(0)
