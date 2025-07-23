extends Node

############### GAME
#signal settings_controls_reset

enum menu_bg_elements {BLANK, RANCH, MEADOW} #For main menu

var menu_theme = menu_bg_elements.RANCH
var paused = false
var player_count = 1
var death_controller = false
#var player_facing = 1

## Probably dont need
#var bonus_active = false
#var player:CharacterBody2D
#var player_skin = preload("res://art/player/new_chicken3.png")
#var level_queued:PackedScene
#var arcade_levels:Array[PackedScene]
#@onready var player_map_pos = Vector2(0,0)

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func request_camera_shake():
	camera_shake.emit()

############ SETTINGS STUFF
# go to config handler
#var volume_ambient

############ PLATFORMER STUFF
signal camera_mode_changed(mode: int)
signal camera_shake
signal toggled_pause(is_pausing: bool)
signal level_completed(level: int, completed: bool)
signal unlock_level(id: int)
signal ground_beetle_activate_link(id: int)
signal player_died() #less expensive than player_setup counting players every frame

var currentWorld:PackedScene = preload("res://scenes/levels/map_ranch_old.tscn")
var currentLevel:int = 0
var currentLevelDone:bool = false
var levelEndProcessing = false #level is ending, dont interupt!
## Per-level use
var foods_collected = 0

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

#Will be ridding of maps probably
func on_map_loaded(): #to be called in every map ready func
	levelEndProcessing = false
	#Also load level info from file
