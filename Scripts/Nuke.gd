extends Particles2D

func _ready():
	var cam = Interface.player.get_node("Camera2D")
	global_position = Vector2(cam.limit_right/2, cam.limit_bottom/2)
	get_tree().paused = true
	$AnimationPlayer.play("NukeAnim")

func end():
	get_tree().paused = false
	for node in get_parent().get_node("Navigation2D/TileMap").get_children():
		if "Enemy" in node.name or "Mob" in node.name:
			node.hp = 0
		elif "Monster" in node.name:
			node.icehp = 0
			node.firehp = 0
	queue_free()