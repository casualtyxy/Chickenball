extends Button

@export var action: String
@export_enum("Player 1", "Player 2", "Player 3", "Player 4") var player_index: int = 0
var is_remapping = false
var action_to_assign
var remapping_button #???
var button = self #prolly dont need

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_remap_button_pressed.bind(button, action))
	update_label()
	GlobalVar.settings_controls_reset.connect(_on_control_reset)

func _on_control_reset(): #idk the video said to do this
	var events = InputMap.action_get_events(action)
	if events.size() > 0:
		ConfigHandler.save_keybind(action, events[0], player_index)
	
	update_label()

func update_label():
	var events = InputMap.action_get_events(action)
	if events.size() > 0:
		text = events[0].as_text().trim_suffix(" (Physical)")
	else :
		text = "None"

func _on_remap_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_assign = action
		remapping_button = button
		text = "..."
		#waiting for input

func _input(event): #overriding an existing function, like _ready and _process
	if is_remapping:
		if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventJoypadMotion:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action_to_assign, event)
			ConfigHandler.save_keybind(action_to_assign, event, player_index)
			print("config saved")
			update_label()
			is_remapping = false
			action_to_assign = null
			remapping_button = null
			
			accept_event()
