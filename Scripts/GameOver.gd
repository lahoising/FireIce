extends Control

onready var label = $Label
const END = "res://MainMenu.tscn"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	label.get_node("AnimationPlayer").play("Fade In")
	Interface.restartAll()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().change_scene(END)
		queue_free()