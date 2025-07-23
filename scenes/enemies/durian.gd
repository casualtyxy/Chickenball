extends Area2D

@onready var player = get_parent().find_child("Player1_Platformer")

var spin_direction
var destination = false
var speed = 30
var target_pos:Vector2
var direction:Vector2 = Vector2(0,0)

var closest_player: Node2D

var alt_textures = [preload("res://art/enemies/durian1.png"),preload("res://art/enemies/durian2.png"),preload("res://art/enemies/durian3.png")]

func _ready() -> void:
	randomize()
	if randi_range(1,4) == 1:
		$Sprite2D.texture = alt_textures.pick_random()
	
	spin_direction = randi_range(0, 1)
	if spin_direction == 1:
		$Spin.play("default")
	else:
		$Spin.play_backwards("default")
	$Timer.timeout.connect(on_timeout) ##Uncomment for homing
	$Timer.start(5)
	#speed = randi_range(40, 100) * 2
	
	body_entered.connect(_on_body_entered)
	
	#if player == null:
		#player = get_parent().find_child("Player1")

func _physics_process(delta: float) -> void:
	global_position -= direction * speed * delta
	#print("Durian pov: " + str(player.global_position))

func find_closest_player():
	pass

func set_direction(xy: Vector2): #Should be called by whatever fired it, due to position screwy-ness when adding to the tree
	#direction = (global_position - player.global_position).normalized()
	direction = xy
func set_speed(speed_in: float):
	if speed_in > 0: #passing a negative will do nothing
		speed = speed_in

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		if body.is_in_group("Player"):
			body.hurt()
		elif body.is_in_group("Squishable"):
			body.clobbered()

func on_timeout():
	$Fade.play("fade")
	#print("fading")

func explode():
	$Spin.pause()
	speed = 0
	$Fade.play("explode", -1, 2)
	await $Fade.animation_finished
	queue_free()

func remove():
	queue_free()
	#print("removed")
func disableCol():
	$CollShape2D.disabled = true
	
##Uncomment for homing:
	#if get_tree().has_group("Player"):
		##target_pos = (GlobalVar.player.position - self.position).normalized()
		#if position.distance_to(GlobalVar.player.position) > 3:
			#position += target_pos * speed * delta
	#else:
		#queue_free()
		#print("no player found")
	##Comment for homing:
	#global_position -= fire_direction * speed * delta
	
	#if global_position.distance_to(target_pos) > 15.0:
			#global_position += target_pos * speed * delta
	##if position.distance_to(target_pos) < 5.0:
	#if global_position.distance_to(player_last_pos) < 15.0:
		#if destination == false:
			#destination = true
			#on_timeout()
	##print_debug("Durian pos: " + str(global_position))
	##print_debug("Goal:" + str(target_pos))
	##print("\n")
