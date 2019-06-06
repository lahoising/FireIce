extends Control

const WORLD = "res://World.tscn"
const HOWTO = preload("res://HowToPlay.tscn")
const SETTINGS = preload("res://Settings.tscn")

func _ready():
	$VBoxContainer/HBoxContainer/Play.grab_focus()

func _process(delta):
	$TextureRect.rect_rotation += PI/32

func _on_Play_pressed():
	get_tree().change_scene(WORLD)

func _on_Quit_pressed():
	get_tree().quit()

func _on_Howto_pressed():
	add_child(HOWTO.instance())

func _on_Settings_pressed():
	add_child(SETTINGS.instance())