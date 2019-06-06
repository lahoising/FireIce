extends Node2D

var lvl
var direction
var dest
var weapon

func _ready():
	lvl = Interface.weaponHandler.levels["static bomb"]
	var pointer_position = Interface.crosshair.rect_global_position
	direction = (pointer_position - global_position).normalized()
	dest = position + direction * min(200, abs(global_position.distance_to(pointer_position)))
	weapon = "static bomb"

func _physics_process(delta):
	if lvl >= 3 and position.distance_squared_to(dest) >= 25:
		position += direction * 200 * delta

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name or "Mob" in body.name:
		if lvl >= 2:
			body.takeDamage(body.hp, weapon)
		else:
			body.takeDamage(15, weapon)
		queue_free()
	elif "Monster" in body.name:
		print("static here")
		if lvl >= 2:
			body.drainedType(0, weapon)
		else:
			body.takeDamage(0, 15, weapon)
		queue_free()
