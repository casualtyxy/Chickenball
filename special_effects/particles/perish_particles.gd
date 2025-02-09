extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	one_shot = true
	emitting = true
	$Timer.timeout.connect(_on_finish)
	$Timer.start(2.0)

func _on_finish():
	queue_free()
