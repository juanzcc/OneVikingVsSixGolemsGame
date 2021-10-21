extends Sprite

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene("res://src/WinScene.tscn")
