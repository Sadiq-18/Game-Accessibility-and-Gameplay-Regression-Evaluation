extends RigidBody2D

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
	set_high_contrast(Engine.get_meta("gab_high_contrast", false))


func set_high_contrast(enabled: bool) -> void:
	var material := $AnimatedSprite2D.material as ShaderMaterial
	material.set_shader_parameter("enabled", enabled)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
