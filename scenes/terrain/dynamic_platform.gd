extends Node2D

@onready var plank: AnimatableBody2D = $Bar

@export_group("Rotation")
@export var rotation_enabled: bool = false
@export_enum("Constant", "Physics") var rotation_type: int
@export var rotation_speed = 60 #how fast thang spins


var left_side_passengers
var right_side_passengers
var rot_vector := Vector2(0,0) #x-left, y-right

var final_rot_dir := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if rotation_enabled:
		if rotation_type == 1:
			left_side_passengers = $AnimatableBody2D/left.get_overlapping_bodies()
			right_side_passengers = $AnimatableBody2D/right.get_overlapping_bodies()
	
			for i in left_side_passengers:
				if i is CharacterBody2D:
					rot_vector.x += 1
			for i in right_side_passengers:
				if i is CharacterBody2D:
					rot_vector.y += 1
	
			final_rot_dir = (rot_vector.x - rot_vector.y) * -1
	
			print(rot_vector)
			print(final_rot_dir)
			if rot_vector.x != 0 or rot_vector.y != 0:
				plank.rotation_degrees = lerp(plank.rotation_degrees, plank.rotation_degrees + final_rot_dir, delta * rotation_speed)
			elif plank.rotation_degrees != 0:
				plank.rotation_degrees = lerp(plank.rotation_degrees, 0.0, delta * rotation_speed)
	
		rot_vector = Vector2.ZERO
	
		print(rot_vector)
	
		print("End of process: " + str(final_rot_dir))
		print(plank.rotation_degrees)
