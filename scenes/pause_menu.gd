extends Node2D

var sfx_pause = preload("res://audio/sounds/menu/pause.wav")
var sfx_unpause = preload("res://audio/sounds/menu/whoosh.wav")
var sfx_prev = preload("res://audio/sounds/Attack Tap 01.ogg")
@onready var sound: AudioStreamPlayer = $Sound

#var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().show()
	hide()
	$Quit.pressed.connect(on_quit)
	$Close.pressed.connect(pause_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		pause_menu()
	if Input.is_action_just_pressed("f11"):
		GlobalVar.toggle_fullscreen()

func pause_menu():
	if !GlobalVar.paused:
		show()
		sound.stream = sfx_pause
		sound.play()
		GlobalVar.toggled_pause.emit(true)
		#Engine.set_deferred("time_scale", 0)
		GlobalMusic.stream_paused = true
		$Close.grab_focus()
	else:
		hide()
		sound.stream = sfx_unpause
		sound.play()
		GlobalVar.toggled_pause.emit(false)
		#Engine.time_scale = 1
		GlobalMusic.stream_paused = false
		Options.saveData()
	
	GlobalVar.paused = !GlobalVar.paused

func on_quit():
	pause_menu()
	sound.stream = sfx_unpause
	sound.play()
	SaveFunc.save_game()
	Options.saveData()
	Screendrip.transition()
	await Screendrip.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
