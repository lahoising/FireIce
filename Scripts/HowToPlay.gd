extends PanelContainer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		back()
	if event.is_action_pressed("cross_down") or event.is_action_pressed("ui_down"):
		var scroll = $VBoxContainer/RichTextLabel.get_v_scroll()
		scroll.value += 10

func _on_Back_pressed():
	back()

func back():
	if get_parent().name == "MainMenu":
		get_parent().get_node("VBoxContainer/HBoxContainer/Play").grab_focus()
	elif get_parent().name == "PauseMenu":
		get_parent().get_node("Panel/VBoxContainer/VBoxContainer/Instructions").grab_focus()
	queue_free()