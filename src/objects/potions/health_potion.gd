extends Area3D

@export var healing_amount: int = 20



func _on_body_entered(body: Node3D) -> void:
	print("Ałała, zaraz sie zbije")	
	
	if body.has_method("_got_healed"):
		body._got_healed(healing_amount)
		$GulpSfx.play()
		await $GulpSfx.finished
		queue_free()
