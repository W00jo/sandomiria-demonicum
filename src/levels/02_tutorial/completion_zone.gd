extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		get_tree().change_scene_to_file("res://src/levels/01_tutorial/tutorial.tscn")
