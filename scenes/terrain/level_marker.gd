extends Node2D

@export_enum("locked", "unlocked", "completed") var level_state: int
@export var level_id:int
@export var level_scene:PackedScene
@export var unlock_level_on_complete:int
@export var unlock_secondary:int #no plans yet, but in case completion unlocks an additional level (less linear progression)
@export var unlock_special:int #no plans yet, but same as secret exits from mario

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVar.level_completed.connect(_on_level_complete)
	GlobalVar.unlock_level.connect(_unlock_this_level)
	if level_state == 1: #unlocked
		$LevelPlaceholder.frame = 1 #this prolly isnt gonna save once the scene unloads anyway

func _on_level_complete(level: int, completed: bool):
	if level == level_id and completed:
		print_debug("That's me!")
		$AnimationPlayer.play("complete")
		await get_tree().create_timer(2).timeout
		unlock_next()
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

func unlock_next():
	GlobalVar.unlock_level.emit(unlock_level_on_complete)

func _unlock_this_level(id: int):
	if id == level_id:
		level_state = 1 #unlock
		$AnimationPlayer.play("unlock")
