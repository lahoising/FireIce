extends Node

var credits
var score
"""
var health
var sbombs
var bbombs
var abombs
var rings
var holes"""
var item

var atk
"""
var shotgun
var sniper
"""
var world = null
var player = null
var hud = null
var weaponHandler = null
var crosshair

var controller = Controllers.MOUSE

enum Items{
	HEALTH,
	STATICBOMB,
	RING,
	BIGBOMB,
	HOLE,
	NUKE
}

enum Attacks{
	BASIC,
	SHOTGUN,
	SNIPER
}

enum Controllers{
	MOUSE,
	KEYBOARD,
	GAMEPAD
}

func _ready():
	restartAll()
"""
func overrideAmmo():
	var ar = weaponHandler.available_weapons
	var curr = "health"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = health
	#weaponHandler.weapons[curr] = health
	
	curr = "static bomb"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = sbombs
	#weaponHandler.weapons[curr] = sbombs
	
	curr = "big bomb"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = bbombs
	#weaponHandler.weapons[curr] = bbombs
	
	curr = "nuke"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = abombs
	#weaponHandler.weapons[curr] = abombs
	
	curr = "ring"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = rings
	#weaponHandler.weapons[curr] = rings
	
	curr = "hole"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = holes
	#weaponHandler.weapons[curr] = holes
	
	curr = "shotgun"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = shotgun
	#weaponHandler.weapons[curr] = shotgun
	
	curr = "sniper"
	if !(curr in ar):
		weaponHandler.unlock_weapon(curr)
	weaponHandler.ammo[curr] = sniper
	#weaponHandler.weapons[curr] = sniper
"""
func restartAll():
	credits = 0
	score = 0
	"""health = 0
	sbombs = 0
	bbombs = 0
	abombs = 0
	rings = 0
	holes = 0"""
	item = -1
	atk = 0
	"""shotgun = 0
	sniper = 0"""
	world = null
	player = null
	hud = null
	crosshair = null

func updateHUD():
	if hud == null:
		return
	hud.update()
	#weaponHandler.update_item_ammo(item)

func updateAmmoHUD():
	if hud == null:
		return
	hud.updateAmmo()
	#weaponHandler.update_attack_ammo(atk)

func updateExp(newLvl):
	hud.updateExp(newLvl)
	if newLvl:
		world.updateWave()

func check_item_availability():
	if item == -1:
		return
	if !weaponHandler.check_item_availability(item):
		nextWeapon()

func check_attack_availability():
	if !weaponHandler.check_attack_availability(atk):
		nextAttack()
"""
func updateAmmo(weapon, ammo):
	if weapon == "static bomb":
		sbombs = ammo
	elif weapon == "ring":
		rings = ammo
	elif weapon == "big bomb":
		bbombs = ammo
	elif weapon == "hole":
		holes = ammo
	elif weapon == "nuke":
		abombs = ammo
	elif weapon == "health":
		health = ammo
	elif weapon == "sniper":
		sniper = ammo
	elif weapon == "shotgun":
		shotgun = ammo
	updateAmmoHUD()
"""
func nextWeapon():
	var ar = weaponHandler.available_weapons
	if item == -1:
		for i in range(Items.size()):
			if weaponHandler.check_item_availability(i):
				item = i
		if item == -1:
			return
	if item == Items.HEALTH and ar.has("static bomb"):
		item = Items.STATICBOMB
	elif item == Items.STATICBOMB and ar.has("ring"):
		item = Items.RING
	elif item == Items.RING and ar.has("big bomb"):
		item = Items.BIGBOMB
	elif item == Items.BIGBOMB and ar.has("hole"):
		item = Items.HOLE
	elif item == Items.HOLE and ar.has("nuke"):
		item = Items.NUKE
	elif item == Items.NUKE and ar.has("health"):
		item = Items.HEALTH
	else:
		item = (item+1)%Items.size()
		nextWeapon()

func nextAttack():
	var ar = weaponHandler.available_weapons
	if atk == Attacks.BASIC and ar.has("shotgun"):
		atk = Attacks.SHOTGUN
	elif atk == Attacks.SHOTGUN and ar.has("sniper"):
		atk = Attacks.SNIPER
	elif atk == Attacks.SNIPER and ar.has("basic"):
		atk = Attacks.BASIC
	else:
		atk = (atk+1)%Attacks.size()
		nextAttack()