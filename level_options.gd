extends Node2D

@export_category("Audio")
@export var music: AudioStream
@export var ambience: AudioStream

@export_category("Graphic")
@export var sky: Texture2D
@export var cloud_layer_back: Texture2D
@export var cloud_layer_middle: Texture2D
@export var cloud_layer_front: Texture2D
@export_enum("Preset", "Show", "Hide") var water: int
@export var structure_silhoutte: Texture2D
@export var structure_texture: Texture2D
@export var background: Texture2D

@export_category("Presets")
@export_enum("None", "Ranch Grassy", "Ranch Muddy") var preset: int
@export var weather_override: String = "Not yet implemented"


func _ready() -> void:
	#PRESETS
	match preset:
		0:
			pass
		1:
			preset_ranch_grassy()
		2:
			preset_ranch_muddy()
	
	#MANUAL CONFIGS
	if music != null:
		$MusicPlayer.stream = music
	if ambience != null:
		$AmbiencePlayer.stream = ambience
	if sky != null:
		$"BG and Clouds/BG".texture = sky
	if cloud_layer_back != null:
		$"BG and Clouds/3/Sprite2D".texture = cloud_layer_back
	if cloud_layer_middle != null:
		$"BG and Clouds/2/Sprite2D".texture = cloud_layer_middle
	if cloud_layer_middle != null:
		$"BG and Clouds/1/Sprite2D".texture = cloud_layer_front
	match water:
		0:
			pass
		1:
			$Water.show()
		2:
			$Water.hide()
	if structure_silhoutte != null:
		$DecorParallax/Structures/Spriteback.texture = structure_silhoutte
	if structure_texture != null:
		$DecorParallax/Structures/Sprite.texture = structure_texture
	if background != null:
		$DecorParallax/Background/Texture.texture = background
	
	if $MusicPlayer.stream != null:
		GlobalMusic.play_music($MusicPlayer.stream)
	if $AmbiencePlayer.stream != null:
		$AmbiencePlayer.play()

func preset_ranch_grassy():
	$MusicPlayer.stream = load("res://audio/music/Golf Course.ogg")
	$AmbiencePlayer
	$"BG and Clouds/BG".texture = load("res://art/background/farm/gradient3.png")
	$"BG and Clouds/3/Sprite2D".texture = load("res://art/background/farm/wavy1.png")
	$"BG and Clouds/2/Sprite2D".texture = load("res://art/background/farm/wavy2.png")
	$"BG and Clouds/1/Sprite2D"
	$Water.show()
	$DecorParallax/Structures/Spriteback.texture =  load("res://art/background/farm/windmills_back.png")
	$DecorParallax/Structures/Sprite.texture = load("res://art/background/farm/windmills.png")
	$DecorParallax/Background/Texture.texture = load("res://art/background/farm/testlayer.png")

func preset_ranch_muddy():
	$MusicPlayer.stream = load("res://audio/music/Berry Orchard.ogg")
	$AmbiencePlayer
	$"BG and Clouds/BG".texture = load("res://art/background/farm/gradient2.png")
	$"BG and Clouds/3/Sprite2D".texture = load("res://art/background/farm/wavy1.png")
	$"BG and Clouds/2/Sprite2D".texture = load("res://art/background/farm/wavy2.png")
	$"BG and Clouds/1/Sprite2D"
	$Water.hide()
	$DecorParallax/Structures/Spriteback
	$DecorParallax/Structures/Sprite
	$DecorParallax/Background/Texture.texture = load("res://art/background/farm/testlayer.png")
