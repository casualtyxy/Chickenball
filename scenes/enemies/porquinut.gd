extends Area2D

@onready var path_follow: PathFollow2D = $".."
var speed = 24

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow.progress += delta * speed
	#global_position = path_follow.position
	if path_follow.progress_ratio < 0.5:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
