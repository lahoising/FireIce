extends Control

const MAINMENU = "res://MainMenu.tscn"
const SHOP = preload("res://Shop.tscn")
const HOWTO = preload("res://HowToPlay.tscn")
const SETTINGS = preload("res://Settings.tscn")
const MISSIONS = preload("res://Missions.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	get_node("Panel/VBoxContainer/VBoxContainer/Resume").grab_focus()

func resume():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_parent().queue_free()

func quit():
	get_tree().paused = false
	get_tree().change_scene(MAINMENU)

func _on_Resume_pressed():
	resume()

func _on_Quit_pressed():
	quit()

func _on_Shop_pressed():
	var shop = SHOP.instance()
	add_child(shop)


func _on_Instructions_pressed():
	add_child(HOWTO.instance())


func _on_Settings_pressed():
	add_child(SETTINGS.instance())

func _on_Missions_pressed():
	add_child(MISSIONS.instance())