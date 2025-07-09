extends Node

signal settings_controls_reset

#events for when player reaches level x
#signal update3
#signal update15
#signal update25
#
#signal arcade_door_open
#
#signal food_increased
#signal health_changed
signal camera_mode_changed(mode: int)

signal camera_shake

enum menu_bg_elements {BLANK, RANCH, MEADOW} #For main menu
var menu_theme = menu_bg_elements.RANCH

#var gameIntroSeq = true #Eventual replacement for the scene

var paused = false

var player_count = 1

#var nut_upcost = 20
#var prod_upcost = 20
#var res_upcost = 40

#var resistance = 0

#var score_food_value = 10
#var nutrition_value = 3
#var production_rate = 1
#var level = 1
#var health = 5
#var max_health = 5
#var sprouts = 0
#var energy = 50
#var tokens = 0
#var dmg_type = "?"

#var food_touch = false
#var hurt_touch = false
#var bonus_touch = false
#var cleanse = false #temp way for bluefood to work
#var smelling_food = false# not in use
var death_controller = false
var player_facing = 1

#var seen_update3 = false
#var seen_update15 = false
#var seen_update25 = false

var bonus_active = false

#var dragging_item = false

var player:CharacterBody2D
#var player_skin = preload("res://art/player/new_chicken3.png")

#var level_queued:PackedScene
#var arcade_levels:Array[PackedScene]

#var mobs_defeated_arcade = 0
#var bonus_collected_arcade = 0

#var best_score = 0

#Sidescroll per-level use
var foods_collected = 0

#var broadcast_clear = false #tells all food to despawn, currently not in use

@onready var player_map_pos = Vector2(0,0)

#var mainscene = preload("res://scenes/main.tscn")

#var foodset: Array[Resource] = [preload("res://Resources/food.tres"), preload("res://Resources/badfood.tres"), preload("res://Resources/superfood.tres"), 
#preload("res://Resources/bluefood.tres"), preload("res://Resources/spike.tres"), preload("res://Resources/largefood.tres"), preload("res://Resources/largebadfood.tres")]

#func _ready() -> void:
	#update3.connect(_on_update_3)
	#update15.connect(_on_update_15)
	#update25.connect(_on_update_25)

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func request_camera_shake():
	camera_shake.emit()
	

#func reset_arcade():
	#score_food_value = 15
	#level = 1
	#health = max_health
	#max_health = 5
	#nutrition_value = 3
	#production_rate = 1
	#nut_upcost = 20
	#prod_upcost = 20
	#res_upcost = 40
	#dmg_type = "?"
	#light_reset_arcade()
	
#func light_reset_arcade():
	#health = GlobalVar.max_health
	#mobs_defeated_arcade = 0
	#bonus_collected_arcade = 0
	#GlobalVar.energy = 50

#func _on_update_3():
	#foodset[1].can_pick = true
	#foodset[2].can_pick = true
#func _on_update_15():
	#foodset[3].can_pick = true
	#foodset[4].can_pick = true
#func _on_update_25():
	#foodset[5].can_pick = true
	#foodset[6].can_pick = true

#func calculate_score() -> int:
	#var score = 0
	#score += level * 10
	##score += (max_health * 10) + (health * 10)
	#score += max_health * 10
	#score += score_food_value * 10.5
	#score += mobs_defeated_arcade * 10
	#score += bonus_collected_arcade * 10
	
	#return roundi(score)

#func update_food_list():
	#if GlobalVar.update3:
		#foodset[1].can_pick = true
		#foodset[2].can_pick = true
	#
	#if GlobalVar.update15:
		#foodset[3].can_pick = true
		#foodset[4].can_pick = true
		#
	#if GlobalVar.update25:
		#foodset[5].can_pick = true
		#foodset[6].can_pick = true

############ SETTINGS STUFF


############ PLATFORMER STUFF
signal toggled_pause(is_pausing: bool)
signal level_completed(level: int, completed: bool)
signal unlock_level(id: int)
signal ground_beetle_activate_link(id: int)
signal player_died() #less expensive than player_setup counting players every frame

var currentWorld:PackedScene = preload("res://scenes/levels/map_ranch_old.tscn")
var currentLevel:int = 0
var currentLevelDone:bool = false
var levelEndProcessing = false #level is ending, dont interupt!

func finishLevel(levelComplete: bool):
	if not levelEndProcessing:
		levelEndProcessing = true
		if levelComplete:
			currentLevelDone = true
			GlobalMusic.play_music(GlobalMusic.fanfare)
			await get_tree().create_timer(3).timeout
		if not levelComplete:
			currentLevelDone = false
			GlobalMusic.play_music(GlobalMusic.gameover)
			await get_tree().create_timer(0.3).timeout
		Screendrip.transition(Screendrip.transType.SPOTLIGHT)
		await Screendrip.on_transition_finished
		#get_tree().change_scene_to_packed(currentWorld) ----RETURN TO THIS WHEN TOPDOWN IS REWORKED
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		levelEndProcessing = false #reset this, otherwise you can only gameover once per session

func on_map_loaded(): #to be called in every map ready func
	levelEndProcessing = false
	#Also load level info from file
