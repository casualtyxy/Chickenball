class_name Player extends CharacterBody2D

### PROBLEM: There are 3 vars tied to being dead; state 5, state 10 (which is for fully disabling?) and the dead bool

signal double_jumped #AKA FLAPPED

@export_group("Controls")
@export var button_left:String
@export var button_right:String
@export var button_down:String
@export var button_jump:String
@export var button_flap:String


@export_group("Technical")
@export var index:int = 0
### Player will be ignored by the alive players check if true, for disabling unneeded player instances
#@export var turned_off: bool = false
#@export var is_player_1:bool = false #This gon be deprecated unless used for pause menus or sum
@export var jump_buffer_time := 0.3
@export var flap_buffer_time := 0.15
@export var coyote_time := 0.1
#@export var max_health: int = 5
@export var jump_vel := -450.0
@export var max_speed := 250.0
@export var gravity_multiplier := 1.0
@export var flap_interval := 0.5
@export var acceleration := 4
@export var deceleration := 0.1
@export var push_force := 30.0
@export var size := 1.0
@export var max_size := 2.6
@export var dead: bool = false
@export var lives: int = 0
var lives_cap = 99

@export_group("Textures")
@export var player_skin:Texture2D
@export var player_face:Texture2D

@onready var sfx: AudioStreamPlayer2D = $SFX

@onready var interact_x = $WorldCol/InteractRangeX
@onready var interact_y = $WorldCol/InteractRangeY

var speed = 0.0
#var health = 1
var direction_facing = 1
var direction = Vector2.ZERO
var prev_velocity: Vector2 = Vector2.ZERO
var prev_speed = 0.0
#var extra_jumps = 1
#var max_air_jumps = 1
var was_grounded = false
var was_walled = false
var can_jump = true
var can_flap = true
var input_pass_time = 0.1
var received_push_direction = 0
#var jump_buffering:bool = false #maybe, maybe not
var on_left_wall = false
var on_right_wall = false

var current_state: int
enum states {IDLE, WALKING, JUMPING, TOUCHDOWN, EATING, DEAD, DOUBLE_JUMP, HURT, WALL, FALLING, OFF} #for anim use

#var jumpCloud = preload("res://special_effects/particles/sweat.tscn") #Just integrate into the player at some point

######### MAIN #########

func _ready() -> void:
	$Coyote.timeout.connect(_when_coyote_over)
	$Coyote.one_shot = true
	#$StateTree.active = true
	double_jumped.connect(_when_double_jump)
	$WorldCol/AttackArea.area_entered.connect(_find_target)
	$FlapInterval.timeout.connect(_on_flap_interval_ended)
	$WorldCol/InteractRangeX.area_entered.connect(_on_touching_food)
	$SpriteScale/Skin.texture = player_skin
	$FaceScale/Face.texture = player_face
	set_state(states.IDLE)

func _physics_process(delta: float) -> void:
	
	#DIRECTION
	direction_and_facing(delta)
	
	#STATES (Anims)
	#state_updater() switch to this when complete
	state_manager()
	
	#JUMPING
	jump_processing(delta)
	
	#PLATFORMS
	if Input.is_action_pressed(button_down):
		set_collision_mask_value(6, false)
	else:
		set_collision_mask_value(6, true)
		
	#GROUND SLAM
	ground_slam()
	
	#GETTING FAT
	size_handler()
	
	#UPDATE INFO FOR NEXT FRAME REF - do NOT do this after move and slide
	was_grounded = is_on_floor()
	was_walled = is_on_wall()
	#prev_speed = speed -------------------TO BE REMOVED
	prev_velocity = velocity
	
	#player_col()
	#player_interaction()
	
	if current_state == states.DEAD:
		velocity = Vector2.ZERO
	
	####TEMP TEST
	#if $WorldCol/Headbounce.has_overlapping_bodies():
		#for body in $WorldCol/Headbounce.get_overlapping_bodies():
			#if body is CharacterBody2D and body.is_in_group("Player"):
				##made an index var to track players in export group
				#if body.index != index:
					#body.velocity.y += -100
	
	move_and_slide()
	


######### COMPONENTS ###########

func _on_touching_food(area: Area2D):
	if area.is_in_group("Food"):
		if area.find_child("Collect_this_item").can_collect:
			area.find_child("Collect_this_item").consume()
			var size_plus = float(area.find_child("Collect_this_item").calories)
			if size < max_size:
				size += size_plus / 100
				print("Adding to size: " + str(size_plus / 100))
	elif area.is_in_group("Item"):
		area.find_child("Collect_this_item").consume()
#func bounce_player(body: Node2D):
	#if body.is_in_group("Player"):
		#body.velocity.y += jump_vel / 2

#func _on_touched_enemy(body: Node2D):
	#current_state = states.DEAD

func size_handler():
	$SpriteScale.scale = Vector2(size, size)
	if size > 1.7:
		$FaceScale.scale = Vector2(size - .7, size - .9)
	else:
		$FaceScale.scale = Vector2(1,1)
	$WorldCol.scale = Vector2(size, size)

#### PLAYER COL ATTEMPTS #######
func player_col():
	for i in get_slide_collision_count():
		var col_info = get_slide_collision(i)
		var body = col_info.get_collider()
		if body is CharacterBody2D and body.is_in_group("Player"):
			
			
			
			#print(name + " collided with: ", col_info.get_collider().name)
			#if global_position.y >= body.global_position.y:
				##active pushing
				#if direction:
					##print(name + ": Got pushed actively")
					#body.received_push_direction = direction
				##passive push
				#elif received_push_direction:
					##print(name + ": Got pushed passively")
					#body.received_push_direction = received_push_direction
				##move the player with received push
				#velocity.x += received_push_direction * body.push_force
				##print("Push force: " + str(received_push_direction * body.push_force))
			
			
			
			#push player x axis
			if global_position.y > body.global_position.y:
				if direction:
					body.velocity.x += push_force * direction
					body.received_push_direction = direction
				elif received_push_direction:
					body.velocity.x += push_force * received_push_direction
					received_push_direction = 0
				print(received_push_direction * push_force)
					
				#Yeah screw that
				#var push_modifier = (max_size + (size - body.size)) * (100 / max_size)
				#print("(" + str(max_size) + " + (" + str(size) + " - " + str(body.size) + ")) * (100 / " + str(max_size) + ")")
				#print("push_modifier gen: " + str(push_modifier))
				#body.velocity.x += (push_force * (push_modifier / 100)) * direction
				#print(push_force * (push_modifier / 100))
				#print(str(global_position.y) + " > " + str(body.global_position.y))

func player_interaction():
	if interact_x.has_overlapping_bodies():
		for body in interact_x.get_overlapping_bodies():
			if body is CharacterBody2D and body.is_in_group("Player") and body.index != index:
				body.velocity.x += velocity.x
				print("Adding " + str(body.velocity.x) + " to my velocity of " + str(velocity.x))
#########

func direction_and_facing(delta: float):
	#DIRECTION, ACCEL, DECEL
	if $InputPass.is_stopped(): #INPUTPASS is for wall jumping, it will ignore directional input briefly after jumping off the wall
		direction = Input.get_axis(button_left, button_right) #-1 means left, 0 means no input, 1 means right (ONLY input)
	if direction: #and current_state != states.HURT:
		#accelerate
		if is_on_floor() and abs(velocity.x) < max_speed:
			velocity.x = lerpf(velocity.x, max_speed * direction, acceleration * delta)
			#velocity.x = max_speed * direction
		else:
			velocity.x = lerpf(velocity.x, max_speed * direction, (acceleration * delta) / 1.5)
			#velocity.x = (max_speed * direction) / 2
	else:
		#decelerate
		if is_on_floor():
			velocity.x = lerpf(velocity.x, 0.0, deceleration)
		else:
			#velocity.x = lerpf(velocity.x, 0.0, delta)
			pass
		
	#DIRECTION_FACING UPDATES WITH DIRECTION
	#going left
	if Input.get_axis(button_left, button_right) < 0 and direction_facing == 1:
		#velocity match
		if velocity.x <= 0 or not is_on_floor():
			direction_facing = -1
		#skidding
		elif is_on_floor():
			$SpriteScale/Skin.frame = 4
			$SkidParticles.emitting = true
	#going right
	elif Input.get_axis(button_left, button_right) > 0 and direction_facing == -1:
		#velocity match
		if velocity.x >= 0 or not is_on_floor():
			direction_facing = 1
		#skidding
		elif is_on_floor():
			$SpriteScale/Skin.frame = 4
			$SkidParticles.emitting = true
	
	#SPRITE ORIENTATION
	if direction_facing == 1:
		$SpriteScale/Skin.flip_h = false
		$FaceScale/Face.flip_h = false
	elif direction_facing == -1:
		$SpriteScale/Skin.flip_h = true
		$FaceScale/Face.flip_h = true

func _when_double_jump(): #AKA FLAP, STARTS FLAP INTERVAL
		current_state = states.DOUBLE_JUMP
		sfx.play_sound("struggle")
		$FlapInterval.start(flap_interval)
		can_flap = false
		#Input.start_joy_vibration(0, 0.5, 0.0, 0.25)
		#print("executed double jump")

func _on_flap_interval_ended(): #Includes buffer check
	can_flap = true
	if not $FlapBuffer.is_stopped():
		#copied from jump_processing double jump bc I didnt want to make another method
		velocity.y = 0
		velocity.y += jump_vel * 0.4
		#var ptc = jumpCloud.instantiate()
		#get_parent().add_child(ptc)
		#ptc.global_position = global_position + Vector2(0,-10)
		$Sweat.emitting = true
		double_jumped.emit()

func _when_coyote_over():
	#print("Coyote over")
	can_jump = false

func jump_processing(delta: float):
	
	#RESET JUMP
	if is_on_floor():
		can_jump = true
	
	##FAT SHAKE
	#if not was_grounded and is_on_floor_only() and size > 1.9:
		#GlobalVar.request_camera_shake()
	
	#START COYOTE TIMER
		#last frame was on ground, current frame not on ground
	if was_grounded == true and is_on_floor() == false and not Input.is_action_pressed(button_jump) and $Coyote.time_left <= 0:
		$Coyote.start(coyote_time)
	
	#JUMP INPUT
	if Input.is_action_just_pressed(button_jump) and can_jump and current_state != states.HURT:
		velocity.y = jump_vel
		can_jump = false
		
		#Weakens the jump on release
	elif Input.is_action_just_released(button_jump) and velocity.y < 0 and can_flap:
		velocity.y = jump_vel / 4
	
	##Player boost
	#if is_on_ceiling() and Input.is_action_pressed(button_jump): #this only goes off if player has upward velocity
			#var players_on_head:Array[Node2D] = $WorldCol/InteractRange.get_overlapping_bodies()
			#for body in players_on_head:
				#if body.is_in_group("Player"):
						#body.velocity.y = 0
						#body.velocity.y += jump_vel
						#$JumpBuffer.start(jump_buffer_time)
						##if velocity.y > 4 and can_jump: #falling or still
							##velocity.y += jump_vel
							##can_jump = false
	
	#WALL JUMP
	if is_on_wall_only() and Input.is_action_just_pressed(button_jump):# and direction:
			velocity.y = jump_vel * 0.75
			velocity.x = jump_vel * 1.2 * direction_facing
			direction_facing *= -1
			sfx.play_sound("wallkick")
	
	#JUMP SOUND MIN PLAYING TIME
	if sfx.last_sound_name == "jump" and Input.is_action_just_released(button_jump) and velocity.y < 0 and can_flap:
		await get_tree().create_timer(0.1).timeout #min playing time
		if sfx.last_sound_name == "jump":
			sfx.stop()
	
	#JUMP BUFFERING
	if Input.is_action_just_pressed(button_jump) and not is_on_floor():
		$JumpBuffer.start(jump_buffer_time)
		#last frame off ground, current frame on ground, buffer running
	if not was_grounded and is_on_floor() and not $JumpBuffer.is_stopped():
		velocity.y = jump_vel
		can_jump = false
		sfx.play_sound("jump")
		current_state = states.JUMPING
	
	#WALL PROCESSING
	#if $WorldCol/WallChecks/Right.has_overlapping_bodies():
		#var bodycheck = $WorldCol/WallChecks/Right.get_overlapping_bodies()
		#var times = 1 #for debugging
		#for i in bodycheck:
			#if i is TileMapLayer:
				#on_right_wall = true
				#pass
			#print("Iterated wall check " + str(times) + " times")
			#times += 1
	#else:
		#on_right_wall = false
	
	#GRAVITY AND WALLSLIDE
	if not was_walled and on_right_wall or not was_walled and on_left_wall:
		#print($WorldCol/InteractRange.get_overlapping_bodies())
		if velocity.y > 0:
			velocity.y = 0
		
		#Adapt direction on wall touch
		if prev_velocity.x > 0:
			direction_facing = 1
		elif prev_velocity.x < 0:
			direction_facing = -1
		else:
			print_debug("Player hit wall: Prev velocity was 0")
		
		velocity.x = 0
	
	if not is_on_floor():
		if not current_state == states.WALL:
			gravity_multiplier = 1
		elif current_state == states.WALL:
			gravity_multiplier = 0.25
			
		velocity += get_gravity() * gravity_multiplier * delta
		
	#DOUBLE JUMP / FLAP + BUFFER
		if Input.is_action_just_pressed(button_flap) and can_flap and $Coyote.is_stopped():
			velocity.y = 0
			velocity.y += jump_vel * 0.4
			#extra_jumps -= 1 ---------------------EXTRA JUMPS TURNED OFF
			#var ptc = jumpCloud.instantiate()
			#get_parent().add_child(ptc)
			#ptc.global_position = global_position + Vector2(0,-10)
			$Sweat.emitting = true
			#print("Double jump input")
			double_jumped.emit()
		elif Input.is_action_just_pressed(button_flap) and not can_flap and $Coyote.is_stopped():
			$FlapBuffer.start(flap_buffer_time)
			print("Started flap buffer")

func ground_slam(): #Disabled for now
	#if Input.is_action_pressed("down") and not is_on_floor():
		#gravity_multiplier = 2
	#else:
		#gravity_multiplier = 1
	pass

############## STATE MANAGEMENT ##############

### UNIMPLEMENTED ############
func set_state(newState: int):
	current_state = newState
func state_updater(): #call in physics process
	match current_state:
		0: ##IDLE
			state_idle()
		1: ##WALK
			state_walk()
		2: ##JUMP
			state_jump()
		3: ##TOUCHDOWN (shouldnt need this in future, just make it a landing anim )
			pass
		4: ##EATING
			pass
		5: ##DEAD
			pass
		6: ##DOUBLE_JUMP
			pass
		7: ##WALL
			pass
		8: ##HURT
			pass
		9: ##FALL
			state_fall()

func state_idle():
	pass
	### EXITS
	# Walk
	if direction and is_on_floor() and not $StatePlayer.current_animation == "Jump_end" and not Input.is_action_just_pressed(button_jump):
		set_state(states.WALKING)
	# Jump
	if was_grounded and is_on_floor() and Input.is_action_just_pressed(button_jump) or not $Coyote.is_stopped() and Input.is_action_just_pressed(button_jump):
			set_state(states.JUMPING) #Also set in buffering
			sfx.play_sound("jump")
	# Fall
	if not was_grounded and not is_on_floor() and velocity.y > 0:
		set_state(states.FALLING)
func state_walk():
	pass
func state_jump():
	pass
func state_fall():
	pass
##############################

# FOR ANIMS AND SOUND, IN USE
func state_manager():
	#Order logic: should the listed action interrupt the action below it?
	
	##### STATE SETTER
	
	if current_state != states.HURT and current_state != states.DEAD: #Set by hurt() which is calle dby enemies and traps
		
		#jumping off ground
		if was_grounded and is_on_floor() and Input.is_action_just_pressed(button_jump) or not $Coyote.is_stopped() and Input.is_action_just_pressed(button_jump):
			current_state = states.JUMPING #Also set in buffering
			sfx.play_sound("jump")
		
		#falling
		if not was_grounded and not is_on_floor() and velocity.y > 20:
			current_state = states.FALLING
		
		#hit ground
		if not was_grounded and is_on_floor(): #and not $StatePlayer.current_animation == "Jump_end":
			current_state = states.TOUCHDOWN
			sfx.play_sound("land")
		
		#walking
		elif direction and is_on_floor() and not $StatePlayer.current_animation == "Jump_end" and not Input.is_action_just_pressed(button_jump):
			current_state = states.WALKING
			sfx.play_sound("walk")
		
		#idle
		elif !direction and is_on_floor() and not Input.is_action_just_pressed(button_jump) and not $StatePlayer.current_animation == "Jump_end":
			current_state = states.IDLE
		
		#hugging wall - player is touching a wall while descending
		elif on_left_wall or on_right_wall:
			if velocity.y > 0 and not Input.is_action_just_pressed(button_jump):# and direction: #downward velocity
				current_state = states.WALL
		##releasing wall - player moved off the wall
		#elif was_walled and is_on_wall_only() and velocity.y >= 0 and not Input.is_action_pressed(button_jump):# and !direction:
			#current_state = states.FALLING
		#falling off wall -
		elif was_walled and not is_on_wall() and velocity.y >= 0 and not Input.is_action_pressed(button_jump):
			current_state = states.FALLING
		#jumping off wall
		elif is_on_wall_only() and velocity.y >= 0 and Input.is_action_just_pressed(button_jump) or is_on_wall_only() and velocity.y >= 0 and not $JumpBuffer.is_stopped():
			current_state = states.JUMPING
			$InputPass.start(input_pass_time)

	
	#SKIDDING
	if current_state == states.TOUCHDOWN and is_on_floor() and velocity.x != 0:
		$SkidParticles.emitting = true
		#sfx.play_sound_until_done(sfx.slide)
	elif current_state == states.HURT and is_on_floor() and velocity.x != 0:
		$SkidParticles.emitting = true
	else:
		$SkidParticles.emitting = false

	if current_state == states.WALL:
		if direction_facing == 1:
			$WallSkid.position.x = 9
		elif direction_facing == -1:
			$WallSkid.position.x = -9
		$WallSkid.emitting = true
	else:
		$WallSkid.emitting = false
	
	#ANIM MATCHING
	match current_state:
		0: #IDLE
			$StatePlayer.play("Idle")
		1: #WALK
			$StatePlayer.play("Walking")
		2: #JUMP
			$StatePlayer.play("Jump_start")
		3: #TOUCHDOWN (when hitting ground)
			$StatePlayer.play("Jump_end")
		4: #EAT
			pass
		5: #DEAD
			pass
		6: #DOUBLE JUMP
			if direction_facing == 1 and not can_flap: #right
				$StatePlayer.play("Double_jump")
			elif direction_facing == -1 and not can_flap: #left
				$StatePlayer.play("Double_jump_backwards")
		7: #HURT
			pass
		8: #WALL
			$StatePlayer.play("Wall")
		9: #FALLING
			if $StatePlayer.assigned_animation != "Falling" and not was_grounded and not is_on_floor() and velocity.y > 20:
				$StatePlayer.play("Falling")

############ COMBAT ###########

func _find_target(area: Area2D):
	if area.is_in_group("Squishable"):
		area.get_parent().clobbered()
		#$Pow.global_position = area.get_parent().global_position - global_position
		$Pow.emitting = true
		if Input.is_action_pressed(button_jump) or Input.is_action_pressed(button_flap):
			velocity.y = 0
			velocity.y += jump_vel * 1.25
		else:
			velocity.y = 0
			velocity.y += jump_vel * 0.75

func hurt():
	if current_state != states.DEAD:
		current_state = states.HURT #basically just overrides statemachine states and anims
	if size > 1.4:
		size = 1
		sfx.play_sound("hurt")
		activate_inv_frames()
		$StatePlayer.play("Hurt")
		await $StatePlayer.animation_finished
		current_state = states.IDLE
	else:
		knockout()

func knockout(): #dedicated "death" handler
	set_collision_layer_value(4, false) #disables player-on-player col
	set_collision_layer_value(5, false) #disables camera tracking
	$WorldCol/AttackArea/CollisionShape2D.set_deferred("disabled", true)
	current_state = states.DEAD #Must be placed above signal so the player_setup can count dead players right
	GlobalVar.player_died.emit()
	sfx.play_sound("explode")
	$StatePlayer.play("Explode")
	await $Splode.finished
	disable()

func activate_inv_frames():
	if current_state != states.DEAD:
		set_collision_layer_value(4, false)
		$Inv.play("standard")
		await $Inv.animation_finished
		set_collision_layer_value(4, true)

func disable(hide: bool = true, can_revive: bool = true):
	if not can_revive:
		current_state = states.OFF
	if hide:
		hide()
	set_deferred("process_mode", PROCESS_MODE_DISABLED)

func enable():
	if not GlobalVar.paused:
		process_mode = PROCESS_MODE_INHERIT
		set_collision_layer_value(4, true)
		set_collision_layer_value(5, true)
		$WorldCol/AttackArea/CollisionShape2D.disabled = false
		$WorldCol.disabled = false
		size = 1
		show()

#//
