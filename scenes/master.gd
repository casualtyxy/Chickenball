extends Node

@onready var save_anim = $SaveAnim
@onready var pause_menu = $CanvasLayer/PauseMenu

func _ready():
	#SaveFunc.load_game()
	$Autosave.start()
	$Autosave.autostart = true
	load_level(GlobalVar.level_queued)

func load_level(level):
	get_child(0).add_sibling(level.instantiate())

#func save():
	#var save_dict = {
		#
		#"Nut" : GlobalVar.nutrition_value,
		#"NutCost" : GlobalVar.nut_upcost,
		#"Prod" : GlobalVar.production_rate,
		#"ProdCost" : GlobalVar.prod_upcost,
		#"Res" : GlobalVar.resistance,
		#"ResCost" : GlobalVar.res_upcost,
	#}
	#return save_dict
#
#func save_game():
	#var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE) #Creates a writable file var with directory
	#
	#var json_string = JSON.stringify(save(),"   ") #turns the saved dict into a json layout like in minecraft
	#
	#save_file.store_line(json_string) #adds the json to the writable file
#
#func load_game(): #all this does is print
	#if not FileAccess.file_exists("user://savegame.save"):
		#print("No save file found")
		#return
		#
	#var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
#
	#while save_file.get_position() < save_file.get_length(): #looping through file lines
		#var json_string = save_file.get_line()
		#print(json_string)
		#var json = JSON.new()
		#print(json)
		#var parse_result = json.parse(json_string)
		#print(parse_result)
		#var node_data = json.get_data()
		#
		#print(node_data)


func _on_autosave_timeout():
	SaveFunc.save_game()
	save_anim.play("default")
	
#func _process(_delta: float) -> void:
	##if Input.is_action_just_pressed("escape"):
		##pause_menu.pause_menu()
