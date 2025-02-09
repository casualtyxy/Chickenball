extends HSlider

@export 
var bus_name: String

var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	#value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	match bus_name:
		"Sounds":
			value = Options.volume_sound
		"Music":
			value = Options.volume_music
			print("changed music vol to " + str(value) + " on load")
		"Ambience":
			value = Options.volume_ambient
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	print("value is " + str(value) + " after db convert")

func _on_value_changed(value: float):
	match bus_name:
		"Sounds":
			Options.volume_sound = value
			AudioServer.set_bus_volume_db(bus_index, Options.volume_sound)
			#print("Attempted assigned volume for sound. index " + str(bus_index) + ", bus name " + str(bus_name))
		"Music":
			Options.volume_music = value
			AudioServer.set_bus_volume_db(bus_index, Options.volume_music)
			#print("Attempted assigned volume for music. index " + str(bus_index) + ", bus name " + str(bus_name))
		"Ambience":
			Options.volume_ambient = value
			AudioServer.set_bus_volume_db(bus_index, Options.volume_ambient)
			#print("Attempted assigned volume for ambient. index " + str(bus_index) + ", bus name " + str(bus_name))
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
