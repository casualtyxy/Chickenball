extends CharacterBody2D

var bullet:PackedScene = preload("res://scenes/enemies/durian.tscn")

#var textures = [preload("res://art/enemies/Huckerworm.png"),preload("res://art/enemies/Huckerworm2.png")]
var boomsound = [preload("res://audio/sounds/Explosion_long2.wav"),preload("res://audio/sounds/Explosion_long.wav"),preload("res://audio/sounds/Explosion_long3.wav")]
var bubblesound = [preload("res://audio/sounds/bubbles/bubble-2.wav"),preload("res://audio/sounds/bubbles/bubble-3.wav"),preload("res://audio/sounds/bubbles/bubble-4.wav"),preload("res://audio/sounds/bubbles/bubble-7.wav")]
var ptc:PackedScene = preload("res://special_effects/particles/gummy_death.tscn")
var ptc2:PackedScene = preload("res://special_effects/particles/bubbles.tscn")

#@export var health: int
#@export var invincible := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$NormalFunc.play("spawn")
	$Timer.timeout.connect(shoot)
	$Timer.start(randi_range(2,8))
	$weakarea.body_entered.connect(clobbered)
	#$AnimationPlayer.animation_finished.connect(sound_the_boom)
	#$Sprite2D.texture = textures.pick_random()
	createColor()
	#$Perish.timeout.connect(remove)
	#print_debug($Body.self_modulate)
	

func startIdle():
	var nowbullet = bullet.instantiate()
	$"..".add_child(nowbullet)
	nowbullet.global_position = $BulletPoint.global_position
	nowbullet.set_direction(Vector2(1,0))
	$Timer.start(randi_range(1,8))
func shoot():
	$NormalFunc.play("spit")


#func hurt():
	#$HealthStat.show()
	#$HealthStat.value = health - 1
	#if $CShape.disabled == false:
		#toggle_world_col()
		#$Timer.paused = true
		##$NormalFunc.play("hurt")
		#await $NormalFunc.animation_finished
		#$Timer.paused = false
		
#func hurt_adjacent(): #Called in anim player to avoid insta death
	#health -= 1
	#toggle_world_col()

#func toggle_world_col():
	#$CShape.disabled = !$CShape.disabled

func clobbered(body: Node2D):
	if body is CharacterBody2D:
		if body.is_in_group("Player") and body.velocity.y > -1:
			$NormalFunc.play("squish")
			$Boom.stream = boomsound.pick_random()
			$Boom.play()
			var nptc = ptc.instantiate()
			$"..".add_child(nptc)
			nptc.global_position = global_position
			await get_tree().create_timer(0.4).timeout
			queue_free()
	
#func sound_the_boom(anim_name: StringName):
	#if anim_name == "explode":
		#pass

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
	var spawnColor = Color.from_hsv(randf(), 0.33, 1, 0.6) #Color8(randColorValue, randColorValue, randColorValue, 175)
	var selectionChance = randi_range(1,3)
	if selectionChance == 3:
		$Node2D/Gel.self_modulate = spawnColor
		$Node2D/Outline.self_modulate = spawnColor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var bodies = $Node2D/slowarea.get_overlapping_bodies()
	for i in bodies:
		if i is CharacterBody2D:
			if i.is_in_group("Player"):
				i.velocity.x /= 2
				i.velocity.y /= 2
