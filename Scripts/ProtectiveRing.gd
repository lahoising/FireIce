extends Node2D

var dmg = 10
var weapon = "ring"

func _ready():
	$AnimationPlayer.play("StartRing")
	$AnimationPlayer.queue("Rotate")
	if Interface.weaponHandler.levels[weapon] >= 3:
		dmg *= 2

func check_speed():
	if Interface.weaponHandler.levels[weapon] >= 2:
		$AnimationPlayer.playback_speed = 2

func _on_ring_body_entered(body):
	if "Enemy" in body.name or "Mob" in body.name:
		body.takeDamage(dmg, weapon)
	elif "Monster" in body.name:
		if body.icehp >= 0:
			body.takeDamage(0, dmg, weapon)
		else:
			body.takeDamage(1, dmg, weapon)

func _on_Timer_timeout():
	$AnimationPlayer.play("Ending")
	if Interface.weaponHandler.levels[weapon] >= 2:
		$AnimationPlayer.playback_speed = 1

func ended():
	for child in get_children():
		if "Area2D" in child.name:
			var p = child.get_node("Particles2D")
			p.lifetime = float(1.0)
			p.process_material.initial_velocity = 50
