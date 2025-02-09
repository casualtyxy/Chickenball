extends CharacterBody2D

@export var invincible = false

var ptc:PackedScene = preload("res://special_effects/particles/gummy_death.tscn")
var boomsound = preload("res://audio/sounds/snow_14.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Boom.stream = boomsound

func hurt():
	$Explosion.play("explode")
	$CShape.disabled = true
func _anim_finsihed(anime_name: StringName):
	if anime_name == "explode":
		queue_free()
		GlobalVar.mobs_defeated_arcade += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
