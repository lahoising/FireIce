extends KinematicBody2D

var hp = 5
var lasthit
var SPD = 150
onready var map = get_parent().get_parent()
const HITMARKER = preload("res://Assets/HitMarker.tscn")
export(int) var type = 0

func _ready():
	var path = map.get_simple_path(position, Interface.player.position, true)
	if path.size() <= 0 or (global_position - Interface.player.global_position).abs() < Vector2(1,1) * SPD:
		map.get_parent().totalEnemies -= 1
		#map.get_parent().createEnemy()
		queue_free()
	$HealthBar.max_value = hp
	$HealthBar.value = hp
	get_node("AnimationPlayer").stop()

func eliminate():
	map.get_parent().changeScore(5, 10)
	Interface.player.updateXp(5)
	rotation = 0
	$CollisionShape2D.queue_free()
	$ElimParticle.emitting = true
	Interface.weaponHandler.update_elims(lasthit)

func takeDamage(dmg, weapon):
	if get_child_count() < 6:
		var hmkr = HITMARKER.instance()
		add_child(hmkr)
	hp -= dmg
	$HealthBar.value = hp
	lasthit = weapon
	if hp <= 0:
		eliminate()