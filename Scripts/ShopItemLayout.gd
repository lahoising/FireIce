extends PanelContainer

var style = StyleBoxFlat.new()
#var changed = false
#var temp = 0

func _ready():
	style.border_color = Color(0,0,0,255)
	style.set_border_width_all(1)
	style.set_corner_radius_individual(0,50,50,0)
	style.bg_color = Color(0,0,0,0)

func _process(delta):
	return
	if get_children()[0].get_children()[0].has_focus():
		add_stylebox_override("panel", style)
		#temp = 0
	else:
		if theme.has_stylebox("panel", "PanelContainer"):
			add_stylebox_override("panel", theme.get_stylebox("panel", "PanelContainer"))
		#temp = 1 
