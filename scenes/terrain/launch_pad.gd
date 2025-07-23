extends StaticBody2D

@export_range(1,30) var launch_force:int = 8

func _ready() -> void:
	$DetectionArea.body_entered.connect(launch)

func launch(body: Node2D):
	if body.is_in_group("Player") or 1 == 1:
		$AnimationPlayer.play("Spring")
		body.velocity = Vector2(0,100)
		await get_tree().create_timer(0.2).timeout
		if Input.is_action_pressed("space"):
			body.velocity.y += body.jump_vel
		body.velocity.y = launch_force * -100
		await get_tree().create_timer(0.5).timeout
		body.can_jump = false
