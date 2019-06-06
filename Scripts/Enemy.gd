extends "res://Scripts/Entity.gd"

func _physics_process(delta):
	if get_node("AnimationPlayer").is_playing():
		return
	var direction = (Interface.player.position - position).normalized() * SPD
	#var direction = (map.get_simple_path(position, Interface.player.position, false)[1]-position).normalized()*SPD
	#var direction = map.get_path(global_position, Interface.player.global_position)[1].normalized()* SPD
	if direction.x > 0:
		$Sprite.flip_h = true
		rotate(get_angle_to(Interface.player.position))
	else:
		$Sprite.flip_h = false
		rotate(get_angle_to(Interface.player.position)+PI)
	move_and_slide(direction)
	
	if hp <= 0:# and get_child_count() < 3:
		eliminate()

func eliminate():
	if $AnimationPlayer.is_playing():
		return
	.eliminate()
	get_node("AnimationPlayer").play("EnemyElim")