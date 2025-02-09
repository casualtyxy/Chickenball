extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Options.loadData()
	if Options.display_onscreen_controls:
		show()
	else:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
