extends KinematicBody2D

var motion = Vector2()
var maxXp = 100
var xp = 0
var lvl = 1
var hp
#var type = 0
#var shooting = false
const MAXHP = 6
const spd = 175
#const FIRESCENE = preload("res://Fire.tscn")
#const ICESCENE = preload("res://Ice.tscn")
const STATBOMB = preload("res://StaticBomb.tscn")
const RING = preload("res://ProtectiveRing.tscn")
const BIGBOMB = preload("res://BigBomb.tscn")
const HOLE = preload("res://BlackHole.tscn")
const NUKE = preload("res://Nuke.tscn")
#const NUKE = preload("res://NukeAnim.tscn")
onready var hpbar = get_parent().get_node("HUD/HUD")

func _ready():
	hp = MAXHP
	Interface.player = self
	#$ShootCooldown.wait_time = 0.33
	$AnimationPlayer.play("IdleS")

func _process(delta):
	if hp <= 0:
		get_parent().lost()
		get_tree().paused = true
	
	if motion.x > 0: 
		$Sprite.flip_h = false
		if motion.y > 0:
			$AnimationPlayer.play("IdleSE")
		elif motion.y < 0:
			$AnimationPlayer.play("IdleNE")
		else:
			$AnimationPlayer.play("IdleE") 
	elif motion.x < 0:
		$Sprite.flip_h = true
		if motion.y > 0:
			$AnimationPlayer.play("IdleSE")
		elif motion.y < 0:
			$AnimationPlayer.play("IdleNE")
		else:
			$AnimationPlayer.play("IdleE")
	else: 
		if motion.y > 0:
			$AnimationPlayer.play("IdleS")
		elif motion.y < 0:
			pass
	
	#if shooting:
	#	fire(type)

func _physics_process(delta):
	move_and_slide(motion*spd)

func _input(event):
	motion.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	motion.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if Input.is_action_just_pressed("special"):
		var go = false
		var bomb = null
		var a = false
		var item = Interface.item
		var h = Interface.weaponHandler
		var ammo = h.ammo[h.items_ids[item]]
		if item == Interface.Items.HEALTH and ammo > 0 and hp < MAXHP:
			hp += 1
			ammo -= 1
			hpbar.healthChanged(hp)
			#Interface.updateHUD()
		elif item == Interface.Items.STATICBOMB and ammo > 0:
			bomb = STATBOMB.instance()
			go = true
			#Interface.sbombs -= 1
			ammo -=1 
		elif item == Interface.Items.RING and ammo > 0:
			bomb = RING.instance()
			add_child(bomb)
			#Interface.rings -= 1
			ammo -= 1
		elif item == Interface.Items.BIGBOMB and ammo > 0:
			bomb = BIGBOMB.instance()
			go = true
			#Interface.bbombs -= 1
			ammo -= 1
		elif item == Interface.Items.HOLE and ammo > 0:
			bomb = HOLE.instance()
			go = true
			#Interface.holes -= 1
			ammo -= 1
		elif item == Interface.Items.NUKE and ammo > 0:
			#Interface.abombs -= 1
			ammo -= 1
			bomb = NUKE.instance()
			go = true
			#a = true
		if go:
			bomb.position = position
			get_parent().add_child(bomb)
			get_parent().move_child(bomb, get_position_in_parent())
		h.ammo[h.items_ids[item]] = ammo
		Interface.updateHUD()
	elif Input.is_action_just_pressed("change_weapon"):
		Interface.nextWeapon()
		Interface.updateHUD()

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name or "Mob" in body.name:
		body.queue_free()
		var anim = get_node("Sprite/AnimationPlayer")
		anim.play("Start")
		anim.play("TakeDamage")
		hp -= 1
		hpbar.healthChanged(hp)
	elif "Monster" in body.name:
		body.queue_free()
		var anim = get_node("Sprite/AnimationPlayer")
		anim.play("Start")
		anim.play("TakeDamage")
		hp -= 2
		hpbar.healthChanged(hp)

func updateXp(pts):
	var newLvl = false
	xp += pts
	if xp > maxXp:
		xp -= maxXp
		maxXp *= 1.2
		lvl += 1
		if get_parent().time > 0.3:
			if get_parent().time * 0.9 >= 0.3:
				get_parent().time *= 0.9
			else:
				get_parent().time = 0.3
		print(get_parent().time)
		newLvl = true
	Interface.updateExp(newLvl)

func _on_ShootCooldown_timeout():
	$ShootCooldown.stop()