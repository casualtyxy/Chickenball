extends Node2D

#var sprite1 = preload("res://art/menus/splash2.png")
var sprite2 = preload("res://art/menus/cbicon2_upscale.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rand = randi_range(1,4)
	if rand == 3:
		$Sprite2D.texture = sprite2
	$AnimationPlayer.play("game_intro")
	$AnimationPlayer.animation_finished.connect(when_anim_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func when_anim_finished(anim_name):
	if anim_name == "game_intro":
		queue_free()
