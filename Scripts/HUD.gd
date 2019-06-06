extends Control

const HEALTH = preload("res://Sprites/Weapons/fullheart.png")
const SBOMB = preload("res://Sprites/Weapons/ice.png")
const RING = preload("res://Sprites/Weapons/ProtectiveRing.png")
const BBOMB = preload("res://Sprites/Weapons/fire.png")
const ABOMB = preload("res://Sprites/Assets/Nuke.png")
const HOLE = preload("res://Sprites/Assets/BlackHoleIcon.png")
const ITEMSELECT = preload("res://ItemSelector.tscn")

func _ready():
	Interface.hud = self
	setMaxHp(Interface.player.hp)
	healthChanged(Interface.player.hp)
	updateExp(true)
	updateAmmo()
	update()

func _input(event):
	if event.is_action_pressed("change_weapon") and !event.is_echo():
		print("checking")
		for child in get_children():
			if child.name == "ItemSelector":
				return
		print("creating")
		var list = ITEMSELECT.instance()
		list.rect_global_position = $MarginContainer/HBoxContainer.rect_global_position + Vector2(0, -15)
		add_child(list)

func healthChanged(health):
	#$HBoxContainer/HealthBar.value = health
	$HBoxContainer/Status/VBoxContainer/Container/HealthBar.value = health

func setMaxHp(maxhp):
	#$HBoxContainer/HealthBar.max_value = maxhp
	$HBoxContainer/Status/VBoxContainer/Container/HealthBar.max_value = maxhp

func updateAmmo():
	var h = Interface.weaponHandler
	var ammo = h.ammo[h.attacks_ids[Interface.atk]]
	if Interface.atk == Interface.Attacks.BASIC:
		get_node("MarginContainer/HBoxContainer/HBoxContainer2/Attack").text = "Basic"
		get_node("MarginContainer/HBoxContainer/HBoxContainer2/Count").text = "Full"
	elif Interface.atk == Interface.Attacks.SHOTGUN:
		get_node("MarginContainer/HBoxContainer/HBoxContainer2/Attack").text = "Shotgun"
		get_node("MarginContainer/HBoxContainer/HBoxContainer2/Count").text = str(ammo)
	elif Interface.atk == Interface.Attacks.SNIPER:
		get_node("MarginContainer/HBoxContainer/HBoxContainer2/Attack").text = "Sniper"
		get_node("MarginContainer/HBoxContainer/HBoxContainer2/Count").text = str(ammo)

func updateExp(newLvl):
	#var xpbar = $HBoxContainer/ExpBar 
	var xpbar = $HBoxContainer/Status/VBoxContainer/Container2/ExpBar
	if newLvl:
		xpbar.max_value = Interface.player.maxXp
		$HBoxContainer/Status/Level/Label.text = str(Interface.player.lvl)
		#$HBoxContainer/Level.text = "Lvl " +str(Interface.player.lvl)
	xpbar.value = Interface.player.xp

func update():
	var icon = $MarginContainer/HBoxContainer/HBoxContainer/CenterContainer/WImage
	var label = $MarginContainer/HBoxContainer/HBoxContainer/Weapon
	var count = $MarginContainer/HBoxContainer/HBoxContainer/Count
	var h = Interface.weaponHandler
	var ammo = 0
	if Interface.item >= 0:
		ammo = h.ammo[h.items_ids[Interface.item]]
	if Interface.item == Interface.Items.HEALTH:
		icon.texture = HEALTH
		label.text = "Health"
		count.text = str(ammo)
	elif Interface.item == Interface.Items.STATICBOMB:
		icon.texture = SBOMB
		label.text = "Static Bomb"
		count.text = str(ammo)
	elif Interface.item == Interface.Items.RING:
		icon.texture = RING
		label.text = "Ring"
		count.text = str(ammo)
	elif Interface.item == Interface.Items.BIGBOMB:
		icon.texture = BBOMB
		label.text = "Big Bomb"
		count.text = str(ammo)
	elif Interface.item == Interface.Items.HOLE:
		icon.texture = HOLE
		label.text = "Black Hole"
		count.text = str(ammo)
	elif Interface.item == Interface.Items.NUKE:
		icon.texture = ABOMB
		label.text = "Nuke"
		count.text = str(ammo)
	else:
		icon.texture = null
		label.text = ""
		count.text = ""