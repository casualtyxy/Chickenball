extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProtoVend.hide()
	$ActivateArea.area_entered.connect(_show_menu)
	$ActivateArea.area_exited.connect(_hide_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _show_menu(area: Area2D):
	if area.is_in_group("Player"):
		$ProtoVend.show()

func _hide_menu(area: Area2D):
	if area.is_in_group("Player"):
		$ProtoVend.hide()
