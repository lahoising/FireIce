var wname = ""
var lvl = 0
var type = ""
var elims = 0
var ammo = 0
var dmg = 0
var description = ""

func _init(wname, type, dmg):
	self.wname = wname
	self.type = type
	self.dmg = dmg

func levelUp():
	lvl += 1
	elims = 0

func used():
	ammo -= 1

func replenish(num):
	ammo += num

func ko():
	elims += 1