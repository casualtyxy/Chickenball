extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(_on_finish)
	one_shot = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_finish():
	queue_free()
