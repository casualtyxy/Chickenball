extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		#config.set_value("Volume", "sound", 0.5)
		#config.set_value("Volume", "music", 0.5)
		#config.set_value("Volume", "ambient", 0.5)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_example_settings(key: String, value):
	config.set_value("example", key, value)
	config.save(SETTINGS_FILE_PATH)
func load_example_settings():
	var example_settings = {}
	for key in config.get_section_keys("example"):
		example_settings[key] = config.get_value("example", key)
	return example_settings

#############

func save_volume_settings():
	#config.set_value("volume", "sound", volume_sound)
	#config.set_value("volume", "music", volume_music)
	pass

#############

func save_keybind(action: StringName, event: InputEvent, player_to_assign: int): #player to assign will be the device id for now
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
	elif event is InputEventJoypadButton:
		event_str = "joypadb_" + str(event.button_index)
	elif event is InputEventJoypadMotion:
		event_str = "joypadm_" + str(event.axis)
	
	config.set_value("keybinding", action, event_str)
	config.save(SETTINGS_FILE_PATH)
	print("Device ID is " + str(event.device))

func load_keybind_list(): #returns an array of keybinds
	var keybinds = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event:InputEvent
		var event_str = config.get_value("keybinding", key)
		
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
			print("loading mouse_" + str(input_event))
		elif event_str.contains("joypadb_"):
			input_event = InputEventJoypadButton.new()
			input_event.button_index = int(event_str.split("_")[1])
			print("loading joypad button " + str(input_event))
		elif event_str.contains("joypadm_"):
			input_event = InputEventJoypadMotion.new()
			input_event.axis = float(event_str.split("_")[1])
			print("loading joypad motion " + str(input_event))
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybinds[key] = input_event
	print("")
	return keybinds

func reload_keybinds():
	var keybinds = load_keybind_list()
	for action in keybinds.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybinds[action])
