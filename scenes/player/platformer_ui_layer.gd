extends CanvasLayer

@onready var _1: Control = $"Control/MarginContainer/HBoxContainer/1"
@onready var _2: Control = $"Control/MarginContainer/HBoxContainer/2"
@onready var _3: Control = $"Control/MarginContainer/HBoxContainer/3"
@onready var _4: Control = $"Control/MarginContainer/HBoxContainer/4"

@onready var _1_indicator: Sprite2D = $"Control/MarginContainer/HBoxContainer/1/Node2D/Indicator"
@onready var _2_indicator: Sprite2D = $"Control/MarginContainer/HBoxContainer/2/Node2D/Indicator"
@onready var _3_indicator: Sprite2D = $"Control/MarginContainer/HBoxContainer/3/Node2D/Indicator"
@onready var _4_indicator: Sprite2D = $"Control/MarginContainer/HBoxContainer/4/Node2D/Indicator"

@onready var _1_ico: Sprite2D = $"Control/MarginContainer/HBoxContainer/1/Node2D/Ico"
@onready var _2_ico: Sprite2D = $"Control/MarginContainer/HBoxContainer/2/Node2D/Ico"
@onready var _3_ico: Sprite2D = $"Control/MarginContainer/HBoxContainer/3/Node2D/Ico"
@onready var _4_ico: Sprite2D = $"Control/MarginContainer/HBoxContainer/4/Node2D/Ico"

var players:Array[Node2D] = []

func _remove_extra_modules():
	print("Testing...")
	for i in $Control/MarginContainer/HBoxContainer.get_child_count():
		var tempname = str(i + 1)
		#var temp = get_parent().find_child(tempname)
		if i > GlobalVar.player_count - 1:
			$Control/MarginContainer/HBoxContainer.find_child(tempname).queue_free()
			print("Disabled a Module")
		else:
			print("Kept a Module")

func _player_ref_setup():
	players.clear()
	for i in GlobalVar.player_count:
		var tempname = "Player" + str(i + 1)
		players.append(get_parent().find_child(tempname, true))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_remove_extra_modules()
	_player_ref_setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_p2():
	pass
