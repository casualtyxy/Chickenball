extends RigidBody2D

func _ready() -> void:
	$Sweat.one_shot = true
	$Sweat.emitting = true
	$Sweat/Timer.timeout.connect(_on_finish)
	$Sweat/Timer.start(2.0)
	
	linear_velocity = get_parent().find_child("Player1").velocity * 1.5

func _on_finish():
	queue_free()
