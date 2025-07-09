extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Keyclose.pressed.connect(_keybind_menu)
	$Reset.pressed.connect(_reset) # Replace with function body.


func _reset():
	InputMap.load_from_project_settings()
	GlobalVar.settings_controls_reset.emit()
