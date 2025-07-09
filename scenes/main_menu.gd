extends Node2D

var level1:PackedScene = preload("res://scenes/levels/map_ranch_old.tscn")
var node:PackedScene = preload("res://scenes/main.tscn")
var skippable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#$SettingsButton/AcceptDialog.add_button("CLEAR DATA", false, "cancel")
	$Control/SettingsButton.pressed.connect(_on_settings_button_pressed)
	$Control/HBoxContainer/About.pressed.connect(_on_credits_button_pressed)
	$Control/HBoxContainer/House.pressed.connect(_on_house_button_pressed)
	if get_parent().name == "GameIntroSeq":
		skippable = true
	#$Control/Adventure.grab_focus()
	
	$Control/Arcade.pressed.connect(enter_arcade)
	$Control/Arcade.mouse_entered.connect(arcade_peek)
	$Control/Arcade.focus_entered.connect(arcade_peek)
	$Control/Arcade.mouse_exited.connect(arcade_leave)
	$Control/Arcade.focus_exited.connect(arcade_leave)
	$Control/Adventure.pressed.connect(enter_adventure)
	$Control/Adventure.mouse_entered.connect(adventure_peek)
	$Control/Adventure.focus_entered.connect(adventure_peek)
	$Control/Adventure.mouse_exited.connect(adventure_leave)
	$Control/Adventure.focus_exited.connect(adventure_leave)
	var rand = randi_range(1, 200)
	#if rand == 3:
	#	$Title.text = "[wave amp=20, freq=-4][center]Dried Mediterranean Barnacles!"
	
	#GlobalVar.arcade_levels.assign([load("res://scenes/levels/arcade_forest.tscn"), 
	#load("res://scenes/levels/arcade_lake.tscn"), 
	#load("res://scenes/levels/arcade_depot.tscn"),
	#load("res://scenes/levels/arcade_forest_2.tscn")])
	
	load_background(GlobalVar.menu_theme)
	$Control/Adventure.pressed.connect(_confirm_sound)
	$Control/Arcade.pressed.connect(_confirm_sound)
	$Control/SettingsButton.pressed.connect(_confirm_sound)
	$Control/HBoxContainer/Achievements.pressed.connect(_confirm_sound)
	$Control/HBoxContainer/House.pressed.connect(_confirm_sound)
	$Control/HBoxContainer/About.pressed.connect(_confirm_sound)
	$PitSave.body_entered.connect(_on_player_fall)
	$Rightloop.body_entered.connect(_on_edge_touch.bind(1)) #adds the arguement 0 to be passed in
	$Leftloop.body_entered.connect(_on_edge_touch.bind(0))
	
	#ConfigHandler.reload_keybinds()
	#Options.loadData()
	if GlobalMusic.stream != GlobalMusic.main_menu:
		GlobalMusic.play_music(GlobalMusic.main_menu)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("f11"):
		GlobalVar.toggle_fullscreen()
	
	#if Input

func _confirm_sound():
	$Sound.stream = load("res://audio/sounds/menu/confirm.ogg")
	$Sound.play()
func _deny_sound():
	$Sound.stream = load("res://audio/sounds/menu/deny.ogg")
	$Sound.play()

func _on_player_fall(body: Node2D):
	body.global_position.y = -72
	body.global_position.x = 480
	body.velocity.y = 0
	body.velocity.x = 0

func _on_edge_touch(body: Node2D, dir: int):
	if body.is_in_group("Player"):
		if dir == 0:
			body.global_position.x = $Rightloop.global_position.x - 24
		elif dir == 1:
			body.global_position.x = $Leftloop.global_position.x + 24

func enter_arcade():
	#GlobalVar.reset_arcade()
	#randomize()
	#Screendrip.transition()
	#await Screendrip.on_transition_finished
	#get_tree().change_scene_to_file("res://scenes/levels/arcade_tutorial.tscn")
	#GlobalMusic.play_random()
	#SaveFunc.load_game_arcade()
	#print("Best: " + str(GlobalVar.best_score))
	pass
func arcade_peek():
	$Control/Arcade/Label.text = "[center][pulse]Arcade"
	$Control/Arcade/AnimationPlayer.play("hover")
	#$Control/Arcade.scale = Vector2(1.35,1.35)
	#$Control/Arcade.global_position = Vector2(263,151)
func arcade_leave():
	$Control/Arcade/Label.text = "[center]Arcade"
	$Control/Arcade/AnimationPlayer.play_backwards("hover")
	#$Control/Arcade.scale = Vector2(1.25,1.25)
	#$Control/Arcade.global_position = Vector2(268,156)

func enter_adventure():
	#$AudioStreamPlayer2D.play()
	Screendrip.transition(Screendrip.transType.SPOTLIGHT)
	await Screendrip.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/platformer/Map/ranch_map.tscn")
func adventure_peek():
	$Control/Adventure/Label.text = "[center][pulse]Adventure"
	$Control/Adventure/AnimationPlayer.play("hover")
	#$Control/Adventure.scale = Vector2(1.35,1.35)
	#$Control/Adventure.global_position = Vector2(59,151)
func adventure_leave():
	$Control/Adventure/Label.text = "[center]Adventure"
	$Control/Adventure/AnimationPlayer.play_backwards("hover")
	#$Control/Adventure.scale = Vector2(1.25,1.25)
	#$Control/Adventure.global_position = Vector2(64,156)

func _on_settings_button_pressed() -> void:
	#$SettingsButton/AcceptDialog.popup()
	Screendrip.transition(Screendrip.transType.SPOTLIGHT)
	await Screendrip.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/menu/settings_menu.tscn")
func _on_credits_button_pressed() -> void:
	pass
func _on_house_button_pressed() -> void:
	#Screendrip.transition()
	#await Screendrip.on_transition_finished
	#get_tree().change_scene_to_file("res://scenes/levels/house_room.tscn")
	#GlobalMusic.play_music(GlobalMusic.house_music)
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()

################################ BACKGROUNDS

func load_background(background: int):
	match background:
		0: #BLANK
			pass
			#$ParallaxBackground/BG.texture = load("res://art/menus/title/mainback1_1.png")
			#$ParallaxBackground/Layer1/Sprite2D.texture = load("res://art/menus/title/mainback1_2.png")
			#$ParallaxBackground/Layer2/Sprite2D.texture = load("res://art/menus/title/mainback1_3.png")
		1: #RANCH
			pass
			#$ParallaxBackground/BG.texture = load("res://art/background/farm/gradient.png")
			#$ParallaxBackground/Layer1/Sprite2D.texture = load("res://art/background/new_ocean_wide.png")
			#$ParallaxBackground/Layer2/Sprite2D.texture = load("res://art/background/farm/windmills.png")
		2: #MEADOW
			$ParallaxBackground/BG.texture = "res://art/background/meadowssky.png"
			$ParallaxBackground/Layer1/Sprite2D.texture
			$ParallaxBackground/Layer2/Sprite2D.texture
