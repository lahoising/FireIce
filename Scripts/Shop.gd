extends Control

const sbcost = 50
const rcost = 250
const bbcost = 1000
const abcost = 2500
const hcost = 700
const bhcost = 500
const shotguncost = 100
const snipercost = 50

var Weapon = preload("res://Scripts/WeaponHandler/Weapon.gd")

var prices = {
	"static bomb": 50,
	 "ring": 250, 
	"big bomb": 1000, 
	"nuke": 2500, 
	"health": 700,
	"hole": 500,
	"shotgun": 100,
	"sniper": 150
}

var current = ""

func _ready():
	updateCreditsLabel()
	$Control/MarginContainer/VBoxContainer/Items/Row/CenterContainer/StaticBomb.grab_focus()
	
	var ar = Interface.weaponHandler.available_weapons
	if "static bomb" in ar:
		$Control/MarginContainer/VBoxContainer/Items/Row/CenterContainer/StaticBomb.disabled = false
	if "sniper" in ar:
		$Control/MarginContainer/VBoxContainer/Items/Row/CenterContainer2/Sniper.disabled = false
	if "ring" in ar:
		$Control/MarginContainer/VBoxContainer/Items/Row/CenterContainer3/Ring.disabled = false
	
	if "shotgun" in ar:
		$Control/MarginContainer/VBoxContainer/Items/Row2/CenterContainer2/Shotgun.disabled = false
	if "hole" in ar:
		$Control/MarginContainer/VBoxContainer/Items/Row2/CenterContainer3/BlackHole.disabled = false
	if "big bomb" in ar:
		$Control/MarginContainer/VBoxContainer/Items/Row2/CenterContainer/BigBomb.disabled = false

func _input(event):
	if event.is_action_pressed("ui_cancel") and !event.is_echo():
		if $Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/Buy.has_focus():
			$Control/MarginContainer/VBoxContainer/Items/Row/CenterContainer/StaticBomb.grab_focus()
		else:
			goBack()

func gotobuy():
	$Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/Buy.grab_focus()

func updateDetails(curr):
	var lvl = $Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Level
	var n = $Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Name
	var owned = $Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Owned
	var price = $Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Price
	var h = Interface.weaponHandler
	n.text = curr
	price.text = "Cost: " + str(prices[curr])
	if curr in h.available_weapons:
		owned.text = "Owned: " + str(h.ammo[curr])
		lvl.text = "lvl. " + str(h.levels[curr])
	else:
		owned.text = "n/a"
		lvl.text = "locked"
	$Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/Description.text = h.descriptions[curr]
	current = curr

func updateCreditsLabel():
	$Control/MarginContainer/VBoxContainer/Credits.text = "Credits: "+str(Interface.credits)

func buy():
	if current == "static bomb":
		buyStaticBomb()
	elif current == "sniper":
		buySniperAmmo()
	elif current == "ring":
		buyRing()
	elif current == "shotgun":
		buyShotgunAmmo()
	elif current == "hole":
		buyBlackHole()
	elif current == "big bomb":
		buyBigBomb()
	elif current == "nuke":
		buyNuke()
	elif current == "health":
		buyHealth()
	else:
		print("not working bud")
	updateDetails(current)

func goBack():
	get_parent().get_node("Panel/VBoxContainer/VBoxContainer/Resume").grab_focus()
	queue_free()

func buyStaticBomb():
	if sbcost > Interface.credits:
		return
	#Interface.sbombs += 1
	Interface.weaponHandler.ammo[current] += 1
	Interface.world.changeScore(0, -sbcost)
	updateCreditsLabel()
	Interface.updateHUD()

func buyBigBomb():
	if bbcost > Interface.credits:
		return
	#Interface.bbombs += 1
	Interface.weaponHandler.ammo[current] += 1
	Interface.world.changeScore(0, -bbcost)
	updateCreditsLabel()
	Interface.updateHUD()

func buyHealth():
	if hcost > Interface.credits:
		return
	#Interface.health += 1
	Interface.weaponHandler.ammo[current] += 1
	Interface.world.changeScore(0, -hcost)
	updateCreditsLabel()
	Interface.updateHUD()

func buyShotgunAmmo():
	if shotguncost > Interface.credits:
		return
	#Interface.shotgun += 500
	Interface.weaponHandler.ammo[current] += 500
	Interface.world.changeScore(0, -shotguncost)
	updateCreditsLabel()
	Interface.updateAmmoHUD()

func buyNuke():
	if abcost > Interface.credits:
		return
	#Interface.abombs += 1
	Interface.weaponHandler.ammo[current] += 1
	Interface.world.changeScore(0, -abcost)
	updateCreditsLabel()
	Interface.updateHUD()

func buySniperAmmo():
	if snipercost > Interface.credits:
		return
	#Interface.sniper += 100
	Interface.weaponHandler.ammo[current] += 100
	Interface.world.changeScore(0, -snipercost)
	updateCreditsLabel()
	Interface.updateAmmoHUD()

func buyRing():
	if rcost > Interface.credits:
		return
	#Interface.rings += 1
	Interface.weaponHandler.ammo[current] += 1
	Interface.world.changeScore(0, -rcost)
	updateCreditsLabel()
	Interface.updateHUD()

func buyBlackHole():
	if bhcost > Interface.credits:
		return
	#Interface.holes += 1
	Interface.weaponHandler.ammo[current] += 1
	Interface.world.changeScore(0, -bhcost)
	updateCreditsLabel()
	Interface.updateHUD()

func _on_StaticBomb_focus_entered():
	updateDetails("static bomb")

func _on_Sniper_focus_entered():
	updateDetails("sniper")

func _on_Ring_focus_entered():
	updateDetails("ring")

func _on_Shotgun_focus_entered():
	updateDetails("shotgun")

func _on_BlackHole_focus_entered():
	updateDetails("hole")

func _on_BigBomb_focus_entered():
	updateDetails("big bomb")

func _on_Nuke_focus_entered():
	updateDetails("nuke")

func _on_Health_focus_entered():
	updateDetails("health")