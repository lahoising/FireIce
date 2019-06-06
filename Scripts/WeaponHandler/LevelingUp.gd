tool
extends Sprite

func calculate_aspect_ratio():
	material.set_shader_param("aspect_ratio", scale.y / scale.x)
"""
func _ready():
	$AnimationPlayer.play("starting")
	$AnimationPlayer.queue("loop")
"""
func _on_Timer_timeout():
	queue_free()