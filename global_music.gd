extends AudioStreamPlayer

signal song_finished

### Menus
const game_intro = preload("res://audio/music/Intro.wav")
const main_menu = preload("res://audio/music/menu/IntroMenu2.ogg")
const house_music = preload("res://audio/music/Doorbell.ogg")

### Arcade levels
const arcade_tracks:Array[AudioStream] = [arcade5]#[arcade1, arcade2, arcade4, arcade6, arcade7, arcade9, arcadebass, arcadefast1]
const arcade1 = preload("res://audio/music/Mission.ogg")
const arcade2 = preload("res://audio/music/Mission2.ogg")
const arcade3 = preload("res://audio/music/arcade3.ogg")
const arcade4 = preload("res://audio/music/arcade4.ogg")
const arcade5 = preload("res://audio/music/CitrusCoast.ogg")
const arcade6 = preload("res://audio/music/arcade6.ogg")
const arcade7 = preload("res://audio/music/arcade7.ogg")
#const arcade8
const arcade9 = preload("res://audio/music/arcade9.ogg")
const arcadefast1 = preload("res://audio/music/arcade_fast1.ogg")
const arcadebass = preload("res://audio/music/Chickenbass.ogg")

### Adventure levels
const berry_farm = preload("res://audio/music/Tutorial.ogg")
const berry_farm_level_1 = preload("res://audio/music/CB_Island1.ogg")

const orange_plain_meadows = preload("res://audio/music/Egg Horizon.ogg")

### Minigames
#?

func _ready() -> void:
	finished.connect(when_finished)

func play_music(track: AudioStream):#, volume: float):
	#if volume == null:
		#volume = 0.0
	
	stream = track
	#volume_db = volume
	play()

func play_random():
	var temp = arcade_tracks.pick_random()
	var rand = randi_range(1, 20)
	if rand == 3:
		play_music(arcade3)
	else:
		play_music(temp)

func when_finished():
	song_finished.emit()
