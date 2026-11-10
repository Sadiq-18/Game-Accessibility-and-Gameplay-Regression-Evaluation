extends SceneTree

func outline_enabled(node: Node) -> bool:
	var material := node.get_node("AnimatedSprite2D").material as ShaderMaterial
	return material.get_shader_parameter("enabled")

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	Engine.set_meta("gab_high_contrast", false)
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var player := main.get_node("Player")
	var toggle := main.get_node("HUD/HighContrastToggle") as CheckButton
	assert(toggle != null, "high-contrast control exists")
	assert(not outline_enabled(player), "outline defaults off")
	main.call("_on_high_contrast_toggled", true)
	assert(outline_enabled(player), "player outline shader enabled")
	var player_material := player.get_node("AnimatedSprite2D").material as ShaderMaterial
	assert(is_equal_approx(float(player_material.get_shader_parameter("outline_width")), 2.0), "outline has thick width")
	assert(player_material.get_shader_parameter("outline_color") == Color(1, 0.9, 0.1, 1), "outline is bright yellow")
	main.call("_on_MobTimer_timeout")
	var mobs := main.find_children("*", "RigidBody2D", true, false)
	var mob: Node
	for candidate in mobs:
		if candidate.has_method("set_high_contrast"):
			mob = candidate
	assert(mob != null and outline_enabled(mob), "new mob outline enabled")
	assert((player_material.shader.code as String).contains("surrounding_alpha"), "shader uses neighboring sprite pixels for border")
	main.call("_on_high_contrast_toggled", false)
	assert(not outline_enabled(player), "player outline can be disabled")
	assert(not outline_enabled(mob), "mob outline can be disabled")
	assert(player.speed == 400, "player movement speed preserved")
	print("PASS: 9 high-contrast and regression assertions")
	quit(0)
