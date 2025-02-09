extends Node2D

@onready var mapsfx = $MAP_SFX
#@onready var upgrade_menu = $CanvasLayer/GUI/UpgradeMenus
@onready var screeneffect_animation_player = $CanvasLayer/ScreenEffect/AnimationPlayer
#@onready var gui_animation: AnimationPlayer = $CanvasLayer/GUI/GUIAnimation

@onready var gui = $CanvasLayer/GUI

var background_forest = preload("res://art/background/chicballforestback2.png")
var background_meadow = preload("res://art/background/chicballmeadowsback.png")
var background_wetlands = preload("res://art/background/chicballwetlandsback.png")
var background_starve = preload("res://art/background/starvedback.png")

var ambience_forest1 = preload("res://audio/ambience/Thunder1.wav")
var ambience_forest2 = preload("res://audio/ambience/Rain1.wav")

var background_list = [background_forest, background_meadow, background_wetlands]
var ambience_list = [ambience_forest1, ambience_forest2]

var min_playable_x = 10
var max_playable_x = 470
var min_playable_y = 315
var max_playable_y = 380

# Called when the node enters the scene tree for the first time.
func _ready():
	#$ParallaxBackground/Sprite2D.texture = background_list.pick_random()
	y_sort_enabled = true
	#upgrade_menu.hide()
	#Screendrip.transition()
	
func setup(): #respawn func
	$ParallaxBackground/Sprite2D.texture = background_list.pick_random()
	GlobalVar.death_controller = false
	GlobalVar.score_food_value = 10
	GlobalVar.nutrition_value = 3
	GlobalVar.production_rate = 1
	GlobalVar.level = 1
	GlobalVar.resistance = 0
	#GlobalVar.update3 = false
	#GlobalVar.update15 = false
	GlobalVar.nut_upcost = 20
	GlobalVar.prod_upcost = 20
	GlobalVar.res_upcost = 40
	$FoodTick.current_foodset.resize(1)
	get_tree().reload_current_scene()
	#GlobalVar.broadcast_clear = true
	#$AudioStreamPlayer.stream = ambience_list.pick_random()
	#$AudioStreamPlayer.autoplay = true
	#$AudioStreamPlayer.play()

func _process(_delta):
	
	#if GlobalVar.update3 or GlobalVar.update15 or GlobalVar.update25:
		#screeneffect_animation_player.play("NewContent")
		#upgrade_menu.timer.start()
	
	if GlobalVar.death_controller and Input.is_action_just_pressed("space"):
		setup()
		
	if GlobalVar.score_food_value <= 0:
		$ParallaxBackground/Sprite2D.texture = background_starve
		


func _on_ambience_finished():
	$Ambience.play()
