extends KinematicBody2D
#fire = 0; ice = 1
var lasthit
var icehp = 15
var firehp = 15
const SPD = 50
const HITMARKER = preload("res://Assets/HitMarker.tscn")
onready var map = get_parent().get_parent()

func _ready():
	var path = map.get_simple_path(position, Interface.player.position, true)
	if path.size() <= 0 or (position - Interface.player.position).abs() < Vector2(1,1) *SPD:
		map.get_parent().totalEnemies -= 1
		map.get_parent().createMonster()
		queue_free()
	var iceprogress = get_node("VBoxContainer/IceProgress")
	iceprogress.max_value = icehp
	iceprogress.value = icehp
	var fireprogress = get_node("VBoxContainer/FireProgress")
	fireprogress.max_value = firehp
	fireprogress.value = firehp
	print(fireprogress.value)

func _physics_process(delta):
	if get_node("AnimationPlayer").current_animation == "MonsterElim":
		return
	if Interface.player != null:
		var direction = (Interface.player.position - position).normalized() * SPD
		#rotate(get_angle_to(Interface.player.position))
		move_and_slide(direction)
	
	if icehp <= 0 and firehp <= 0:
		eliminate()

func updateHpBar():
	$VBoxContainer/IceProgress.value = icehp
	$VBoxContainer/FireProgress.value = firehp

func eliminate():
	map.get_parent().changeScore(15, 25)
	Interface.player.updateXp(10)
	$CollisionShape2D.queue_free()
	$ElimParticle.emitting = true
	Interface.weaponHandler.update_elims(lasthit)
	get_node("AnimationPlayer").play("MonsterElim")
	#queue_free()

func takeDamage(type, dmg, weapon):
	if get_child_count() < 7:
		add_child(HITMARKER.instance())
	if type == 1:
		firehp -= dmg
	else:
		icehp -= dmg
	lasthit = weapon
	updateHpBar()

func drainedType(type, weapon):
	if type:
		icehp = 0
	else:
		firehp = 0
	lasthit = weapon
	updateHpBar()