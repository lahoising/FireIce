extends ItemList

var index = {}

func _ready():
	get_v_scroll().visible = false
	populate_list()
	rect_size.y += get_item_count() * 24
	rect_global_position.y -= rect_size.y
	if get_item_count() > 0:
		select_item()

func _input(event):
	if event.is_action("change_weapon") and !event.is_echo():
		select_item()
		$Timer.stop()
		$Timer.start()

func populate_list():
	var id = 0
	var ar = Interface.weaponHandler.available_weapons
	if "health" in ar:
		var icon = load("res://Sprites/Assets/fullheart.png")
		add_icon_item(icon)
		index["health"] = id
		id += 1
	if "static bomb" in ar:
		var icon = load("res://Sprites/Assets/ice.png")
		add_icon_item(icon)
		index["static bomb"] = id
		id += 1
	if "ring" in ar:
		var icon = load("res://Sprites/Weapons/ProtectiveRing.png")
		add_icon_item(icon)
		index["ring"] = id
		id += 1
	if "big bomb" in ar:
		var icon = load("res://Sprites/Weapons/fire.png")
		add_icon_item(icon)
		index["big bomb"] = id
		id += 1
	if "hole" in ar:
		var icon = load("res://Sprites/Assets/BlackHoleIcon.png")
		add_icon_item(icon)
		index["hole"] = id
		id += 1
	if "nuke" in ar:
		var icon = load("res://Sprites/Assets/Nuke.png")
		add_icon_item(icon)
		index["nuke"] = id
		id += 1

func select_item():
	var item = Interface.item
	if item == Interface.Items.HEALTH:
		select(index["health"])
	elif item == Interface.Items.STATICBOMB:
		select(index["static bomb"])
	elif item == Interface.Items.RING:
		select(index["ring"])
	elif item == Interface.Items.BIGBOMB:
		select(index["big bomb"])
	elif item == Interface.Items.HOLE:
		select(index["hole"])
	elif item == Interface.Items.NUKE:
		select(index["nuke"])

func _on_Timer_timeout():
	queue_free()