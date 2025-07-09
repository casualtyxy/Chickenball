class_name Chicklet extends CharacterBody2D

@export var bounce_force:float = 240.0
@export var gravity_multiplier:float = 1
@export var max_speed:float = 100
##Obtained through dispenser to revive a player I think
@export var bonus_reward:bool = false
#Index of the player to follow, less than 0 means none
#@export var bound_to_player_index:int = -1
@export var bound_player:CharacterBody2D
@export var max_distance_to_player = 40.0
@export var max_vertical_distance_to_player = 240.0
@export var floor_check_enabled:bool = true

var direction = 1
##Chicklet is zooming back to player vertically
var recovering_y:bool = false
##Distance from bound player's exact y pos at which the chicklet says "ok I'm close enough"
var recovering_y_threshold = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func adopt_check(body: Node2D):
	if body is CharacterBody2D and bound_player == null:
		if body.is_in_group("Player"):
			#bound_to_player_index = body.index
			bound_player = body
			print("bound player: " + str(bound_player) + " | index: " + str(bound_player.index))
			$"1up".emitting = true
			max_speed = bound_player.max_speed

func floor_check(body: Node2D):
	if body is TileMapLayer and floor_check_enabled:
		velocity.y = 0
		velocity.y -= bounce_force

func follow_player(delta: float):
	if bound_player != null:
		#X
		if global_position.x - bound_player.global_position.x > max_distance_to_player:
			velocity.x = lerpf(velocity.x, max_speed * -1, 4 * delta)
		elif global_position.x - bound_player.global_position.x < max_distance_to_player * -1:
			velocity.x = lerpf(velocity.x, max_speed, 4 * delta)
		else:
			velocity.x = lerpf(velocity.x, 0, 8 * delta)
		
		#Too low
		if global_position.y - bound_player.global_position.y > max_vertical_distance_to_player * -1:
			if not recovering_y:
				#floor_check_enabled = false
				recovering_y = true
				print("Too far! Distance " + str(global_position.y - bound_player.global_position.y))
			elif recovering_y:
				if abs(bound_player.global_position.y - global_position.y) > recovering_y_threshold:
					print("Recovering...")
					#global_position.y = lerpf(global_position.y, bound_player.global_position.y, 7 * delta)
					velocity.y *= max_speed * -1 * delta
				else:
					recovering_y = false
					print("Stopped recovery")

func face_player():
	if bound_player != null:
		if global_position.x > bound_player.global_position.x:
			direction = -1
		elif global_position.x < bound_player.global_position.x:
			direction = 1
	if direction == 1:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in $Area2D.get_overlapping_bodies():
		floor_check(body)
		adopt_check(body)
	velocity += get_gravity() * gravity_multiplier * delta
	follow_player(delta)
	face_player()
	
	move_and_slide()
