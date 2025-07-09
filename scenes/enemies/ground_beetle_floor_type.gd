class_name GroundBeetle_Floor extends CharacterBody2D

#Ground beetles lack eyesight, they wander aimlessly in search of food. They do bite.

@onready var left_ray: RayCast2D = $Raycasting/left
@onready var right_ray: RayCast2D = $Raycasting/right
@onready var left_down_ray: RayCast2D = $Raycasting/leftdown
@onready var right_down_ray: RayCast2D = $Raycasting/rightdown

@export var auto_start:bool = false
@export var speed: float = 35.0
##Used to follow. If greater than 0, this ground beetle will have its AI set to true at the same time as the beetle(s) it is linked to.
@export var id: int 
##Used to lead. If array has contents, beetles with the specified IDs will be turned on at the same time as this one
@export var link_ids: Array[int]

var previous_global_position = Vector2.ZERO

var direction = -1
var has_ai = false

func _ready() -> void:
	$attackarea.body_entered.connect(attack)
	#$EnableZone.body_entered.connect(_on_zone_entered)
	$OnScreen.screen_entered.connect(_on_zone_entered)
	if auto_start:
		has_ai = true
	GlobalVar.ground_beetle_activate_link.connect(receive_signal)

func clobbered():
	call_deferred("disable_col") #YIPPEEEE
	$Sound.pitch_scale = randf_range(1.0, 1.5)
	$Sound.play()
	$Sprite.hide()
	await $dead.finished
	queue_free()

func attack(body: Node2D):
	if body.is_in_group("Player"):
		body.hurt()
		#body.velocity.x += velocity.x * 2
		#body.velocity.y += body.jump_vel / 2

func disable_col():
	$dead.emitting = true
	$WorldCol.disabled = true
	$attackarea/Shape.disabled = true
	$weakarea/Shape.disabled = true

func _on_zone_entered():
	has_ai = true
	if link_ids.size() > 0:
		for i in link_ids:
			GlobalVar.ground_beetle_activate_link.emit(link_ids[i - 1])

func _physics_process(delta: float) -> void:
	if has_ai:
		run_ai(delta)

func run_ai(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = speed * direction
	
	if direction == 1:
		$Sprite.flip_h = true
	elif direction == -1:
		$Sprite.flip_h = false
	
	raycast_checks()
	
	move_and_slide()
	
	##old method for switching dir
	#if previous_global_position == global_position:
		#speed *= -1
	#
	#previous_global_position = global_position

func receive_signal(received_id: int):
	if id > 0 and not has_ai:
		if received_id == id:
			_on_zone_entered()

func raycast_checks():
	#left wall
	if left_ray.is_colliding() and direction == -1:
		direction = 0
		$Sprite.animation = "turn_wall"
		await get_tree().create_timer(1.25).timeout
		$Sprite.animation = "default"
		direction = 1
	#right wall
	elif right_ray.is_colliding() and direction == 1:
		direction = 0
		$Sprite.animation = "turn_wall"
		await get_tree().create_timer(1.25).timeout
		$Sprite.animation = "default"
		direction = -1
	#left cliff
	elif left_down_ray.is_colliding() and not right_down_ray.is_colliding() and direction == 1:
		direction = 0
		$Sprite.animation = "turn_cliff"
		await get_tree().create_timer(1).timeout
		$Sprite.animation = "default"
		direction = -1
	#left cliff
	elif not left_down_ray.is_colliding() and right_down_ray.is_colliding() and direction == -1:
		direction = 0
		$Sprite.animation = "turn_cliff"
		await get_tree().create_timer(1).timeout
		$Sprite.animation = "default"
		direction = 1
