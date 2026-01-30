extends Node3D

@onready var light = $OmniLight3D
@export var base_energy: float = 5.0
@export var flicker_intensity: float = 1.5
@export var flicker_speed: float = 8.0
var noise = FastNoiseLite.new() # Generator szumu
var time_passed = 0.0

func _ready():
	randomize() 
	noise.seed = randi()
	noise.frequency = 0.05
	
func _process(delta):
	time_passed += delta
	var noise_value = noise.get_noise_1d(time_passed * flicker_speed)
	var new_energy = base_energy + (noise_value * flicker_intensity)
	light.light_energy = max(0.1, new_energy)
