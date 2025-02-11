extends StaticBody2D

@onready var plank: RigidBody2D = $Bar

@export_group("Spinning Platform")
@export var rotation_enabled: bool = true
@export_enum("Physics", "Constant") var rotation_type: int
#@export var max_rotation_speed := 400.0
@export var max_torque := 40000.0
@export var rotation_acceleration := 5.0
@export var rotation_deceleration := 5.0
@export var rotation_speed := 120.0
@export var rotation_direction := -1

var left_top_passengers:Array
var right_top_passengers:Array
var left_bottom_passengers:Array
var right_bottom_passengers:Array
var plank_weights := Vector2.ZERO #left, right. This is used to determine the direction of spin after all areas have read
var prev_torque := 0.0
#var rot_vector := Vector2(0,0) #x-left, y-right, x is lefty loosey
#var final_rot_dir := 0
#var active_rotation_speed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Bar/TL.body_entered.connect(_TL_land)
	#$Bar/TR.body_entered.connect()
	#$Bar/BL.body_entered.connect()
	#$Bar/BR.body_entered.connect()
	pass

##FIRST LANDING IMPULSE -------- Does nothing lol
#func _TL_land(body: Node2D):
	##Physics-only function
	#if rotation_type == 0 and body.is_in_group("Player"):
		#if rotation_direction == 1: #If rot dir is moving against where player landed, combat with impulse
			#plank.constant_torque = 0.0
			#plank.apply_torque_impulse(-1.0 * body.size * 10)
		#
#func _TR_land(body: Node2D):
	#pass
#func _BL_land(body: Node2D):
	#pass
#func _BR_land(body: Node2D):
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if rotation_type == 1: #CONSTANT
		if abs(plank.constant_torque) < max_torque:
			plank.add_constant_torque(rotation_speed * rotation_direction)
		else:
			plank.constant_torque = max_torque * rotation_direction
	
	###############################################
	
	elif rotation_type == 0: #PHYSICS
		
		#In this mode, for info and checking purposes only
		if prev_torque < plank.constant_torque:
			rotation_direction = 1
		elif prev_torque > plank.constant_torque:
			rotation_direction = -1
		
		if abs(plank.constant_torque) > max_torque:
			plank.constant_torque = max_torque * rotation_direction
		
		left_top_passengers = $Bar/TL.get_overlapping_bodies()
		var has_TL = false
		for i in left_top_passengers:
			if i.is_in_group("Player"):
				has_TL = true
		if has_TL:
			plank.add_constant_torque(rotation_speed * -1)
		#else:
			#plank.constant_torque = 0.0
		
		right_top_passengers = $Bar/TR.get_overlapping_bodies()
		var has_TR = false
		for i in right_top_passengers:
			if i.is_in_group("Player"):
				has_TR = true
		if has_TR:
			plank.add_constant_torque(rotation_speed * 1)
		
		left_bottom_passengers = $Bar/BL.get_overlapping_bodies()
		var has_BL = false
		for i in right_bottom_passengers:
			if i.is_in_group("Player"):
				has_BL = true
		if has_BL:
			plank.add_constant_torque(rotation_speed * 1)
		
		right_bottom_passengers = $Bar/BR.get_overlapping_bodies()
		var has_BR = false
		for i in right_bottom_passengers:
			if i.is_in_group("Player"):
				has_BR = true
		if has_BR:
			plank.add_constant_torque(rotation_speed * -1)
		
		if not has_TL and not has_TR and not has_BL and not has_BR:
			if plank.rotation_degrees > 10.0:
				plank.add_constant_torque((rotation_speed / 2) * -1)
			elif plank.rotation_degrees < -10.0:
				plank.add_constant_torque((rotation_speed / 2) * 1)
			elif plank.rotation_degrees < 10.0 and plank.rotation_degrees > -10.0 or plank.rotation_degrees < 190.0 and plank.rotation_degrees > 170.0 or plank.rotation_degrees < -170.0 and plank.rotation_degrees > -190.0:
				plank.constant_torque = 0.0
		
		#UPDATE PREV FRAME INFO
		prev_torque = plank.constant_torque
	
	##prevent over-winding and snap to 0
	#if plank.rotation_degrees == 180.0 or plank.rotation_degrees == -180.0:
		#rotation_degrees = 0.0
		#print("360 rot passed, reset to 0")
	#if plank.rotation_degrees < 0.01 and plank.rotation_degrees > -0.01 and plank.rotation_degrees != 0.00000000000000:
		#rotation_degrees = 0.00000000000000
		##print("dragging out between 0.01 and -0.01, snapped to 0")
	
	#if rotation_enabled:
		#if rotation_type == 1:
			#left_top_passengers = $Bar/TL.get_overlapping_bodies()
			#right_top_passengers = $Bar/TR.get_overlapping_bodies()
			#left_bottom_passengers = $Bar/BL.get_overlapping_bodies()
			#right_bottom_passengers = $Bar/BR.get_overlapping_bodies()
	#
			#var has_x_weight = false # left
			#var has_y_weight = false # right
			#for i in left_top_passengers:
				#if i is CharacterBody2D:
					#has_x_weight = true
			#for i in right_top_passengers:
				#if i is CharacterBody2D:
					#has_y_weight = true
			#for i in left_bottom_passengers:
				#if i is CharacterBody2D:
					#has_y_weight = true
			#for i in right_bottom_passengers:
				#if i is CharacterBody2D:
					#has_x_weight = true
			#
			#if has_x_weight == true:
				#rot_vector.x = 1
			#else:
				#rot_vector.x = 0
			#if has_y_weight == true:
				#rot_vector.y = 1
			#else:
				#rot_vector.y = 0
	#
			#if rot_vector.x > rot_vector.y:
				#final_rot_dir = -1
			#elif rot_vector.x < rot_vector.y:
				#final_rot_dir = 1
			#elif rot_vector.x == rot_vector.y:
				#final_rot_dir = 0
			#print("Final rot dir: " + str(final_rot_dir))
			#if rot_vector.x == 1 or rot_vector.y == 1: #there is weight present
				#print("Weight present: Yes")
				#if abs(active_rotation_speed) < max_rotation_speed:
					#active_rotation_speed += 1.0 * delta * rotation_acceleration
					#print("Speed: " + str(active_rotation_speed) + " (Should not be above " + str(max_rotation_speed) + ")")
					##plank.rotation_degrees += 1 * delta * active_rotation_speed * final_rot_dir
					#plank.apply_torque(5.0 * final_rot_dir)
				#
			#elif plank.rotation_degrees != 0 or plank.rotation_degrees != 180 or plank.rotation_degrees != -180: # no weight and plank is not flat
				##print("Weight present: No")
				##if active_rotation_speed > 0:
					##active_rotation_speed -= 1.0 * delta * rotation_deceleration
					##
				##plank.rotation_degrees -= plank.rotation_degrees / 100
				#pass
