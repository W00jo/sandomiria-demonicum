extends StaticBody3D

@export var arrow_scene: PackedScene

@onready var spawn_point = $Barell




func _on_timer_timeout() -> void:
	var new_arrow = arrow_scene.instantiate()
	add_child(new_arrow)
	new_arrow.global_transform = spawn_point.global_transform
