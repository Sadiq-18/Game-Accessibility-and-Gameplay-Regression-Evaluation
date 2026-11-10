extends SceneTree

func latest_mob(main: Node) -> Node:
	var found: Node
	for child in main.get_children():
		if child is RigidBody2D and child.has_method("set_palette_enabled"):
			found = child
	return found

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	Engine.set_meta("gab_color_palette", false)
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud := main.get_node("HUD")
	var toggle := hud.get_node("PaletteToggle") as CheckButton
	assert(toggle != null, "palette mode toggle exists")
	assert(main.get_node("ColorRect").color == Color(0.219608, 0.372549, 0.380392, 1.0), "background starts at baseline")
	hud.call("_on_palette_toggled", true)
	assert(Engine.get_meta("gab_color_palette"), "palette state enabled")
	assert(main.get_node("Player").modulate == Color(0.0, 0.85, 1.0, 1.0), "player uses cyan high-visibility tint")
	assert(main.get_node("ColorRect").color == Color(0.055, 0.075, 0.12, 1.0), "background changes to dark navy")
	main.call("_on_MobTimer_timeout")
	var mob := latest_mob(main)
	assert(mob != null and mob.modulate == Color(1.0, 0.45, 0.0, 1.0), "new mobs use orange high-visibility tint")
	hud.call("_on_palette_toggled", false)
	assert(main.get_node("Player").modulate == Color.WHITE, "player tint restores")
	assert(mob.modulate == Color.WHITE, "existing mob tint restores")
	assert(main.get_node("ColorRect").color == Color(0.219608, 0.372549, 0.380392, 1.0), "background restores")
	assert(main.get_node("Player").speed == 400, "player movement speed preserved")
	print("PASS: 9 palette and regression assertions")
	quit(0)
