extends Control

func _ready():
	get_tree().paused = true
	$Label/AnimationPlayer.play("Grow")
	$Timer.start()

func _on_Timer_timeout():
	if $Label.text == "3":
		$Label.text = "2"
	elif $Label.text == "2":
		$Label.text = "1"
	elif $Label.text == "1":
		get_tree().paused = false
		queue_free()