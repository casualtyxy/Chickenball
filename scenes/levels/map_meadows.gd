extends Node2D

var min_playable_x = 0
var max_playable_x = 0
var min_playable_y = 0
var max_playable_y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalMusic.play_music(GlobalMusic.orange_plain_meadows)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
