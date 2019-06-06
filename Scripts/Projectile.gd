extends Area2D

const FIRESPEED = 300
var dmg = 1
var direction = Vector2()
var weapon
const ICE = preload("res://Sprites/Weapons/ice.png")
export(int) var type = 1

func _ready():
	direction = (Interface.crosshair.rect_global_position - self.global_position).normalized()
	update_damage(Interface.atk)
	weapon = Interface.weaponHandler.identify("attack", Interface.atk)

func _physics_process(delta):
	self.position = (self.position + direction*FIRESPEED*delta)

func update_damage(atk):
	var handler = Interface.weaponHandler
	match(atk):
		Interface.Attacks.BASIC:
			match(handler.levels["basic"]):
				3:
					dmg *= 2
		Interface.Attacks.SNIPER:
			match(handler.levels["sniper"]):
				3:
					dmg *= 1.5
		Interface.Attacks.SHOTGUN:
			match(handler.levels["shotgun"]):
				3:
					dmg *= 2

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_Fire_body_entered(body):
	if "Enemy" in body.name or "Mob" in body.name:
		if body.type != self.type:
			body.takeDamage(dmg, weapon)
			queue_free()
	elif "Monster" in body.name:
		body.takeDamage(type, dmg, weapon)
		queue_free()