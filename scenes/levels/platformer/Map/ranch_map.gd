extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(_on_press_1)
	$Button2.pressed.connect(_on_press_2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_press_1():
	get_tree().change_scene_to_file("res://scenes/levels/platformer/Ranch/ranch_1.tscn")
func _on_press_2():
	get_tree().change_scene_to_file("res://scenes/levels/platformer/Ranch/ranch_2.tscn")
