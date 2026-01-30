extends StaticBody3D

@export var arrow_scene: PackedScene

@onready var spawn_point = $Barell
@onready var sfx_shoot = $ShootSound



func _on_timer_timeout() -> void:
	var new_arrow = arrow_scene.instantiate()
	get_tree().current_scene.add_child(new_arrow)
	new_arrow.global_transform = spawn_point.global_transform
	
	
	sfx_shoot.play()
