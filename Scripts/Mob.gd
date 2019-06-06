extends "res://Scripts/Entity.gd"

var dspd = 400
var calc = false
var target = Vector2()
var tdir = Vector2()
var away = false

func _ready():
	._ready()
	SPD = 100

func _physics_process(delta):
	if $AnimationPlayer.is_playing():
		return
	
	if calc:
		if $Timer.is_stopped():
			if $Wait.is_stopped():
				move_and_slide(tdir * dspd)
			if (target - self.global_position).abs() <= Vector2(1,1) or away:
				#calc = false
				#$Flash.emitting = false
				#$Flash.visible = false
				$CollisionShape2D.disabled = false
				$Wait.start()
		else:
			$Sprite.look_at(Interface.player.global_position)
	else:
		$Sprite.look_at(Interface.player.global_position)
		var dir = (Interface.player.global_position - global_position)
		move_and_slide(dir.normalized() * SPD)
		if dir.abs() <= Vector2(150,150):
			calculating()

func calculating():
	calc = true
	$Timer.start()

func eliminate():
	if $AnimationPlayer.is_playing():
		return
	$Sprite.visible = false
	#$Flash.emitting = false
	#$Flash.visible = false
	.eliminate()
	get_node("AnimationPlayer").play("Elim")

func _on_Timer_timeout():
	$Timer.stop()
	tdir = (Interface.player.global_position - global_position).normalized()
	target = self.position + tdir * 300
	#var part = $Flash
	#part.visible = true
	#part.texture = $Sprite.texture
	#part.emitting = true
	#part.process_material.angle = (tdir.angle() * -180 / PI) + 180
	$CollisionShape2D.disabled = true

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	away = true

func _on_VisibilityNotifier2D_viewport_entered(viewport):
	away = false

func _on_Wait_timeout():
	$Wait.stop()
	calc = false