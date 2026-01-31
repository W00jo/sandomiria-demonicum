extends CharacterBody3D

## Zdrowie roadblocka
@export var max_health: float = 2.0
var current_health: float = 2.0

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float):
	current_health -= amount
	print("Roadblock otrzymał ", amount, " dmg. Pozostało ", current_health, " HP")
	
	if current_health <= 0:
		_die()

func _die():
	print("Roadblock zniszczony!")
	queue_free()  # Usuń roadblock ze sceny
