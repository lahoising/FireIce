extends Node

const ENEMY = preload("res://Enemy.tscn")
const MOB = preload("res://Mob.tscn")
const FIREENEMY = preload("res://Sprites/Entities/fireenemy2.png")
const ICEENEMY = preload("res://Sprites/Entities/iceenemy2.png")
const FIREMOB = preload("res://Sprites/Entities/FireMob.png")
const ICEMOB = preload("res://Sprites/Entities/IceMob.png")
const GAMEOVER = preload("res://GameOver.tscn")
const MENU = preload("res://Menu.tscn")
const MONSTER = preload("res://Monster.tscn")
const waitScreen = preload("res://WaitScreen.tscn")
onready var timer = get_node("Timer")
onready var player = $Player
onready var scoreLabel = get_node("HUD/HUD/HBoxContainer/Points")
onready var creditsLabel = get_node("HUD/HUD/HBoxContainer/Credits")
onready var map = get_node("Navigation2D/TileMap")
var time
var totalEnemies = 0
var maxEnemies = 10

func _ready():
	time = timer.wait_time
	timer.paused = true
	Interface.world = self
	changeScore(0,0)
	Interface.updateHUD()
	$MonsterTimer.start()
	$HUD.add_child(waitScreen.instance())
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	#scoreLabel.text = str(score)
	#if $MonsterTimer.paused and map.get_child_count() < maxEnemies:
	#	createMonster()
	
	if timer.paused and map.get_child_count() < maxEnemies:
		createEnemy()
		restart_timer()

func _input(event):
	if event.is_action_pressed("pause"):
		var menu = MENU.instance()
		get_node("HUD").add_child(menu)

func createEnemy():
	randomize()
	totalEnemies += 1
	var enemy
	if randi()%2 == 0:
		enemy = ENEMY.instance()
		if randi()%2 == 0:
			enemy.get_node("Sprite").texture = FIREENEMY
			enemy.type = 0
		else:
			enemy.get_node("Sprite").texture = ICEENEMY
			enemy.type = 1
	else:
		enemy = MOB.instance()
		if randi()%2 == 0:
			enemy.get_node("Sprite").texture = FIREMOB
			enemy.type = 0
		else:
			enemy.get_node("Sprite").texture = ICEMOB
			enemy.type = 1
	enemy.hp *= pow(1.05, $Player.lvl - 1)
	enemy.position = Vector2(rand_range(0, get_viewport().size.x), rand_range(0, get_viewport().size.y))
	map.add_child(enemy)

func restart_timer():
	timer.wait_time = time
	timer.paused = false
	timer.start()

func _on_Timer_timeout():
	timer.paused = true

func changeScore(points, cred):
	Interface.score += points
	Interface.credits += cred
	scoreLabel.text = str(Interface.score)
	creditsLabel.text = "Credits: " + str(Interface.credits)

func lost():
	get_tree().change_scene("res://GameOver.tscn")

func createMonster():
	if totalEnemies > maxEnemies:
		return
	totalEnemies += 1
	var enemy = MONSTER.instance()
	enemy.icehp *= pow(1.05, $Player.lvl - 1)
	enemy.firehp *= pow(1.05, $Player.lvl - 1)
	enemy.position = Vector2(rand_range(32, Interface.player.get_node("Camera2D").limit_right-32), rand_range(32, Interface.player.get_node("Camera2D").limit_bottom-32))
	$MonsterTimer.wait_time = 15
	$MonsterTimer.paused = false
	$MonsterTimer.start()
	map.add_child(enemy)

func _on_MonsterTimer_timeout():
	$MonsterTimer.paused = true

func updateWave():
	totalEnemies = 0
	if maxEnemies < 45:
		maxEnemies += 5