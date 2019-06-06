extends Node2D

var direction
var dmg = 1
var dest
var bodies = []
var spd = 300
var gravity = 200
var lvl

func _ready():
	$Breaker.playing = true
	direction = (Interface.crosshair.rect_global_position - self.global_position).normalized()
	#direction = (Vector2(100,100) - position).normalized()
	dest = position + direction * 300
	lvl = Interface.weaponHandler.levels["hole"]
	if lvl >= 2:
		$Done.wait_time *= 1.5

func _physics_process(delta):
	#print(abs(position.distance_to(dest)))
	if abs(position.distance_to(dest)) >= 5:
		position += direction*spd*delta
	elif $Done.is_stopped():
		$Done.start()
	for body in bodies:
		var dir = (position - body.position).normalized()
		body.position += dir*gravity*delta
		if lvl >= 3:
			body.scale -= Vector2(0.05, 0.05)
		if body.scale <= Vector2(0,0):
			if "Enemy" in body.name:
				body.takeDamage(body.hp, "hole")
			elif "Monster" in body.name:
				body.drainedType(0)
				body.drainedType(1)
			bodies.erase(body)

func _on_Timer_timeout():
	for body in bodies:
		if "Enemy" in body.name:
			body.takeDamage(dmg, "hole")
		elif "Monster" in body.name:
			if body.icehp >= 0:
				body.takeDamage(0, dmg, "hole")
			else:
				body.takeDamage(1, dmg, "hole")

func _on_Area2D_body_entered(body):
	if body in bodies:
		return
	if "Enemy" in body.name or "Monster" in body.name or "Mob" in body.name:
		bodies.append(body)

func _on_Area2D_body_exited(body):
	if body in bodies:
		bodies.erase(body)

func _on_Done_timeout():
	queue_free()
