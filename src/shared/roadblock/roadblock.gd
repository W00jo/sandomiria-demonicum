extends CharacterBody3D
## Niszczalna przeszkoda blokująca drogę gracza.
##
## Prosty obiekt z HP, który gracz musi zniszczyć żeby przejść dalej.[br]
## Używany w tutorialu do nauki walki i jako element level designu.[br]
## [br]
## Implementuje interfejs [code]take_damage()[/code] - taki sam jak wrogowie.
##
## @experimental

## Maksymalne zdrowie roadblocka (ustawiane w inspektorze).
@export var max_health: float = 2.0

## Aktualne zdrowie - resetowane do [member max_health] w [method _ready].
var current_health: float = 2.0


func _ready() -> void:
	current_health = max_health


## Zadaje obrażenia roadblockowi.[br]
## [br]
## Wywoływane przez system walki gracza (np. [method Dagger.deal_damage_in_area]).[br]
## Gdy HP spadnie do 0, wywołuje [method _die].[br]
## [br]
## @param amount Ilość obrażeń do zadania.
func take_damage(amount: float) -> void:
	current_health -= amount
	print("Roadblock otrzymał ", amount, " dmg. Pozostało ", current_health, " HP")
	
	if current_health <= 0:
		_die()


## Usuwa roadblock ze sceny.[br]
## Wywoływane gdy [member current_health] <= 0.
func _die() -> void:
	print("Roadblock zniszczony!")
	queue_free()
