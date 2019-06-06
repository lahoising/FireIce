extends Node

var weapons = []
var available_weapons = []
var items_ids = {}
var attacks_ids = {}
var elims_counter = {}
var upgrades = {
	"basic": [30, 50, 75],
	"static bomb": [10, 20, 35],
	"sniper": [30, 50, 75],
	"ring": [15, 30, 55],
	"shotgun": [35, 60,  100],
	"hole": [20, 50, 100],
	"big bomb": [20, 60, 100]
}
var levels = {}
var ammo = {}
var descriptions = {}

const anim = preload("res://LevelingUp.tscn")

#var Weapon = preload("res://Scripts/WeaponHandler/Weapon.gd")

func _ready():
	Interface.weaponHandler = self
	fill_descriptions()
	populate_ids()
	unlock_weapon("basic")
	Interface.check_item_availability()
	Interface.check_attack_availability()
	#Interface.overrideAmmo()

func populate_ids():
	var atks = Interface.Attacks
	for id in range(atks.size()):
		if id == atks.BASIC:
			attacks_ids[id] = "basic"
		elif id == atks.SHOTGUN:
			attacks_ids[id] = "shotgun"
		elif id == atks.SNIPER:
			attacks_ids[id] = "sniper"
		else:
			attacks_ids[id] = "not here"
	
	var its = Interface.Items
	for id in range(its.size()):
		if id == its.HEALTH:
			items_ids[id] = "health"
		elif id == its.STATICBOMB:
			items_ids[id] = "static bomb"
		elif id == its.RING:
			items_ids[id] = "ring"
		elif id == its.BIGBOMB:
			items_ids[id] = "big bomb"
		elif id == its.HOLE:
			items_ids[id] = "hole"
		elif id == its.NUKE:
			items_ids[id] = "nuke"
		else:
			items_ids[id] = "not here"

func fill_descriptions():
	descriptions["basic"] = "Just a basic weapon, and as such it has infinite ammo. Each bullet deals 1 dmg, adn has a fire rate of 3 burst/s. Not really too wow. \n\nlvl 2 - half fire rate\n\nlvl 3 - x2 damage"
	
	descriptions["shotgun"] = "This is similar to the basic rifle, but it shoots 3 bullets per burst, and the fire rate is of 2 bursts/s\n\nlvl 2 - four bullets per burst\n\nlvl 3 - x2 damage"
		
	descriptions["sniper"] = "The fire rate is of 1 burst/s, but each bullet deals 8\n\nlvl 2 - half fire rate\n\nlvl 3 - x2 damage"
	
	descriptions["health"] = "Gives you an extra life\n\nCan only be purchased at times in the store"
	
	descriptions["static bomb"] = "A bomb that explodes when an enemy touches it.\n\nlvl 2 - Completely eliminates minions at touch, and drains fire hp of big minions\n\nlvl 3 - You can throw it, giving you an oportunity to use it as a barrier"
	
	descriptions["ring"] = "A ring of fire and ice protects you.\n\nlvl 2 - damage rate x2\n\nlvl 3 -damage x2"
	
	descriptions["big bomb"] = "A bomb that explodes minions when they touch it, and drains ice hp of big minions\n\nlvl 2 - radius x1.25\n\nlvl 3 - radius x1.5"
	
	descriptions["hole"] = "A hole that sucks in every enemy that comes in its way, dealing damage over time.\n\nlvl 2 - duration x1.25\n\nlvl 3 - instantly eliminates enemies"
	
	descriptions["nuke"] = "Explodes every enemy\n\nCan only be purchased at times in the store"

func unlock_weapon(weapon):
	available_weapons.append(weapon)
	elims_counter[weapon] = 0
	levels[weapon] = 1
	var t = ""
	ammo[weapon] = 1
	for at in attacks_ids.values():
		if at == weapon:
			ammo[weapon] = 50
	Interface.updateHUD()
	Interface.updateAmmoHUD()
	if weapon == "basic":
		return
	get_parent().call_deferred("add_child", anim.instance())

func check_item_availability(id):
	return available_weapons.has(items_ids[id])

func check_attack_availability(id):
	return available_weapons.has(attacks_ids[id])

func check_upgrade(weapon):
	if !(weapon in available_weapons):
		return
	var upgrade = false
	if levels[weapon] == 1:
		var up = upgrades[weapon][0]
		if weapon == "basic":
			if elims_counter[weapon] >= up and !available_weapons.has("static bomb"):
				unlock_weapon("static bomb")
				Interface.nextWeapon()
				Interface.updateHUD()
				Interface.updateAmmoHUD()
		elif weapon == "static bomb" and !available_weapons.has("sniper"):
			if elims_counter[weapon] >= up:
				unlock_weapon("sniper")
		elif weapon == "sniper" and !available_weapons.has("ring"):
			if elims_counter[weapon] >= up:
				unlock_weapon("ring")
		elif weapon == "ring" and !available_weapons.has("shotgun"):
			if elims_counter[weapon] >= up:
				unlock_weapon("shotgun")
		elif weapon == "shotgun" and !available_weapons.has("hole"):
			if elims_counter[weapon] >= up:
				unlock_weapon("hole")
		elif weapon == "hole" and !available_weapons.has("big bomb"):
			if elims_counter[weapon] >= up:
				unlock_weapon("big bomb")
		elif weapon == "big bomb" and levels["basic"] <= 1:
			if elims_counter[weapon] >= up:
				levelUp("basic")
	elif levels[weapon] == 2:
		var up = upgrades[weapon][1]
		if weapon == "basic" and elims_counter[weapon] >= up and levels["static bomb"] <= 1:
			levelUp("static bomb")
		elif weapon == "static bomb" and elims_counter[weapon] >= up and levels["sniper"] <= 1:
			levelUp("sniper")
		elif weapon == "sniper" and elims_counter[weapon] >= up and levels["ring"] <= 1:
			levelUp("ring")
		elif weapon == "ring" and elims_counter[weapon] >= up and levels["shotgun"] <= 1:
			levelUp("shotgun")
		elif weapon == "shotgun" and elims_counter[weapon] >= up and levels["hole"] <= 1:
			levelUp("hole")
		elif weapon == "hole" and elims_counter[weapon] >= up and levels["big bomb"] <= 1:
			levelUp("big bomb")
		elif weapon == "big bomb" and elims_counter[weapon] >= up and levels["basic"] <= 2:
			levelUp("basic")
	elif levels[weapon] == 3:
		var up = upgrades[weapon][2]
		if weapon == "basic" and elims_counter[weapon] >= up and levels["static bomb"] <= 2:
			levelUp("static bomb")
		elif weapon == "static bomb" and elims_counter[weapon] >= up and levels["sniper"] <= 2:
			levelUp("sniper")
		elif weapon == "sniper" and elims_counter[weapon] >= up and levels["ring"] <= 2:
			levelUp("ring")
		elif weapon == "ring" and elims_counter[weapon] >= up and levels["shotgun"] <= 2:
			levelUp("shotgun")
		elif weapon == "shotgun" and elims_counter[weapon] >= up and levels["hole"] <= 2:
			levelUp("hole")
		elif weapon == "hole" and elims_counter[weapon] >= up and levels["big bomb"] <= 2:
			levelUp("big bomb")
		elif weapon == "big bomb" and elims_counter[weapon] >= up and levels["big bomb"] <= 2:
			if !("health" in available_weapons):
				unlock_weapon("health")
			else:
				ammo["health"] += 1

func levelUp(next):
	levels[next] += 1
	elims_counter[next] = 0
	var extra = 2
	for at in attacks_ids.values():
		if at == next:
			extra = 50
	ammo[next] += extra
	Interface.updateAmmoHUD()
	Interface.updateHUD()
	var anim = load("res://LevelingUp.tscn")
	get_parent().add_child(anim.instance())

func update_elims(lasthit):
	elims_counter[lasthit] += 1
	check_upgrade(lasthit)
	print(elims_counter)

func update_item_ammo(it):
	if it == -1:
		return
	ammo[items_ids[it]] -= 1

func update_attack_ammo(atk):
	ammo[attacks_ids[atk]] -= 1

func identify(type, id):
	match(type):
		"item":
			match(id):
				Interface.Items.STATICBOMB:
					return "static bomb"
				Interface.Items.RING:
					return "ring"
				Interface.Items.BIGBOMB:
					return "big bomb"
				Interface.Items.HOLE:
					return "hole"
		"attack":
			match(id):
				Interface.Attacks.BASIC:
					return "basic"
				Interface.Attacks.SHOTGUN:
					return "shotgun"
				Interface.Attacks.SNIPER:
					return "sniper"
	return ""

func get_cooldown(atk):
	var handler = Interface.weaponHandler
	var ret
	var base
	match(atk):
		Interface.Attacks.BASIC:
			ret = 0.33
			if handler.levels["basic"] >= 2:
				ret /= 2
		Interface.Attacks.SNIPER:
			ret = 1.0
			if handler.levels["basic"] >= 2:
				ret /= 2
		Interface.Attacks.SHOTGUN:
			base = 0.4
			ret = base
			"""match(handler.levels["shotgun"]):
				1:
					pass
				2:
					pass
				3:
					dmg *= 2"""
	print(ret)
	return ret