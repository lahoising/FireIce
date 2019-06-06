extends Position2D

onready var crosshair = get_parent().get_node("Crosshair")

const FIRESCENE = preload("res://Fire.tscn")
const ICESCENE = preload("res://Ice.tscn")

var shooting  = false
var type = 0

func _physics_process(delta):
	if shooting and $ShootCooldown.is_stopped():
		match(Interface.atk):
			Interface.Attacks.BASIC:
				basic_fire()
			Interface.Attacks.SNIPER:
				sniper_fire()
			Interface.Attacks.SHOTGUN:
				shotgun_fire()

func _input(event):
	if event.is_action_pressed("fire"):
		shooting = true
	elif event.is_action_released("fire"):
		shooting = false
	
	if Interface.controller == Interface.Controllers.MOUSE:
		if event.is_action_pressed("type_fire"):
			type = 0
		elif event.is_action_pressed("type_ice"):
			type = 1
		crosshair.setColor(type)
	elif event.is_action_pressed("change_type") and !event.is_echo():
		type = int(!bool(type))
		crosshair.setColor(type)
	
	if event.is_action_pressed("change_attack") and !event.is_echo():
		print("changing attack")
		Interface.nextAttack()
		Interface.updateAmmoHUD()
		crosshair.setCrosshair()
		$ShootCooldown.wait_time = Interface.weaponHandler.get_cooldown(Interface.atk)

func basic_fire():
	var projectile = null
	if type == 0:
		projectile = FIRESCENE
	else:
		projectile = ICESCENE
	var fireball = projectile.instance()
	fireball.global_position = global_position
	get_node("../../").add_child(fireball)
	$ShootCooldown.start()
	return fireball

func sniper_fire():
	var atk = Interface.atk
	var h = Interface.weaponHandler
	var ammo = h.ammo[h.attacks_ids[atk]]
	if ammo <= 0:
		return
	var fireball = basic_fire()
	fireball.dmg = 10
	var part = fireball.get_node("Particles2D")
	part.amount *= 2
	part.lifetime *= 1.2
	ammo -= 1
	h.ammo[h.attacks_ids[atk]] = ammo
	Interface.updateAmmoHUD()

func shotgun_fire():
	var atk = Interface.atk
	var h = Interface.weaponHandler
	var ammo = h.ammo[h.attacks_ids[atk]]
	if ammo <= 0:
		return
	var it = 3
	var off = 1
	if h.levels["shotgun"] > 1:
		it = 6
		off = 2.5
	for i in range(it):
		var fireball = basic_fire()
		fireball.direction += fireball.direction.tangent()*(i-off) / (7*off)
	ammo -= 1
	h.ammo[h.attacks_ids[atk]] = ammo
	Interface.updateAmmoHUD()

func _on_ShootCooldown_timeout():
	$ShootCooldown.stop()