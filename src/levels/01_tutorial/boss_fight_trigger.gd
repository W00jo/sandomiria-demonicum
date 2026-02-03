extends Area3D

@export var boss_gate_path: NodePath = "../BossGate"

@onready var boss_gate: CSGBox3D = get_node_or_null(boss_gate_path)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if boss_gate:
			boss_gate.queue_free()
