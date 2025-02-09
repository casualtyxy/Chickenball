extends CanvasLayer

signal on_transition_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum transType {RANDOM, DRIP, BLOCKS, SPOTLIGHT}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	match anim_name:
		"start":
			animation_player.play("end")
			on_transition_finished.emit()
		"start_blocks":
			animation_player.play("end_blocks")
			on_transition_finished.emit()
		"start_spotlight":
			animation_player.play("end_spotlight")
			on_transition_finished.emit()


func transition(type = 0):
	$AnimationPlayer.play("RESET")
	if type == 0:
		type = randi_range(1,3)
	match type:
		1:
			animation_player.play("start")
		2:
			animation_player.play("start_blocks")
		3:
			animation_player.play("start_spotlight")
