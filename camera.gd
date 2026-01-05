extends Camera2D


func _input(ev):
	if Input.is_action_pressed("zoom_in"):
		zoom += Vector2(0.2, 0.2)
	elif Input.is_action_pressed("zoom_out"):
		zoom -= Vector2(0.2, 0.2)
