extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud := main.get_node("HUD")
	var fade := hud.get_node("DeathFade") as ColorRect
	var mob_timer: Timer = main.get_node("MobTimer")
	var score_timer: Timer = main.get_node("ScoreTimer")
	mob_timer.start()
	score_timer.start()
	assert(not fade.visible and is_equal_approx(fade.color.a, 0.0), "death fade begins transparent")
	assert(not mob_timer.is_stopped() and not score_timer.is_stopped(), "game timers active before death")
	main.call("game_over")
	assert(score_timer.is_stopped(), "score timer stops on death")
	assert(mob_timer.is_stopped(), "mob timer stops on death")
	assert(main.get_node("DeathSound").playing, "death sound still plays")
	await create_timer(0.18).timeout
	assert(fade.visible and fade.color.a > 0.0 and fade.color.a < 0.28, "death transition fades gradually")
	assert(fade.color.a < 1.0, "transition avoids a full-screen flash")
	await create_timer(0.4).timeout
	assert(is_equal_approx(fade.color.a, 0.28), "fade settles at gentle opacity")
	hud.call("reset_death_fade")
	assert(not fade.visible and is_equal_approx(fade.color.a, 0.0), "new session reset removes fade")
	assert(main.get_node("Player").get_node("CollisionShape2D") != null, "player collision remains intact")
	print("PASS: 9 reduced-motion and regression assertions")
	quit(0)
