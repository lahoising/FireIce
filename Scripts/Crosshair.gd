extends Control

var motion = Vector2()
var spd = 500

const BASIC = preload("res://Sprites/Assets/Crosshair.png")
const SHOTGUN = preload("res://Sprites/Assets/ShotgunCrosshair.png")
const SNIPER = preload("res://Sprites/Assets/SniperCrosshair.png")

func _ready():
	Interface.crosshair = self
	call_deferred("setColor")
	call_deferred("setCrosshair")

func _process(delta):
	match(Interface.controller):
		Interface.Controllers.MOUSE:
			rect_global_position = get_global_mouse_position()
		Interface.Controllers.KEYBOARD:
			rect_global_position += motion*spd*delta
		Interface.Controllers.GAMEPAD:
			rect_global_position = Interface.player.global_position + motion*100

func _input(event):
	if Interface.controller == Interface.Controllers.KEYBOARD:
		motion.x = int(Input.is_action_pressed("cross_right")) - int(Input.is_action_pressed("cross_left"))
		motion.y = int(Input.is_action_pressed("cross_down")) - int(Input.is_action_pressed("cross_up"))
	elif Interface.controller == Interface.Controllers.GAMEPAD:
		motion.x = Input.get_joy_axis(0, JOY_AXIS_3)
		motion.y = Input.get_joy_axis(0, JOY_AXIS_4)
	#print(event.as_text())

func setColor(type):
	if type == 0:
		modulate = Color("ffa838")
	else:
		modulate = Color("437afe")

func setCrosshair():
	match(Interface.atk):
		Interface.Attacks.BASIC:
			$TextureRect.texture = BASIC
		Interface.Attacks.SHOTGUN:
			$TextureRect.texture = SHOTGUN
		Interface.Attacks.SNIPER:
			$TextureRect.texture = SNIPER