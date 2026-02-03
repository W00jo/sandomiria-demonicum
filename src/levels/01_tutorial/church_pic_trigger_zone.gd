extends Area3D

@export var saint_jakub_path: NodePath = "../../SaintJakub"

@onready var saint_jakub: Sprite3D = get_node_or_null(saint_jakub_path)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if saint_jakub:
			saint_jakub.visible = false
