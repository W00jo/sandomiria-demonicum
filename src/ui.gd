extends CanvasLayer




# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)


# Uderzanie nozem lub strzelanie z kuszy, po kazdym strzale zabiera amunicje
func _process(delta):
	if Input.is_action_just_pressed("ui_attack"):
		if GameManager.current_weapon == "knife":
			$AnimatedSprite2D.play("knife_stab")
		elif GameManager.current_weapon == "crossbow":
			if GameManager.ammo > 0:
				$AnimatedSprite2D.play("crossbow_shoot")
				GameManager.ammo -= 1
			else:
				GameManager.current_weapon = "knife"
				$AnimatedSprite2D.play("knife_idle")


func _on_AnimatedSprite2D_animation_finished():
	if GameManager.current_weapon == "knife":
		$AnimatedSprite2D.play("knife_idle")
	elif GameManager.current_weapon == "crossbow":
		$AnimatedSprite2D.play("crossbow_idle")
