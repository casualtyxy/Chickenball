extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$P2Info.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.text = str(GlobalVar.foods_collected)

func show_p2():
	$P2Info.show()
