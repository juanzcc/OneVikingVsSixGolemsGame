extends Button

func _on_RestartGame_pressed() -> void:
	get_tree().change_scene("res://src/Menu.tscn")
