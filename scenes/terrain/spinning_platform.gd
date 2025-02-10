extends StaticBody2D

@onready var plank: RigidBody2D = $Bar

@export_group("Rotation")
@export var rotation_enabled: bool = false
@export_enum("Constant", "Physics") var rotation_type: int
@export var max_rotation_speed := 400.0
@export var rotation_acceleration := 5.0
@export var rotation_deceleration := 5.0

var left_top_passengers:Array
var right_top_passengers:Array
var left_bottom_passengers:Array
var right_bottom_passengers:Array
var rot_vector := Vector2(0,0) #x-left, y-right, x is lefty loosey
var final_rot_dir := 0
var active_rotation_speed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	#prevent over-winding and snap to 0
	if plank.rotation_degrees == 180.0 or plank.rotation_degrees == -180.0:
		rotation_degrees = 0.0
		print("360 rot passed, reset to 0")
	if plank.rotation_degrees < 0.01 and plank.rotation_degrees > -0.01 and plank.rotation_degrees != 0.00000000000000:
		rotation_degrees = 0.00000000000000
		#print("dragging out between 0.01 and -0.01, snapped to 0")
	
	if rotation_enabled:
		if rotation_type == 1:
			left_top_passengers = $Bar/TL.get_overlapping_bodies()
			right_top_passengers = $Bar/TR.get_overlapping_bodies()
			left_bottom_passengers = $Bar/BL.get_overlapping_bodies()
			right_bottom_passengers = $Bar/BR.get_overlapping_bodies()
	
			var has_x_weight = false # left
			var has_y_weight = false # right
			for i in left_top_passengers:
				if i is CharacterBody2D:
					has_x_weight = true
			for i in right_top_passengers:
				if i is CharacterBody2D:
					has_y_weight = true
			for i in left_bottom_passengers:
				if i is CharacterBody2D:
					has_y_weight = true
			for i in right_bottom_passengers:
				if i is CharacterBody2D:
					has_x_weight = true
			
			if has_x_weight == true:
				rot_vector.x = 1
			else:
				rot_vector.x = 0
			if has_y_weight == true:
				rot_vector.y = 1
			else:
				rot_vector.y = 0
	
			if rot_vector.x > rot_vector.y:
				final_rot_dir = -1
			elif rot_vector.x < rot_vector.y:
				final_rot_dir = 1
			elif rot_vector.x == rot_vector.y:
				final_rot_dir = 0
			print("Final rot dir: " + str(final_rot_dir))
			if rot_vector.x == 1 or rot_vector.y == 1: #there is weight present
				print("Weight present: Yes")
				#if final_rot_dir == 0:
					#pass
				if abs(active_rotation_speed) < max_rotation_speed:
					#active_rotation_speed = lerpf(active_rotation_speed, max_rotation_speed, delta * rotation_acceleration)
					active_rotation_speed += 1.0 * delta * rotation_acceleration
					print("Speed: " + str(active_rotation_speed) + " (Should not be above " + str(max_rotation_speed) + ")")
					plank.rotation_degrees += 1 * delta * active_rotation_speed * final_rot_dir
				
			elif plank.rotation_degrees != 0 or plank.rotation_degrees != 180 or plank.rotation_degrees != -180: # no weight and plank is not flat
				print("Weight present: No")
				if active_rotation_speed > 0:
					active_rotation_speed -= 1.0 * delta * rotation_deceleration
					##active_rotation_speed = lerpf(active_rotation_speed, 0.0, delta * rotation_deceleration)
					##plank.rotation_degrees -= 1 * delta * active_rotation_speed * final_rot_dir
					##plank.rotation_degrees = lerpf(plank.rotation_degrees, 0.0, delta * rotation_deceleration)
				plank.rotation_degrees -= plank.rotation_degrees / 100
				print("Rot degrees: " + str(plank.rotation_degrees))
				#rot_vector = Vector2.ZERO
