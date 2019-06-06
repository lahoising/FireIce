extends Particles2D

var direction
export(int) var SPD = 400

func _process(delta):
	position += direction*SPD*delta

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
