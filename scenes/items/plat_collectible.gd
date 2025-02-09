extends Area2D

#@export var item_texture:Texture2D = preload("res://art/items/farm/apple.png")
#@export var touch_range:Shape2D

func _ready() -> void:
	$Crumbs.emitting = false
	#$Texture.texture = item_texture
	$Crumbs.texture = $Texture.texture
	#if touch_range != null:
		#$Shape.shape = touch_range
	#body_entered.connect(_on_touch)
	$Timer.start(randf_range(0.0, 0.1))
	await $Timer.timeout
	$AnimationPlayer.play("default")

func disable_shape():
	$Shape.disabled = true

func consume(): #prev _on_touch
	GlobalVar.foods_collected += 1
	call_deferred("disable_shape")
	$SFX.play()
	$AnimationPlayer.play("collected")
	await $AnimationPlayer.animation_finished
	queue_free()
