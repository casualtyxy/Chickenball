extends RigidBody2D

signal double_jumped #AKA FLAPPED

@export_group("Controls")
@export var button_left:String
@export var button_right:String
@export var button_down:String
@export var button_jump:String
@export var button_flap:String


@export_group("Technical")
@export var is_player_1:bool = false #This gon be deprecated unless used for pause menus or sum
@export var jump_buffer_time := 0.3
@export var flap_buffer_time := 0.15
@export var coyote_time := 0.1
#@export var max_health: int = 5
@export var jump_vel := -500.0
@export var max_speed := 4000.0
@export var gravity_multiplier := 1.0
@export var flap_interval := 0.5
@export var acceleration := 0.05
@export var deceleration := 0.1
@export var push_force := 30.0
@export var size := 1.0
@export var max_size := 2.6
@export var player_skin:Texture2D

#@onready var sfx: AudioStreamPlayer2D = $SFX

#var speed = 0.0
#var health = 1
#var direction_facing = 1
var direction = Vector2.ZERO
#var prev_velocity: Vector2 = Vector2.ZERO
#var prev_speed = 0.0
#var extra_jumps = 1
#var max_air_jumps = 1
var is_on_ground = false
var is_left_wall = false
var is_right_wall = false
var was_grounded = false
#var was_walled = false
var can_jump = true
#var can_flap = true
#var input_pass_time = 0.1
#var received_push_direction = 0
#var jump_buffering:bool = false #maybe, maybe not

var current_state: int
enum states {IDLE, WALKING, JUMPING, TOUCHDOWN, EATING, DEAD, DOUBLE_JUMP, HURT, WALL, FALLING} #for anim use

var jumpCloud = preload("res://special_effects/particles/sweat.tscn") #Just integrate into the player at some point

######### MAIN #########

func _ready() -> void:
	$Coyote.timeout.connect(_when_coyote_over)
	$Coyote.one_shot = true
	#$StateTree.active = true
	#double_jumped.connect(_when_double_jump)
	#$WorldCol/AttackArea.area_entered.connect(_find_target)
	#$FlapInterval.timeout.connect(_on_flap_interval_ended)
	#$WorldCol/InteractRange.area_entered.connect(_on_touching_food)
	#$SpriteScale/Skin.texture = player_skin
	pass

func _physics_process(delta: float) -> void:
	
	#Checking the floor and walls
	raycasting()
	
	
	#DIRECTION
	#direction_and_facing(delta)
	action_input()
	
	#STATES
	#state_manager()
	
	#JUMPING
	#jump_processing(delta)
	
	#PLATFORMS
	if Input.is_action_pressed(button_down):
		set_collision_mask_value(6, false)
	else:
		set_collision_mask_value(6, true)
		
	
	#GETTING FAT
	#size_handler()
	
	#UPDATE INFO FOR NEXT FRAME REF - do NOT do this after move and slide
	was_grounded = is_on_ground
	#was_walled = is_on_wall()
	#prev_velocity = velocity
	
	#player_col()
	
	#move_and_slide()
	
	


######### COMPONENTS ###########

func action_input():
	direction = Input.get_axis(button_left, button_right)
	
	if direction:
		#moving while touching ground, players and platforms
		#if is_on_ground:
			#apply_torque(max_speed * direction)
		#elif not is_on_ground:
		apply_central_force(Vector2(direction * (max_speed / 10), 0))
	
	#jumping
	if is_on_ground:
		can_jump = true
	
	if Input.is_action_just_pressed(button_jump) and can_jump:
		
		if is_on_ground or not $Coyote.is_stopped():
			apply_central_impulse(Vector2(0, jump_vel))
			can_jump = false
		else:
			#wwall jump, since jump_vel is negative, we want to invert that for left and right accordingly
			if is_left_wall:
				#apply_central_impulse(Vector2.ZERO)
				apply_central_impulse(Vector2(jump_vel * -1, jump_vel))
			if is_right_wall:
				#apply_central_impulse(Vector2.ZERO)
				apply_central_impulse(Vector2(jump_vel * 1, jump_vel))
	
	#JUMP BUFFERING
	if Input.is_action_just_pressed(button_jump) and not is_on_ground:
		$JumpBuffer.start(jump_buffer_time)
		#last frame off ground, current frame on ground, buffer running
	if not was_grounded and is_on_ground and not $JumpBuffer.is_stopped():
		apply_central_impulse(Vector2(0, jump_vel))
		can_jump = false
	#Finish adding this for wall jump, my brain too tired for this rn
	

func raycasting():
	$Raycasts.global_rotation_degrees = 0.0
	if $Raycasts/down.is_colliding():
		is_on_ground = true
	else:
		is_on_ground = false
	
	#wall kick
	if $Raycasts/right.is_colliding():
		is_right_wall = true
	else:
		is_right_wall = false
	if $Raycasts/left.is_colliding():
		is_left_wall = true
	else:
		is_left_wall = false

#func _on_touching_food(area: Area2D):
	#if area.is_in_group("Food"):
		#if area.find_child("Collect_this_item").can_collect:
			#area.find_child("Collect_this_item").consume()
			#var size_plus = float(area.find_child("Collect_this_item").calories)
			#if size < max_size:
				#size += size_plus / 100
				#print("Adding to size: " + str(size_plus / 100))
	#elif area.is_in_group("Item"):
		#area.find_child("Collect_this_item").consume()
##func bounce_player(body: Node2D):
	##if body.is_in_group("Player"):
		##body.velocity.y += jump_vel / 2
##func size_handler():
	##$SpriteScale.scale = Vector2(size, size)
	##$WorldCol.scale = Vector2(size, size)
##
###func player_col():
	###for i in get_slide_collision_count():
		###var col_info = get_slide_collision(i)
		###var body = col_info.get_collider()
		###if body is CharacterBody2D and body.is_in_group("Player"):
			###
			###
			###
			####print(name + " collided with: ", col_info.get_collider().name)
			####if global_position.y >= body.global_position.y:
				#####active pushing
				####if direction:
					#####print(name + ": Got pushed actively")
					####body.received_push_direction = direction
				#####passive push
				####elif received_push_direction:
					#####print(name + ": Got pushed passively")
					####body.received_push_direction = received_push_direction
				#####move the player with received push
				####velocity.x += received_push_direction * body.push_force
				#####print("Push force: " + str(received_push_direction * body.push_force))
			###
			###
			###
			####push player x axis
			###if global_position.y > body.global_position.y:
				###if direction:
					###body.velocity.x += push_force * direction
					###body.received_push_direction = direction
				###elif received_push_direction:
					###body.velocity.x += push_force * received_push_direction
					###received_push_direction = 0
				###print(received_push_direction * push_force)
					###
				####Yeah screw that
				####var push_modifier = (max_size + (size - body.size)) * (100 / max_size)
				####print("(" + str(max_size) + " + (" + str(size) + " - " + str(body.size) + ")) * (100 / " + str(max_size) + ")")
				####print("push_modifier gen: " + str(push_modifier))
				####body.velocity.x += (push_force * (push_modifier / 100)) * direction
				####print(push_force * (push_modifier / 100))
				####print(str(global_position.y) + " > " + str(body.global_position.y))

#func fell_in_pit():
	#size = 1
	#hurt()
	##await get_tree().create_timer(3).timeout
	##send this timer to the finishlevel func in global

#func direction_and_facing(delta: float):
	##DIRECTION, ACCEL, DECEL
	#if $InputPass.is_stopped(): #INPUTPASS is for wall jumping, it will ignore directional input briefly after jumping off the wall
		#direction = Input.get_axis(button_left, button_right) #-1 means left, 0 means no input, 1 means right (ONLY input)
	#if direction: #and current_state != states.HURT:
		##accelerate
		#if is_on_floor() and abs(velocity.x) < max_speed:
			#velocity.x += direction * acceleration
		#else:
			#velocity.x += (direction * acceleration) / 2
	#else:
		##decelerate
		#if is_on_floor():
			#velocity.x = lerpf(velocity.x, 0.0, deceleration)
		#else:
			##velocity.x = lerpf(velocity.x, 0.0, delta)
			#pass
		#
	##DIRECTION_FACING UPDATES WITH DIRECTION
	##going left
	#if Input.get_axis(button_left, button_right) < 0 and direction_facing == 1:
		##velocity match
		#if velocity.x <= 0 or not is_on_floor():
			#direction_facing = -1
		##skidding
		#elif is_on_floor():
			#$SpriteScale/Skin.frame = 4
			#$SkidParticles.emitting = true
	##going right
	#elif Input.get_axis(button_left, button_right) > 0 and direction_facing == -1:
		##velocity match
		#if velocity.x >= 0 or not is_on_floor():
			#direction_facing = 1
		##skidding
		#elif is_on_floor():
			#$SpriteScale/Skin.frame = 4
			#$SkidParticles.emitting = true
	#
	##SPRITE ORIENTATION
	#if direction_facing == 1:
		#$SpriteScale/Skin.flip_h = false
	#elif direction_facing == -1:
		#$SpriteScale/Skin.flip_h = true
#
##func _when_double_jump(): #AKA FLAP, STARTS FLAP INTERVAL
		##current_state = states.DOUBLE_JUMP
		##sfx.play_sound("struggle")
		##$FlapInterval.start(flap_interval)
		##can_flap = false
		###print("executed double jump")
##
###func _on_flap_interval_ended(): #Includes buffer check
	###can_flap = true
	###if not $FlapBuffer.is_stopped():
		####copied from jump_processing double jump bc I didnt want to make another method
		###velocity.y = 0
		###velocity.y += jump_vel * 0.4
		###var ptc = jumpCloud.instantiate()
		###get_parent().add_child(ptc)
		###ptc.global_position = global_position + Vector2(0,-10)
		###double_jumped.emit()

func _when_coyote_over():
	#print("Coyote over")
	can_jump = false

#func jump_processing(delta: float):
	#
	##RESET JUMP
	#if is_on_floor():
		#can_jump = true
	#
	##FAT SHAKE
	#if not was_grounded and is_on_floor_only() and size > 1.9:
		#GlobalVar.request_camera_shake()
	#
	##START COYOTE TIMER
		##last frame was on ground, current frame not on ground
	#if was_grounded == true and is_on_floor() == false and not Input.is_action_pressed(button_jump) and $Coyote.time_left <= 0:
		#$Coyote.start(coyote_time)
	#
	##JUMP INPUT
	#if Input.is_action_just_pressed(button_jump) and can_jump and current_state != states.HURT:
		#velocity.y = jump_vel
		#can_jump = false
		#
		##Weakens the jump on release
	#elif Input.is_action_just_released(button_jump) and velocity.y < 0 and can_flap:
		#velocity.y = jump_vel / 4
	#
	###Player boost
	##if is_on_ceiling() and Input.is_action_pressed(button_jump): #this only goes off if player has upward velocity
			##var players_on_head:Array[Node2D] = $WorldCol/InteractRange.get_overlapping_bodies()
			##for body in players_on_head:
				##if body.is_in_group("Player"):
						##body.velocity.y = 0
						##body.velocity.y += jump_vel
						##$JumpBuffer.start(jump_buffer_time)
						###if velocity.y > 4 and can_jump: #falling or still
							###velocity.y += jump_vel
							###can_jump = false
	#
	##WALL JUMP
	#if is_on_wall_only() and Input.is_action_just_pressed(button_jump):# and direction:
			#velocity.y = jump_vel * 0.75
			#velocity.x = jump_vel * 1.2 * direction_facing
			#direction_facing *= -1
			#sfx.play_sound("wallkick")
	#
	##JUMP SOUND MIN PLAYING TIME
	#if sfx.last_sound_name == "jump" and Input.is_action_just_released(button_jump) and velocity.y < 0 and can_flap:
		#await get_tree().create_timer(0.1).timeout #min playing time
		#if sfx.last_sound_name == "jump":
			#sfx.stop()
	#
	##JUMP BUFFERING
	#if Input.is_action_just_pressed(button_jump) and not is_on_floor():
		#$JumpBuffer.start(jump_buffer_time)
		##last frame off ground, current frame on ground, buffer running
	#if not was_grounded and is_on_floor() and not $JumpBuffer.is_stopped():
		#velocity.y = jump_vel
		#can_jump = false
		#sfx.play_sound("jump")
		#current_state = states.JUMPING
	#
	##GRAVITY AND WALLSLIDE
	#if not was_walled and is_on_wall_only():
		#print($WorldCol/InteractRange.get_overlapping_bodies())
		#if velocity.y > 0:
			#velocity.y = 0
		##Adapt direction on wall touch
		#if prev_velocity.x > 0:
			#direction_facing = 1
		#elif prev_velocity.x < 0:
			#direction_facing = -1
		#else:
			#print_debug("Player hit wall: Prev velocity was 0")
		#
		#velocity.x = 0
	#
	#if not is_on_floor():
		#if not current_state == states.WALL:
			#gravity_multiplier = 1
		#elif current_state == states.WALL:
			#gravity_multiplier = 0.25
			#
		#velocity += get_gravity() * gravity_multiplier * delta
		#
	##DOUBLE JUMP / FLAP + BUFFER
		#if Input.is_action_just_pressed(button_flap) and can_flap and $Coyote.is_stopped():
			#velocity.y = 0
			#velocity.y += jump_vel * 0.4
			##extra_jumps -= 1 ---------------------EXTRA JUMPS TURNED OFF
			#var ptc = jumpCloud.instantiate()
			#get_parent().add_child(ptc)
			#ptc.global_position = global_position + Vector2(0,-10)
			##print("Double jump input")
			#double_jumped.emit()
		#elif Input.is_action_just_pressed(button_flap) and not can_flap and $Coyote.is_stopped():
			#$FlapBuffer.start(flap_buffer_time)
			#print("Started flap buffer")
	##if Input.is_action_pressed("down") and not is_on_floor():
		##gravity_multiplier = 2
	##else:
		##gravity_multiplier = 1
	#pass
#
##func state_manager():
	##
	###Order logic: should the listed action interrupt the action below it?
	##
	####### STATE SETTER
	##if current_state != states.HURT: #Set by hurt() which is calle dby enemies and traps
		##
		###jumping off ground
		##if was_grounded and is_on_floor() and Input.is_action_just_pressed(button_jump) or not $Coyote.is_stopped() and Input.is_action_just_pressed(button_jump):
			##current_state = states.JUMPING #Also set in buffering
			##sfx.play_sound("jump")
		##
		###falling
		##if not was_grounded and not is_on_floor() and velocity.y > 20:
			##current_state = states.FALLING
		##
		###hit ground
		##if not was_grounded and is_on_floor(): #and not $StatePlayer.current_animation == "Jump_end":
			##current_state = states.TOUCHDOWN
			##sfx.play_sound("land")
		##
		###walking
		##elif direction and is_on_floor() and not $StatePlayer.current_animation == "Jump_end" and not Input.is_action_just_pressed(button_jump):
			##current_state = states.WALKING
		##
		###idle
		##elif !direction and is_on_floor() and not Input.is_action_just_pressed(button_jump) and not $StatePlayer.current_animation == "Jump_end":
			##current_state = states.IDLE
		##
		###hugging wall - player is touching a wall while descending
		##elif is_on_wall_only() and velocity.y >= 10 and not Input.is_action_just_pressed(button_jump):# and direction: #downward velocity
			##current_state = states.WALL
		####releasing wall - player moved off the wall
		###elif was_walled and is_on_wall_only() and velocity.y >= 0 and not Input.is_action_pressed(button_jump):# and !direction:
			###current_state = states.FALLING
		###falling off wall -
		##elif was_walled and not is_on_wall() and velocity.y >= 0 and not Input.is_action_pressed(button_jump):
			##current_state = states.FALLING
		###jumping off wall
		##elif is_on_wall_only() and velocity.y >= 0 and Input.is_action_just_pressed(button_jump) or is_on_wall_only() and velocity.y >= 0 and not $JumpBuffer.is_stopped():
			##current_state = states.JUMPING
			##$InputPass.start(input_pass_time)
	##
		###flap - THIS IS SET IN _when_double_jump()
		###elif not can_flap and not is_on_wall() and current_state == states.JUMPING: #right
			###current_state = states.DOUBLE_JUMP
	##
	###print(current_state)
##
	##
	###SKIDDING
	##if current_state == states.TOUCHDOWN and is_on_floor() and velocity.x != 0:
		##$SkidParticles.emitting = true
		###sfx.play_sound_until_done(sfx.slide)
	##elif current_state == states.HURT and is_on_floor() and velocity.x != 0:
		##$SkidParticles.emitting = true
	##else:
		##$SkidParticles.emitting = false
##
	##if current_state == states.WALL:
		##if direction_facing == 1:
			##$WallSkid.position.x = 9
		##elif direction_facing == -1:
			##$WallSkid.position.x = -9
		##$WallSkid.emitting = true
	##else:
		##$WallSkid.emitting = false
	##
	###ANIM MATCHING
	##match current_state:
		##0: #IDLE
			##$StatePlayer.play("Idle")
		##1: #WALK
			##$StatePlayer.play("Walking")
		##2: #JUMP
			##$StatePlayer.play("Jump_start")
		##3: #TOUCHDOWN (when hitting ground)
			##$StatePlayer.play("Jump_end")
		##4: #EAT
			##pass
		##5: #DEAD
			##pass
		##6: #DOUBLE JUMP
			##if direction_facing == 1 and not can_flap: #right
				##$StatePlayer.play("Double_jump")
			##elif direction_facing == -1 and not can_flap: #left
				##$StatePlayer.play("Double_jump_backwards")
		##7: #HURT
			##pass
		##8: #WALL
			##$StatePlayer.play("Wall")
		##9: #FALLING
			##if $StatePlayer.assigned_animation != "Falling":
				##$StatePlayer.play("Falling")

#func _find_target(area: Area2D):
	#if area.is_in_group("Squishable"):
		#area.get_parent().clobbered()
		##$Pow.global_position = area.get_parent().global_position - global_position
		#$Pow.emitting = true
		#if Input.is_action_pressed(button_jump) or Input.is_action_pressed(button_flap):
			#velocity.y = 0
			#velocity.y += jump_vel * 1.25
		#else:
			#velocity.y = 0
			#velocity.y += jump_vel * 0.75

#func hurt():
	#current_state = states.HURT #basically just overrides statemachine states and anims
	#if size > 1.4:
		#size = 1
		#sfx.play_sound("hurt")
		#activate_inv_frames()
		#$StatePlayer.play("Hurt")
		#await $StatePlayer.animation_finished
		#current_state = states.IDLE
	#else:
		#sfx.play_sound("explode")
		#$StatePlayer.play("Explode")
		#await $Splode.finished
		#current_state = states.DEAD #Read only I guess, this number is 5
		#disable()
		##GlobalVar.finishLevel(false)

func activate_inv_frames():
	set_collision_layer_value(4, false)
	$Inv.play("standard")
	await $Inv.animation_finished
	set_collision_layer_value(4, true)

func disable():
	set_collision_layer_value(4, false)
	set_collision_layer_value(5, false)
	#$WorldCol.disabled = true
	hide()
	process_mode = PROCESS_MODE_DISABLED

func enable():
	if not GlobalVar.paused:
		process_mode = PROCESS_MODE_INHERIT
		set_collision_layer_value(4, true)
		set_collision_layer_value(5, true)
		$WorldCol.disabled = false
		size = 1
		show()

#//
