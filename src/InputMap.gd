extends Node

func _ready() -> void:
    _setup_inputs()

func _setup_inputs() -> void:
    var inputs = {
        "move_left": [KEY_A, KEY_LEFT],
        "move_right": [KEY_D, KEY_RIGHT],
        "attack": [KEY_LMB]
    }
    for action in inputs.keys():
        if not InputMap.has_action(action):
            InputMap.add_action(action)
        for key in inputs[action]:
            InputMap.action_add_event(action, InputEventKey.new_from_scancode(key))