extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	one_shot = true
	emitting = true
	finished.connect(_on_finish)

func _on_finish():
	await get_tree().create_timer(3).timeout
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
