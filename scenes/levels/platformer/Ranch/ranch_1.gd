extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GlobalMusic.play_music(GlobalMusic.berry_farm_level_1)
	GlobalVar.foods_collected = 0
	#$CamPanOut.body_entered.connect(_cam_pan_out)
	#$CamPanOut.body_exited.connect(_cam_pan_in)
	print_debug("Level loaded")
	
	#$Temp.body_entered.connect(temp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _cam_pan_out(body: Node2D):
	if body.is_in_group("Player"):
		GlobalVar.camera_mode_changed.emit(1)
		$SidescrollCamera.global_position = $CamPanOut/Shape.global_position
func _cam_pan_in(body: Node2D):
	if body.is_in_group("Player"):
		GlobalVar.camera_mode_changed.emit(0)
		$SidescrollCamera/AnimationPlayer.play("zoom_in")

func temp(body: Node2D):
	if body is CharacterBody2D:
		GlobalVar.finishLevel(true)
