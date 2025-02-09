extends Area2D

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_enter)
	GlobalVar.arcade_door_open.connect(_on_level_finish)
	$Effects.hide()

func _on_enter(area: Area2D):
	if area.get_parent().is_in_group("Player"):
		if is_open:
			print("may pass")
			randomize()
			GlobalVar.light_reset_arcade()
			Screendrip.transition()
			await Screendrip.on_transition_finished
			GlobalVar.level_queued = GlobalVar.arcade_levels.pick_random()
			get_tree().change_scene_to_file("res://scenes/main.tscn")
			GlobalMusic.play_random()
			GlobalVar.bonus_active = false
		else:
			print("locked")

func _on_level_finish():
	$Sprite2D.texture = load("res://art/sprites/door_open.png")
	is_open = true
	$Effects.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
