extends CharacterBody2D

@export var speed: float = 65.0
@export var update_time: float = 2

var has_ai = false
var direction:Vector2 = Vector2(0,-1)
var target:Node2D = null

func _ready() -> void:
	$weakarea.body_entered.connect(_on_weak_entered)
	$attackarea.body_entered.connect(_on_attack_entered)
	$OnScreen.screen_entered.connect(_on_zone_entered)

func _on_zone_entered():
	has_ai = true
	$Sprite.animation = "default"

func _physics_process(delta: float) -> void:
	
	if has_ai:
		run_ai(delta)
	
	move_and_slide()

func run_ai(delta:float) -> void:
	var target_list = $aggro.get_overlapping_bodies()
	for i in target_list:
		if i is CharacterBody2D and i.is_in_group("Player"):
			target = i
	
	if target:
		#negative speed is how we close in on the player rather than running away, incremented to simulate dumb pathfinding
		$Timer.start(update_time)
		velocity = (global_position - target.global_position).normalized() * Vector2(speed * -1, speed * -1)
		#arctangent converts vector points to radians
		#rotation = atan2((global_position - target.global_position).normalized().x, (global_position - target.global_position).normalized().y)
		await $Timer.timeout
		look_at(target.global_position)

func _on_weak_entered(body: Node2D):
	if body is CharacterBody2D and body.is_in_group("Player"):
		if body.global_position.y < global_position.y:
			clobbered()
		else:
			body.hurt()

func _on_attack_entered(body: Node2D):
	if body is CharacterBody2D and body.is_in_group("Player"):
		body.hurt()

func clobbered():
	call_deferred("disable_col") #YIPPEEEE
	$Sprite.hide()
	await $dead.finished
	queue_free()

func disable_col():
	$dead.emitting = true
	$WorldCol.disabled = true
	$attackarea/Shape.disabled = true
	$weakarea/Shape.disabled = true
