extends Node2D


func _ready():
	$AnimationPlayer.play("drop3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $AnimationPlayer.current_animation_position >= 0.55:
		queue_free()
