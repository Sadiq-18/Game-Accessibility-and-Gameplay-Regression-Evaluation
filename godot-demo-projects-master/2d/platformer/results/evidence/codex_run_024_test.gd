extends SceneTree

func caption(hud: Node) -> String:
	return hud.get_node("CaptionPanel/CaptionLabel").text

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var main: Node = load("res://main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var hud := main.get_node("HUD")
	var panel := hud.get_node("CaptionPanel") as PanelContainer
	assert(not panel.visible, "caption starts hidden")
	main.call("new_game")
	assert(main.get_node("Music").playing, "new game starts music")
	assert(panel.visible and caption(hud) == "Music Start", "music-start event is captioned")
	assert(hud.get_node("CaptionTimer").time_left > 0.0, "caption auto-dismiss timer runs")
	main.get_node("StartTimer").stop()
	main.get_node("MobTimer").stop()
	main.get_node("ScoreTimer").stop()
	main.call("_on_ScoreTimer_timeout")
	assert(main.score == 1 and main.get_node("HUD/ScoreLabel").text == "1", "score increments as before")
	assert(caption(hud) == "New Score: 1", "new-score event is captioned")
	main.call("game_over")
	assert(not main.get_node("Music").playing, "music stops on death")
	assert(main.get_node("DeathSound").playing, "death sound is triggered")
	assert(panel.visible and caption(hud) == "Death Sound", "death-sound event is captioned")
	hud.call("_on_caption_timer_timeout")
	assert(not panel.visible, "caption timer hides presentation")
	assert(main.get_node("Player").get_node("CollisionShape2D") != null, "player collision remains intact")
	print("PASS: 10 caption and regression assertions")
	quit(0)
