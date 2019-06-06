extends Sprite

func _ready():
	randomize()
	if randi()%2 == 0:
		flip_h = true
	get_node("AnimationPlayer").play("Start")
