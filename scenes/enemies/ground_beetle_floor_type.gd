extends CharacterBody2D

#Ground beetles lack eyesight, they wander aimlessly in search of food. They do bite.

@export var speed: int
var previous_global_position = Vector2.ZERO

var has_ai = false

func _ready() -> void:
	$attackarea.body_entered.connect(attack)
	#$EnableZone.body_entered.connect(_on_zone_entered)
	$OnScreen.screen_entered.connect(_on_zone_entered)

func clobbered():
	call_deferred("disable_col") #YIPPEEEE
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
	#if body.is_in_group("Player"):
		#print("Found player")
	has_ai = true

func _physics_process(delta: float) -> void:
	if has_ai:
		run_ai(delta)

func run_ai(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = speed
	
	if velocity.x > 0:
		$Sprite.flip_h = true
	elif velocity.x < 0:
		$Sprite.flip_h = false
	
	move_and_slide()
	
	if previous_global_position == global_position:
		speed *= -1
	
	previous_global_position = global_position
