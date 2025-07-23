extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVar.toggled_pause.connect(_when_pausing_game)

func _when_pausing_game(is_paused: bool):
	if is_paused:
		get_parent().process_mode = PROCESS_MODE_DISABLED
	else:
		get_parent().process_mode = PROCESS_MODE_INHERIT

# Ensures durians and other stuff that spawn after a pause wont continue to process (how is that even happening)
func _process(delta: float) -> void:
	if GlobalVar.paused:
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED
