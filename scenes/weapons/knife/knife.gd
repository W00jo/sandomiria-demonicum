extends Node3D
## Służy, póki co, do zarządzania animacją ataku.
##
## W przyszłości (w nadchodzącym tygodniu 3-9 listopada 2025 rozpoczniemy pracę nad także faktyczną funkcją walki.
##
## @tutorial: www.youtube.com/watch?v=5vIA7UGS8Uc&list=PLpyRatNKRJaq2QMMGk8dGGLyksQxJtX7i&index=6

## Przypisanie do zmiennej Node'a, który odpowiada za animację ataku.
@onready var animation: AnimationPlayer = $Animation

func _ready() -> void:
	animation.play("Idle")

func _input(event) -> void:
	if event is InputEventMouseButton:
		$Audio.play()
		animation.play("Stab", -1, 1.5)
