extends SceneTree

func latest_mob(main: Node) -> RigidBody2D:
	var found: RigidBody2D
	for child in main.get_children():
		if child is RigidBody2D:
			found = child as RigidBody2D
	return found

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud := main.get_node("HUD")
	var option := hud.get_node("DifficultyOption") as OptionButton
	assert(option.item_count == 3 and option.selected == 1, "Easy/Normal/Hard selector defaults to Normal")
	hud.call("_on_difficulty_option_item_selected", 0)
	assert(is_equal_approx(main.mob_spawn_interval, 1.0), "Easy increases mob spawn interval")
	assert(is_equal_approx(main.mob_speed_multiplier, 0.7), "Easy reduces mob speed")
	assert(is_equal_approx(main.get_node("MobTimer").wait_time, 1.0), "Easy timer applied")
	main.call("_on_MobTimer_timeout")
	var easy_mob := latest_mob(main)
	assert(easy_mob != null and easy_mob.linear_velocity.length() >= 105.0 and easy_mob.linear_velocity.length() <= 175.0, "Easy mob velocity is reduced")
	hud.call("_on_difficulty_option_item_selected", 1)
	assert(is_equal_approx(main.get_node("MobTimer").wait_time, 0.5), "Normal timer preserves baseline")
	main.call("_on_MobTimer_timeout")
	var normal_mob := latest_mob(main)
	assert(normal_mob.linear_velocity.length() >= 150.0 and normal_mob.linear_velocity.length() <= 250.0, "Normal mob speed preserves baseline")
	hud.call("_on_difficulty_option_item_selected", 2)
	assert(is_equal_approx(main.get_node("MobTimer").wait_time, 0.3), "Hard increases spawn rate")
	assert(is_equal_approx(main.mob_speed_multiplier, 1.3), "Hard increases mob speed")
	assert(main.get_node("Player") != null, "player scene remains present")
	print("PASS: 10 difficulty and regression assertions")
	quit(0)
