extends Camera2D

enum modes {NORMAL, STATIC}

#var pos_player_1 := Vector2.ZERO
#var pos_player_2 := Vector2.ZERO
#var pos_player_3 := Vector2.ZERO
#var pos_player_4 := Vector2.ZERO
#@export var player_1: PackedScene
#@export var player_2: PackedScene
#@export var player_3: PackedScene
#@export var player_4: PackedScene
@export var min_zoom := 0.9
@export var max_zoom := 1.3

var pos_players_x:Array = []#[pos_player_1.x, pos_player_2.x, pos_player_3.x, pos_player_4.x]
var pos_players_y:Array = []#[pos_player_1.y, pos_player_2.y, pos_player_3.y, pos_player_4.y]

var highest_x
var lowest_x
var highest_y
var lowest_y

#var rightmost_player_pos := Vector2(0,0)
#var leftmost_player_pos := Vector2(0,0)
#var highest_player_pos := Vector2(0,0)
#var lowest_player_pos := Vector2(0,0)
var prev_player_pos_check
var current_player_pos_check:Vector2
var right_side_offset = 140.0
var vertical_offset = 20.0
var current_mode = 0
#var distance_max_threshold = 180.0
#var distance_min_threshold = 85.0
var distance_threshold = 450.0
var prev_distance := 0.0
var current_distance := 0.0

var zoom_speed = 10

var temp

var should_zoom_out = false # temp

func players_distance_calculation():
	
	#if player_2 != null:
		#
		#if player_1.global_position.x > player_2.global_position.x:
			#rightmost_player = player_1
			#leftmost_player = player_2
		#else:
			#rightmost_player = player_2
			#leftmost_player = player_1
		#global_position.x = ((rightmost_player.global_position.x + right_side_offset) + leftmost_player.global_position.x) / 2
		#global_position.y = (rightmost_player.global_position.y + leftmost_player.global_position.y) / 2
		#
		#current_distance = leftmost_player.global_position.distance_to(rightmost_player.global_position)
		#
		#if current_distance > distance_max_threshold and prev_distance <= distance_max_threshold and $AnimationPlayer.assigned_animation != "zoom_out":
			#$AnimationPlayer.play("zoom_out")
		#elif current_distance <= distance_min_threshold and prev_distance > distance_min_threshold:
			#$ZoomInDelay.start(3.0)
		#
		#prev_distance = current_distance

	if GlobalVar.player_count > 1:
		pos_players_x.clear()
		pos_players_y.clear()
		#get every active player and store pos into respective arrays
		for i in GlobalVar.player_count:
			temp = "Player" + str(i + 1)
			var current_player:CharacterBody2D = get_parent().find_child(temp)
			
			if current_player.get_collision_layer_value(5): #If is on camera layer
				pos_players_x.append(current_player.global_position.x)
				pos_players_y.append(current_player.global_position.y)
			
			if i >= GlobalVar.player_count: #reset loop
				i = 0
			
		highest_x = pos_players_x.max()
		lowest_x = pos_players_x.min()
		highest_y = pos_players_y.min()
		lowest_y = pos_players_y.max()
		
		if highest_x != null and lowest_x != null:
			global_position.x = ((highest_x + right_side_offset) + lowest_x) / 2
			$Left.global_position.x = lowest_x
			$Right.global_position.x = highest_x
		if highest_y != null and lowest_y != null:
			global_position.y = ((highest_y + vertical_offset) + lowest_y) / 2
			$Left.global_position.y = lowest_y
			$Right.global_position.y = highest_y
		
			
			#if prev_player_pos_check != null:
				#if current_player_pos_check.x < prev_player_pos_check.x:
					#leftmost_player_pos = current_player_pos_check
					#print("Player " + str(i + 1) + " is behind Player" + str(i))
				#elif current_player_pos_check.x > prev_player_pos_check.x:
					#rightmost_player_pos = current_player_pos_check
					#print("Player " + str(i + 1) + " is ahead  Player" + str(i))
					#
				#if current_player_pos_check.y < prev_player_pos_check.y:
					#lowest_player_pos = current_player_pos_check
					##print("Current player is lowest")
				#elif current_player_pos_check.y > prev_player_pos_check.y:
					#highest_player_pos = current_player_pos_check
					##print("Current player is highest")
			#else:
				#print("Prev player pos is null, defaulting all values to Player" + str(i + 1))
				#rightmost_player_pos = current_player_pos_check
				#leftmost_player_pos = current_player_pos_check
				#highest_player_pos = current_player_pos_check
				#lowest_player_pos = current_player_pos_check
			#
			##print("Set prev pos check to current")
			#prev_player_pos_check = current_player_pos_check
			#
			#if i >= GlobalVar.player_count:
				#print("index reached Player" + str(i) + ", restarting...")
				#i = 0
		#
		#global_position.x = ((rightmost_player_pos.x + right_side_offset) + leftmost_player_pos.x) / 2
		#global_position.y = ((highest_player_pos.y + vertical_offset) + lowest_player_pos.y) / 2
		#
		#$Right.global_position = rightmost_player_pos
		#$Left.global_position = leftmost_player_pos
		#
		#current_distance = (highest_x + lowest_x) / 2
		##print("Distance between players is " + str(current_distance))
		#
		#if current_distance > distance_max_threshold and prev_distance <= distance_max_threshold and $AnimationPlayer.assigned_animation != "zoom_out":
			#$AnimationPlayer.play("zoom_out")
		#elif current_distance <= distance_min_threshold and prev_distance > distance_min_threshold:
			#$ZoomInDelay.start(3.0)
		##
		#prev_distance = current_distance #----REPLACE WITH AREA2D TO DETECT WHEN PLAYERS LEAVE SMALL AREA?
		
		#print("Leftmost: " + str(leftmost_player_pos))
		#print("Rightmost: " + str(rightmost_player_pos))
		#print("Prev: " + str(prev_player_pos_check))
		#print("Current: " + str(current_player_pos_check))
		#print("Prev dist: " + str(prev_distance))
		#print("Current dist: " + str(current_distance))
		#print("Ended processing for current player\n")
	else:
		### Singleplayer
		global_position = get_parent().find_child("Player1").global_position

func dynamic_zoom(delta: float):
	if highest_x != null and highest_y != null and lowest_x != null and lowest_y != null:
		current_distance = Vector2(lowest_x, lowest_y).distance_to(Vector2(highest_x, highest_y))
	
		if current_distance < distance_threshold and zoom.x < max_zoom:
		
			zoom += Vector2(0.05,0.05) * delta * zoom_speed
		elif current_distance > distance_threshold and zoom.x > min_zoom:
		
			zoom -= Vector2(0.05,0.05) * delta * zoom_speed


func _zoom_in_delay_check():
	if current_distance < distance_threshold and $AnimationPlayer.assigned_animation != "zoom_in":
		$AnimationPlayer.play("zoom_in")

func enter_static():
	if $AnimationPlayer.assigned_animation != "zoom_out":
		$AnimationPlayer.play("zoom_out")

func _camera_mode_switch(mode: int):
	match mode:
		0:
			current_mode = modes.NORMAL
		1:
			current_mode = modes.STATIC

func _local_camera_shake():
	$AnimationPlayer.play("shake")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ZoomInDelay.timeout.connect(_zoom_in_delay_check)
	GlobalVar.camera_mode_changed.connect(_camera_mode_switch)
	GlobalVar.camera_shake.connect(_local_camera_shake)
	highest_x = get_parent().find_child("Player1").global_position.x
	lowest_x = get_parent().find_child("Player1").global_position.x
	highest_y = get_parent().find_child("Player1").global_position.y
	lowest_y = get_parent().find_child("Player1").global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	match current_mode:
		0: #NORMAL
			players_distance_calculation()
			dynamic_zoom(delta)
		1: #STATIC
			enter_static()
