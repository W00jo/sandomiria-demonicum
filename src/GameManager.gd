extends Node

var score: int = 0
var player_health: int = 100
var ammo = 2
var current_weapon = "crossbow"


func _ready() -> void:
	print("GameManager ready.")

func reset_game() -> void:
	score = 0
	player_health = 100
