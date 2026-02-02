extends Control

@onready var play_button = $BookContainer/LeftSide/MenuContainer/ContentVBox/MenuButtons/PlayButton
@onready var settings_button = $BookContainer/LeftSide/MenuContainer/ContentVBox/MenuButtons/SettingsButton
@onready var credits_button = $BookContainer/LeftSide/MenuContainer/ContentVBox/MenuButtons/CreditsButton
@onready var quit_button = $BookContainer/LeftSide/MenuContainer/ContentVBox/MenuButtons/QuitButton

func _ready():
	pass

func _on_play_button_pressed() -> void:
	print("Play")
	get_tree().change_scene_to_file("res://src/levels/tutorial.tscn")

func _on_settings_button_pressed() -> void:
	print("Settings")
	# TODO: settings

func _on_credits_button_pressed() -> void:
	print("Credits")
	# TODO: credits

func _on_quit_button_pressed() -> void:
	print("Quit")
	get_tree().quit()
