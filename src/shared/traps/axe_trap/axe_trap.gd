extends Node3D


@onready var anim_player = $AxeSwing

func _ready():
	var anim_lenght = anim_player.get_animation("swing").length
	
	var random_start = randf_range(0.0, anim_lenght)
	
	anim_player.advance(random_start)
	
	anim_player.speed_scale = randf_range(0.8, 1.2)


func _on_blade_area_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(25)
