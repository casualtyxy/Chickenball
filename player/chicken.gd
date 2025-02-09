extends CharacterBody2D

@export var speed = 120
@export var max_speed = 150
@export var is_dashing = false #handles enemy knockouts for foodcheck. updated in animplayer

@onready var animation_tree = $VisMovetree
@onready var player_skin = $Skin
@onready var sfx = $SFX
@onready var sfx_overlay = $SFXOverlay
@onready var bok_1 = $VoiceSoundPool/Bok1
@onready var bok_2 = $VoiceSoundPool/Bok2
@onready var bok_3 = $VoiceSoundPool/Bok3
@onready var bok_4 = $VoiceSoundPool/Bok4
@onready var bok_5 = $VoiceSoundPool/Bok5
@onready var voice_array = [bok_1, bok_2, bok_3]

var knockback:Vector2 = Vector2(0,0)
var knockback_tween
var direction_facing = 1
var xinput = 0
var yinput = 0
var move_dir:Vector2 = Vector2(0,0)
var move_vect #move dir * move speed
var dash_cloud:PackedScene = preload("res://special_effects/particles/dash_cloud.tscn")
var is_invincible = false
#var sfx_peck = preload("res://audio/sounds/pluck.wav")
#var sfx_ouch = preload("res://audio/sounds/hurt.wav")
var sfx_bonus = preload("res://audio/sounds/coin.wav")
#var sfx_crush = preload("res://audio/sounds/char.wav")

#To replace the messy ass animation tree and parameter control method :sob: will work like platformer chicken
enum states {IDLE, WALKING, HURT, EAT, DASH, DEAD} #SQUISH?
var current_state = 0

func _ready():
	#animation_tree.active = true
	$bonusfire.hide()
	y_sort_enabled = true
	$ReadyAnim.play("ready")
	$Trail.one_shot = true
	$Trail.emitting = false
	GlobalVar.player = self
	GlobalVar.death_controller = false
	if not $InvFrames.is_connected("timeout", on_inv_timeout):
		$InvFrames.timeout.connect(on_inv_timeout)
	if not $RegenTimer.is_connected("timeout", regen):
		$RegenTimer.timeout.connect(regen)
	$Skin.texture = GlobalVar.player_skin
	$EnergyTimer.timeout.connect(energyReplenish)

func disable_camera():
	$Camera2D.enabled = false
func enable_camera():
	$Camera2D.enabled = true

	########################################################################### ANIMATIONS

#func update_animation_parameters():
	#if GlobalVar.hurt_touch:
		#animation_tree["parameters/conditions/is_eating"] = false
		#animation_tree["parameters/conditions/is_hurt"] = true 
		#animation_tree["parameters/conditions/is_moving"] = false
		#animation_tree["parameters/conditions/is_neutral"] = false
		#animation_tree["parameters/conditions/health_zero"] = false
		#animation_tree["parameters/conditions/is_dashing"] = false
		#animation_tree["parameters/conditions/is_jumping"] = false
		#GlobalVar.hurt_touch = false
		#activate_inv_frames()
	#elif GlobalVar.food_touch:
		#animation_tree["parameters/conditions/is_eating"] = true
		#animation_tree["parameters/conditions/is_hurt"] = false 
		#animation_tree["parameters/conditions/is_moving"] = false
		#animation_tree["parameters/conditions/is_neutral"] = false
		#animation_tree["parameters/conditions/is_dashing"] = false
		#animation_tree["parameters/conditions/is_jumping"] = false
		#GlobalVar.food_touch = false
	#elif Input.is_action_just_pressed("space"):
		#if not $VisualMovement.current_animation == "Jump" and GlobalVar.energy >= 5:
			#animation_tree["parameters/conditions/is_eating"] = false
			#animation_tree["parameters/conditions/is_hurt"] = false
			#animation_tree["parameters/conditions/is_moving"] = false
			#animation_tree["parameters/conditions/is_neutral"] = false
			#animation_tree["parameters/conditions/is_dashing"] = false
			#animation_tree["parameters/conditions/is_jumping"] = true
		#elif Input.is_action_just_pressed("space") and GlobalVar.energy < 5:
			#$DashWarning/AnimationPlayer.play("warning")
	#elif xinput == 0 and yinput == 0:
		#animation_tree["parameters/conditions/is_eating"] = false
		#animation_tree["parameters/conditions/is_hurt"] = false
		#animation_tree["parameters/conditions/is_moving"] = false
		#animation_tree["parameters/conditions/is_neutral"] = true
		#animation_tree["parameters/conditions/is_dashing"] = false
		#animation_tree["parameters/conditions/is_jumping"] = false
	#elif xinput != 0 or yinput != 0:
		#animation_tree["parameters/conditions/is_eating"] = false
		#animation_tree["parameters/conditions/is_hurt"] = false
		#animation_tree["parameters/conditions/is_moving"] = true
		#animation_tree["parameters/conditions/is_neutral"] = false
		#animation_tree["parameters/conditions/is_dashing"] = false
		#animation_tree["parameters/conditions/is_jumping"] = false
		#if Input.is_action_just_pressed("click_right") and GlobalVar.energy >= 5:
			#animation_tree["parameters/conditions/is_eating"] = false
			#animation_tree["parameters/conditions/is_hurt"] = false
			#animation_tree["parameters/conditions/is_moving"] = false
			#animation_tree["parameters/conditions/is_neutral"] = false
			#animation_tree["parameters/conditions/is_dashing"] = true
			#animation_tree["parameters/conditions/is_jumping"] = false
		#elif Input.is_action_just_pressed("click_right") and GlobalVar.energy < 5:
			#$DashWarning/AnimationPlayer.play("warning")
		#
	#if GlobalVar.death_controller:
		#animation_tree["parameters/conditions/is_eating"] = false
		#animation_tree["parameters/conditions/is_hurt"] = true
		#animation_tree["parameters/conditions/is_moving"] = false
		#animation_tree["parameters/conditions/is_neutral"] = false
		#animation_tree["parameters/conditions/health_zero"] = false
		#animation_tree["parameters/conditions/is_dashing"] = false
		#speed = 0
	#if GlobalVar.death_controller and Input.is_action_just_pressed("space"):
		#animation_tree["parameters/conditions/is_neutral"] = true
		#animation_tree["parameters/conditions/health_zero"] = false
		#speed = 120
		#get_tree().reload_current_scene()
		#_ready()
		#SaveFunc.load_game()

func states_manager():
	#STATE SETTER
	#if current_state != states.HURT: <PLACEHOLDER #Should be set by enemies, prob
	if 1 == 1:
		if GlobalVar.hurt_touch:
			current_state = states.HURT
		elif Input.is_action_just_pressed("click_right"):
			current_state = states.DASH
		elif GlobalVar.food_touch:
			current_state = states.EAT
		elif velocity == Vector2.ZERO:
			current_state = states.IDLE
		elif velocity != Vector2.ZERO:
			current_state = states.WALKING
		
	
	#ANIM MATCHING
	match current_state:
		0: #IDLE
			$StatePlayer.play("Idle")
		1: #WALKING
			$StatePlayer.play("Walk")
		2: #HURT
			$StatePlayer.play("Hurt")
		3: #EAT
			$StatePlayer.play("Eat")
		4: #DASH
			$StatePlayer.play("Dash")
		5: #DEAD
			$StatePlayer.play("Starve")

func dash():
	var ptc = dash_cloud.instantiate()
	$"..".add_child(ptc)
	ptc.global_position = self.global_position
	$Trail.restart()
	GlobalVar.energy -= 5
	velocity = velocity * 3
func energyReplenish():
	if GlobalVar.energy < 50:
		GlobalVar.energy += 1

#func accelerate_and_friction(): #Doesn't do anything
	#if move_dir != Vector2.ZERO:
		#velocity = velocity.move_toward(move_vect, accelr)
		##print(move_vect)
	#else:
		#velocity = velocity.move_toward(Vector2.ZERO, move_damp)
		##print(move_vect)

func pcControls(delta: float):
	xinput = Input.get_axis("left", "right")
	yinput = Input.get_axis("up", "down")
	move_dir = Vector2(xinput, yinput)
	#move_vect = move_dir.normalized() * speed
	
	if move_dir:
		velocity = lerp(velocity, move_dir * max_speed, delta * 5)
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta * 4)
	
	if Input.is_action_just_pressed("click_right") and GlobalVar.energy >= 5:
		dash()

func jump_cost():
	GlobalVar.energy -= 5 #something use using this

func _physics_process(delta):
	#print("Chicken pov: " + str(global_position))
	
	#update_animation_parameters()
	states_manager()
	
	#All inputs should prob go here
	pcControls(delta)
	
	# https://youtu.be/8SaU7Ci7bP8?si=WWly3Ylg_6r9p4oT
	
	
	move_and_slide()
	
	
	if Input.is_action_just_pressed("voice"):
		var temp:AudioStreamPlayer = voice_array.pick_random()
		temp.play()
	
	##################################### DIRECTION
	if GlobalVar.death_controller == false:
		if xinput < 0 and direction_facing == 1:
			player_skin.flip_h = true
			direction_facing = 0
		elif xinput > 0 and direction_facing == 0:
			player_skin.flip_h = false
			direction_facing = 1
	
	if GlobalVar.bonus_active and Input.is_action_just_pressed("click_right"):
		#$bonusfire.look_at(move_vect)
		pass
	
	##################################### OTHER
	if GlobalVar.score_food_value < 0 or GlobalVar.health <= 0:
		if GlobalVar.score_food_value < 0:
			$DashWarning/AnimationPlayer.play("warning")
		GlobalVar.death_controller = true
		#$AnimationPlayer.play("Hurt")
		await get_tree().create_timer(0.4).timeout
		deathHandler()
	
	if SaveFunc.saving_game:
		GlobalVar.player_map_pos = self.global_position
		
#***************** END OF PHYSICS PROCESS ************************

func regen():
	if GlobalVar.health < GlobalVar.max_health:
		GlobalVar.health += 1
		GlobalVar.health_changed.emit()
		$DashWarning/AnimationPlayer.play("overhead")
	$RegenTimer.start(30)

func activate_inv_frames():
	is_invincible = true
	$InvFrames.start(1)
	$Blink.play("blink")
	
func on_inv_timeout():
	is_invincible = false

func deathHandler(): #CALLED VIA ANIM PLAYER
	GlobalVar.player_facing = direction_facing
	print_debug("GlobVar:" + str(GlobalVar.player_facing) + " Player:" + str(direction_facing))
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
