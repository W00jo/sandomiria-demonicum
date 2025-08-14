extends CanvasLayer


var ammo = 0
var current_weapon = "knife"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		if current_weapon == "knife":
			$AnimatedSprite2D.play("knife_stab")
		elif current_weapon == "crossbow":
			if ammo > 0:
				$AnimatedSprite2D.play("crossbow_shoot")
				ammo -= 1

func _on_AnimatedSprite2D_animation_finished():
	if current_weapon == "knife":
		$AnimatedSprite2D.play("knife_idle")
	elif current_weapon == "crossbow":
		$AnimatedSprite2D.play("crossbow_idle")
