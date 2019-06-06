extends Node2D

const PARTICLE = preload("res://NukeParticle.tscn")

func _ready():
	get_tree().paused = true
	var cam = Interface.player.get_node("Camera2D")
	global_position = Vector2(cam.limit_right/2, cam.limit_bottom/2)
	$AnimationPlayer.play("NukeAnim")

func _process(delta):
	if $AnimationPlayer.is_playing():
		var part = PARTICLE.instance()
		part.direction = ($Position2D.position).normalized()
		add_child(part)
	if get_child_count() <= 4:
		end()

func end():
	get_tree().paused = false
	for node in get_parent().get_node("Navigation2D/TileMap").get_children():
		if "Enemy" in node.name:
			node.hp = 0
		elif "Monster" in node.name:
			node.icehp = 0
			node.firehp = 0
	queue_free()