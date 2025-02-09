extends Node

signal saving_game

var save_path = "user://data.save"
var save_arcade_path = "user://arcade_data.save"

var map_ranch_object_data = {}
var map_ranch_objects:Array[Area2D]

@onready var foodtick = preload("res://processing/FoodTick.gd")
#var map_ranch = preload("res://scenes/levels/map_ranch.tscn")

func save_game():
	saving_game.emit()
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	
	save_file.store_var(GlobalVar.score_food_value)
	save_file.store_var(GlobalVar.level)
	
	save_file.store_var(GlobalVar.nutrition_value)
	save_file.store_var(GlobalVar.production_rate)
	save_file.store_var(GlobalVar.resistance)
	
	save_file.store_var(GlobalVar.nut_upcost)
	save_file.store_var(GlobalVar.prod_upcost)
	save_file.store_var(GlobalVar.res_upcost)
	
	save_file.store_var(GlobalVar.seen_update3)
	save_file.store_var(GlobalVar.seen_update15)
	save_file.store_var(GlobalVar.seen_update25)
	
	save_file.store_var(GlobalVar.health)
	save_file.store_var(GlobalVar.max_health)
	save_file.store_var(GlobalVar.sprouts)
	
	#save_file.store_var(map_ranch.player_map_pos)
	#print("Global pos " + str(map_ranch.player_map_pos))

func load_game():
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		
		GlobalVar.score_food_value = save_file.get_var()
		if GlobalVar.score_food_value < 1:
			GlobalVar.score_food_value = 10
		GlobalVar.level = save_file.get_var()
		
		GlobalVar.nutrition_value = save_file.get_var()
		GlobalVar.production_rate = save_file.get_var()
		GlobalVar.resistance = save_file.get_var()
		
		GlobalVar.nut_upcost = save_file.get_var()
		GlobalVar.prod_upcost = save_file.get_var()
		GlobalVar.res_upcost = save_file.get_var()
		
		GlobalVar.seen_update3 = save_file.get_var()
		GlobalVar.seen_update15 = save_file.get_var()
		GlobalVar.seen_update25 = save_file.get_var()
		#print("Seen: " + str(GlobalVar.seen_update3,GlobalVar.seen_update15,GlobalVar.seen_update25))
		#print("GV: " + str(GlobalVar.update3,GlobalVar.update15,GlobalVar.update25))
		
		#map_ranch.player_map_pos = save_file.get_var()
		
		#foodtick.badfooddata.can_pick = save_file.get_var()
		#print("Badfood can_pick is: " + str(foodtick.badfooddata.can_pick))
		
		if GlobalVar.seen_update3:
			GlobalVar.update3.emit()
			#GlobalVar.update_food_list()
		if GlobalVar.seen_update15:
			GlobalVar.update15.emit()
			#GlobalVar.update_food_list()
		if GlobalVar.seen_update25:
			GlobalVar.update25.emit()
			#GlobalVar.update_food_list()
		
		GlobalVar.health = save_file.get_var()
		if GlobalVar.health < 1:
			GlobalVar.health = 5
		GlobalVar.max_health = save_file.get_var()
		GlobalVar.sprouts = save_file.get_var()
		
	else:
		print("No save file found")

func save_game_arcade():
	var save_file = FileAccess.open(save_arcade_path, FileAccess.WRITE)
	
	save_file.store_var(GlobalVar.best_score)
	save_file.store_var(GlobalVar.tokens)
	#perm upgrades here too
	
func load_game_arcade():
	if FileAccess.file_exists(save_arcade_path):
		var save_file = FileAccess.open(save_arcade_path, FileAccess.READ)
		GlobalVar.best_score = save_file.get_var()
		GlobalVar.tokens = save_file.get_var()
