extends Node2D

func _ready():
	$AnimationPlayer.play("Explosion")
	var lvl = Interface.weaponHandler.levels["big bomb"]
	if lvl >= 3:
		$Area2D.scale *= 1.5
	elif lvl == 2:
		$Area2D.scale *= 1.25

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name or "Mob" in body.name:
		body.takeDamage(body.hp, "big bomb")
		#body.eliminate()
	elif "Monster" in body.name:
		body.drainedType(1, "big bomb")