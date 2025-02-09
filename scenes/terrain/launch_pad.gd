extends StaticBody2D

@export_range(1,30) var launch_force:int = 1

func _ready() -> void:
	$DetectionArea.body_entered.connect(launch)

func launch(body: Node2D):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("Spring")
		$Timer.start(0.2)
		body.velocity = Vector2(0,100)
		await $Timer.timeout
		if Input.is_action_pressed("space"):
			body.velocity.y += body.jump_vel
		body.velocity.y -= launch_force * 100
		$Timer.start(0.05)
		await $Timer.timeout
		body.can_jump = false
