extends Node3D

@onready var animation: AnimationPlayer = $Animation

func _ready() -> void:
	animation.play("Idle")
	pass

func _input(event) -> void:
	if event is InputEventMouseButton:
		$Audio.play()
		animation.play("Stab", -1, 1.5)
