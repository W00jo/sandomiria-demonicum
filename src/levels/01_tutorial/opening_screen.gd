extends CanvasLayer

@onready var background: ColorRect = $Background
@onready var dialogue_label: RichTextLabel = $Background/DialogueLabel
@onready var continue_hint: Label = $Background/ContinueHint

var is_active: bool = true

func _ready() -> void:
	# Ensure the opening screen starts visible
	visible = true
	is_active = true
	
	# Pause the game during opening
	get_tree().paused = true
	
	# Set up continue hint
	continue_hint.text = "Press SPACE or ENTER to continue..."
	
	# Optionally add a fade-in animation
	background.modulate.a = 0
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(background, "modulate:a", 1.0, 0.5)

func _input(event: InputEvent) -> void:
	if not is_active:
		return
	
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		close_opening_screen()


func close_opening_screen() -> void:
	if not is_active:
		return
	
	is_active = false
	
	# Fade out animation
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(background, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func():
		get_tree().paused = false
		queue_free()
	)
