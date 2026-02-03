extends Area3D

@export var reset_position: Vector3 = Vector3(0, 1, 0)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.global_position = reset_position
		body.velocity = Vector3.ZERO
