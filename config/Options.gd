extends Node

#may merge into confighandler

const CONFIG_FILENAME:String = "config.cfg"

var display_onscreen_controls = false
var volume_sound = 1
var volume_music = 1
var volume_ambient = 1

func loadData():
	var optionsFile = ConfigFile.new()
	
	var status = optionsFile.load("user://%s" % CONFIG_FILENAME)
	
	if status == OK:
		
		display_onscreen_controls = optionsFile.get_value("Preferences", "mobileControls")
		volume_sound = optionsFile.get_value("Volume", "sound")
		volume_music = optionsFile.get_value("Volume", "music")
		volume_ambient = optionsFile.get_value("Volume", "ambient")
	
	print_debug("Attempted to load data")
	print("loaded: volume " + str(volume_sound))
	print("loaded: volume " + str(volume_music))
	print("loaded: volume " + str(volume_ambient))

func saveData():
	var optionsFile = ConfigFile.new()
	
	optionsFile.set_value("Preferences", "mobileControls", display_onscreen_controls)
	optionsFile.set_value("Volume", "sound", volume_sound)
	optionsFile.set_value("Volume", "music", volume_music)
	optionsFile.set_value("Volume", "ambient", volume_ambient)
	
	optionsFile.save("user://%s" % CONFIG_FILENAME)

func _ready() -> void:
	loadData()
