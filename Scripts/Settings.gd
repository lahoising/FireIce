extends Control

var dict =  {"Mouse": Interface.Controllers.MOUSE, "Keyboard": Interface.Controllers.KEYBOARD, "Gamepad": Interface.Controllers.GAMEPAD}

func _ready():
	prepare_dropdown()
	$PanelContainer/VBoxContainer/Controller.selected = Interface.controller
	$PanelContainer/VBoxContainer/Controller.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		back()

func prepare_dropdown():
	for option in Interface.Controllers.keys():
		$PanelContainer/VBoxContainer/Controller.add_item(option)

func _on_Controller_item_selected(ID):
	Interface.controller = ID
	print(Interface.controller)

func _on_Button_pressed():
	back()

func back():
	if get_parent().name == "MainMenu":
		get_parent().get_node("VBoxContainer/HBoxContainer/Play").grab_focus()
	elif get_parent().name == "PauseMenu":
		get_parent().get_node("Panel/VBoxContainer/VBoxContainer/Settings").grab_focus()
	queue_free()
