extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if "is_on_ladder" in body:
		body.is_on_ladder = true
	print("jestem na drabinie")


func _on_body_exited(body: Node3D) -> void:
	if "is_on_ladder" in body:
		body.is_on_ladder = false
	print("spadłem z drabiny")
