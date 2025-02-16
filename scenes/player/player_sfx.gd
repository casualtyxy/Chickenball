extends AudioStreamPlayer2D

var last_sound:Array[AudioStream] = []
var last_sound_name = "N/A"

var jump:Array[AudioStream] = [preload("res://audio/sounds/player/jump.ogg")]
var struggle:Array[AudioStream] = [preload("res://audio/sounds/player/flutter.ogg")]
var hurt:Array[AudioStream] = [preload("res://audio/sounds/hurt.wav")]
var nom:Array[AudioStream] = [preload("res://audio/sounds/pluck.wav")]
var wallkick:Array[AudioStream] = [preload("res://audio/sounds/player/land.ogg")]
var landing:Array[AudioStream] = [preload("res://audio/sounds/waddle2.wav")]
var explode:Array[AudioStream] = [preload("res://audio/sounds/player/dead.ogg")]

func play_sound(sound: String, override = true):
	if playing and override or not playing:
		
		match sound:
			"jump":
				last_sound = jump
				last_sound_name = "jump"
			"struggle":
				last_sound = struggle
				last_sound_name = "struggle"
			"hurt":
				last_sound = hurt
				last_sound_name = "hurt"
			"eat":
				last_sound = nom
				last_sound_name = "eat"
			"wallkick":
				last_sound = wallkick
				last_sound_name = "wallkick"
			"land":
				last_sound = landing
				last_sound_name = "land"
			"explode":
				last_sound = explode
				last_sound_name = "explode"
		
		stream = last_sound.pick_random()
		play()
