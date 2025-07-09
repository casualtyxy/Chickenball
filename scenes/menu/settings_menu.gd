extends Node2D

var viewing_keybinds := false

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
	$Keybinds.pressed.connect(_keybind_menu)
	
	#$DataButton.mouse_entered.connect(_mouse_on_data)
	#$DataButton.mouse_exited.connect(_mouse_off_data)
	player_list_update()

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
	Screendrip.transition(Screendrip.transType.SPOTLIGHT)
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
	player_list_update()
func player_list_update():
	var count = GlobalVar.player_count
	match count:
		1:
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box1.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box2.hide()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box3.hide()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box4.hide()
		2:
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box1.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box2.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box3.hide()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box4.hide()
		3:
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box1.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box2.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box3.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box4.hide()
		4:
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box1.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box2.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box3.show()
			$PList/PanelContainer/MarginContainer/HBoxContainer/Box4.show()

func _keybind_menu():
	if viewing_keybinds:
		$Camera2D.global_position = Vector2.ZERO
		viewing_keybinds = false
		
	else:
		$Camera2D.global_position = Vector2(960, 0)
		viewing_keybinds = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("f11"):
		GlobalVar.toggle_fullscreen()
	if Input.is_action_just_pressed("escape"):
		if viewing_keybinds:
			_keybind_menu()
	
	$LSound.text = "Sound: " + str(Options.volume_sound * 100)
	$LMusic.text = "Music: " + str(Options.volume_music * 100)
	$PlayerCount/PCountLabel.text = "[center]Player Count: " + str(GlobalVar.player_count)
	$ParallaxBackground/ParallaxLayer.motion_offset.x += 100 * delta
	$ParallaxBackground/ParallaxLayer2.motion_offset.x += 150 * delta
	$ParallaxBackground/ParallaxLayer3.motion_offset.x += 10 * delta
