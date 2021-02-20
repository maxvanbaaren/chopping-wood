extends KinematicBody2D

var hits_left = 3

func _on_Area2D_area_entered(_area):
	hits_left -= 1
	get_node("AudioStreamPlayer2D").play()
	if hits_left == 0:
		var timer = get_node("Timer")
		timer.wait_time = 0.5
		timer.start()

func _on_Timer_timeout():
	queue_free()
