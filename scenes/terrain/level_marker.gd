extends Node2D

@export var level_id:int
@export var level_scene:PackedScene
@export var unlock_level_on_complete:int
@export var unlock_secondary:int #no plans yet, but in case completion unlocks an additional level (less linear progression)
@export var unlock_special:int #no plans yet, but same as secret exits from mario

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVar.level_completed.connect(_on_level_complete)

func _on_level_complete(level: int):
	if level == level_id:
		print_debug("That's me!")
	else:
		print_debug("Received " + str(level) + ", nothing happens")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space") and $Area2D.has_overlapping_bodies():
		var bodies = $Area2D.get_overlapping_bodies()
		for i in bodies:
			if i.is_in_group("Player"):
				Screendrip.transition(3)
				await Screendrip.on_transition_finished
				get_tree().change_scene_to_packed(level_scene)
				GlobalVar.currentLevel = level_id
