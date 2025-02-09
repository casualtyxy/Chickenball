extends Node2D

signal item_collected

@export_group("Item Components")
@export var calories:int = 1

var can_collect = true

func _ready() -> void:
	$Crumbs.emitting = false
	#$Texture.texture = item_texture
	$Crumbs.texture = $"../Texture".texture
	#if touch_range != null:
		#$Shape.shape = touch_range
	#body_entered.connect(_on_touch)
	$Timer.start(randf_range(0.0, 0.1))
	await $Timer.timeout
	$AnimationPlayer.play("default")
	$AnimationPlayer.animation_finished.connect(remove)

func consume(): #prev _on_touch
	if can_collect:
		can_collect = false
		GlobalVar.foods_collected += 1
		$SFX.play()
		$AnimationPlayer.call_deferred("play", "collected")

func remove(anim_name: StringName):
	if anim_name == "collected":
		get_parent().queue_free()

#brute force anim
func _process(delta: float) -> void:
	if not can_collect and $AnimationPlayer.assigned_animation != "collected":
		$AnimationPlayer.play("collected")
		item_collected.emit()
