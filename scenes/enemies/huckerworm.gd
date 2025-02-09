extends CharacterBody2D

var bullet:PackedScene = preload("res://scenes/enemies/durian.tscn")

#var textures = [preload("res://art/enemies/Huckerworm.png"),preload("res://art/enemies/Huckerworm2.png")]
var boomsound = [preload("res://audio/sounds/Explosion_long2.wav"),preload("res://audio/sounds/Explosion_long.wav"),preload("res://audio/sounds/Explosion_long3.wav")]
var bubblesound = [preload("res://audio/sounds/bubbles/bubble-2.wav"),preload("res://audio/sounds/bubbles/bubble-3.wav"),preload("res://audio/sounds/bubbles/bubble-4.wav"),preload("res://audio/sounds/bubbles/bubble-7.wav")]
var ptc:PackedScene = preload("res://special_effects/particles/gummy_death.tscn")
var ptc2:PackedScene = preload("res://special_effects/particles/bubbles.tscn")

@export var health: int
@export var invincible := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NormalFunc.play("spawn")
	$Timer.timeout.connect(shoot)
	$Timer.start(randi_range(2,8))
	#$AnimationPlayer.animation_finished.connect(sound_the_boom)
	#$Sprite2D.texture = textures.pick_random()
	createColor()
	#$Perish.timeout.connect(remove)
	#print_debug($Body.self_modulate)
	

func startIdle():
	var nowbullet = bullet.instantiate()
	$"..".add_child(nowbullet)
	nowbullet.global_position = $BulletPoint.global_position
	nowbullet.set_direction()
	$Timer.start(randi_range(1,8))
func shoot():
	$NormalFunc.play("spit")


func hurt():
	$HealthStat.show()
	$HealthStat.value = health - 1
	if $CShape.disabled == false:
		toggle_world_col()
		$Timer.paused = true
		$NormalFunc.play("hurt")
		await $NormalFunc.animation_finished
		$Timer.paused = false
	
		if health < 1:
			explode()
		else:
			startIdle()
func hurt_adjacent(): #Called in anim player to avoid insta death
	health -= 1
	toggle_world_col()

func toggle_world_col():
	$CShape.disabled = !$CShape.disabled

func explode():
	$HealthStat.hide()
	$Explosion.play("explode")
func sound_the_boom(anim_name: StringName):
	if anim_name == "explode":
		$Boom.stream = boomsound.pick_random()
		$Boom.play()
		var nptc = ptc.instantiate()
		$"..".add_child(nptc)
		nptc.global_position = global_position
		$Perish.start(0.4)
		await $Perish.timeout
		GlobalVar.mobs_defeated_arcade += 1
		queue_free()
func bubbles():
	var nptc = ptc2.instantiate()
	$"..".add_child(nptc)
	nptc.global_position = $BulletPoint.global_position
	$Boom.stream = bubblesound.pick_random()
	$Boom.play()
#func remove():
	#queue_free()

func createColor():
	#var randColorValue = randi_range(169,255) / 10
	var spawnColor = Color.from_hsv(randf(), 0.33, 1, 0.68) #Color8(randColorValue, randColorValue, randColorValue, 175)
	var selectionChance = randi_range(1,3)
	if selectionChance == 3:
		$Body.self_modulate = spawnColor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
