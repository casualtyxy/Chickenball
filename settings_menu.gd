extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DataButton.pressed.connect(dataManage)
	$DataButton/AcceptDialog.add_button("Clear All Data", false, "data")
	$DataButton/AcceptDialog.add_button("Reset Score", false, "resetscore")
	#$DataButton/AcceptDialog.add_button("CLEAR CONFIG", true, "config")
	#$DataButton/AcceptDialog.custom_action.connect(clear_data)
	$Back.pressed.connect(back)
	$TouchControl/AcceptDialog.add_button("Show", false, "action")
	$TouchControl/AcceptDialog.confirmed.connect(hide_touch_controls)
	$TouchControl.pressed.connect(inquire_touch)
	$PlayerCount.pressed.connect(player_count_change)
	$Back.grab_focus()
	
	$DataButton.pressed.connect(_confirm_sound)
	$TouchControl.pressed.connect(_confirm_sound)
	$Back.pressed.connect(_deny_sound)
	$PlayerCount.pressed.connect(_confirm_sound)
	
	#$DataButton.mouse_entered.connect(_mouse_on_data)
	#$DataButton.mouse_exited.connect(_mouse_off_data)

func _confirm_sound():
	$Sound.stream = load("res://audio/sounds/menu/confirm.ogg")
	$Sound.play()
func _deny_sound():
	$Sound.stream = load("res://audio/sounds/menu/deny.ogg")
	$Sound.play()

func dataManage():
	#This should cause a data manager screen to pop up, allowing the user to import a save file, under a condition for balance, or clear data/config.
	#I may add the option for 3 save files for 3 players sharing a machine. But for now, clearing data only.
	print_debug("Accessing data manager")
	$DataButton/AcceptDialog.popup()
#func _mouse_on_data():
	#$DataButton/Label.self_modulate = Color.YELLOW
#func _mouse_off_data():
	#$DataButton/Label.self_modulate = Color.WHITE

func clear_data(action: StringName):
	if action == "data":
		DirAccess.remove_absolute("user://data.save")
		DirAccess.remove_absolute("user://arcade_data.save")
		SaveFunc.load_game()
		SaveFunc.load_game_arcade()
		SaveFunc.save_game()
		SaveFunc.save_game_arcade()
		print_debug("Data clear")
	elif action == "resetscore":
		GlobalVar.best_score = 0
		SaveFunc.save_game_arcade()
	$DataButton/AcceptDialog.hide()

func back():
	Options.saveData()
	Screendrip.transition(1)
	await Screendrip.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func inquire_touch():
	$TouchControl/AcceptDialog.popup()
func show_touch_controls(_action:StringName):
	Options.display_onscreen_controls = true
	Options.saveData()
	$TouchControl/AcceptDialog.hide()
func hide_touch_controls():
	Options.display_onscreen_controls = false
	Options.saveData()

func player_count_change():
	GlobalVar.player_count += 1
	if GlobalVar.player_count > 4:
		GlobalVar.player_count = 1
	var count = GlobalVar.player_count
	if count > 1:
		$Box2/c.show()
	else:
		$Box2/c.hide()
		$Box3/c.hide()
		$Box4/c.hide()
	if count > 2:
		$Box3/c.show()
	else:
		$Box3/c.hide()
		$Box4/c.hide()
	if count > 3:
		$Box4/c.show()
	else:
		$Box4/c.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("f11"):
		GlobalVar.toggle_fullscreen()
	
	$LSound.text = "Sound: " + str(Options.volume_sound)
	$LMusic.text = "Music: " + str(Options.volume_music)
	$PlayerCount/PCountLabel.text = "[center]Player Count: " + str(GlobalVar.player_count)
	$ParallaxBackground/ParallaxLayer.motion_offset.x += 100 * delta
	$ParallaxBackground/ParallaxLayer2.motion_offset.x += 150 * delta
