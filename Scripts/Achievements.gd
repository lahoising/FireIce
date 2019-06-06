extends Control

func _ready():
	var h = Interface.weaponHandler
	var elims = h.elims_counter
	var targets = h.upgrades
	var levels = h.levels
	var temp = 0
	for w in targets:
		var weapon = clean_name(w)
		
		if w in elims:
			if temp > levels[w]:
				set_progress(weapon, 0, 1)
			else:
				set_progress(weapon, elims[w], targets[w][levels[w] - 1])
				temp = levels[w]
		else:
			set_progress(weapon, -1, -1)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_parent().get_node("Panel/VBoxContainer/VBoxContainer/Resume").grab_focus()
		queue_free()

func set_progress(weapon, val, max_val):
	var label = get_node("MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/"+weapon+"/Progress/Label")
	var bar = get_node("MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/"+weapon+"/Progress/ProgressBar")
	if val < 0:
		label.text = "locked"
		bar.value = 0
		bar.max_value = 1
		return
	label.text = str(val) + "/" + str(max_val)
	bar.max_value = max_val
	if val > max_val:
		val = max_val
	bar.value = val

func clean_name(weapon):
	var s = weapon.capitalize().split(" ")
	var final_name = ""
	if s.size() > 1:
		for word in s:
			final_name += word
	else:
		final_name = s[0]
	return final_name