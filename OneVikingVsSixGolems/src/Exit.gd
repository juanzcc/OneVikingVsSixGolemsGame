extends Button

func _on_Start_mouse_entered() -> void:
	modulate.r = 0.7
	modulate.g = 0.7
	modulate.b = 0.7

func _on_Start_mouse_exited() -> void:
	modulate.r = 1
	modulate.g = 1
	modulate.b = 1

func _on_Start_pressed() -> void:
	modulate.r = 0.5
	modulate.g = 0.5
	modulate.b = 0.5
	get_tree().quit()
