extends Area3D

@export var speed = 10

func _physics_process(delta: float) -> void:
	global_position -= (transform.basis.z * speed * delta)


func ready():
	print("urodziłam sie")

func _on_body_entered(body: Node3D) -> void:
	print("Strzała dotknęła: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage(20)
		print("trafiony zatopiony")
	queue_free()	
