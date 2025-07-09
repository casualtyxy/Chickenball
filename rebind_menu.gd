extends Node2D

var input_actions = {
	"down": "",
	"left": "",
	"right": "",
	"jump": "",
	"click_right": "",
	"p2down": "",
	"p2left": "",
	"p2right": "",
	"p2jump": "",
	"p2flap": "",
	"p3down": "",
	"p3left": "",
	"p3right": "",
	"p3jump": "",
	"p3flap": "",
	"p4down": "",
	"p4left": "",
	"p4right": "",
	"p4jump": "",
	"p4flap": "",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func create_action_list():
	#restores rebinded keys to default
	InputMap.load_from_project_settings()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
