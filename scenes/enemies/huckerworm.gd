class_name GummyWorm extends CharacterBody2D

##Bullet will fire in this direction (x)
@export var direction_x:int = -1
##Bullet will fire in this direction (y)
@export var direction_y:int = 0
##Shoot interval in seconds
@export var frequency:int = 2
##Default = Like normal, Random = Will always get a generated color, Color = define the color as seen below, No Random = will always be the specified default color
@export_enum("Default", "Random", "No Random") var color_mode:int
##The default spawn color
@export var default_color:Color = Color(0.961, 0.596, 0.733) #e1779f body, f598bb highlights, 9e4956 outline
##Not yet implemented
@export var default_gradient:Color = Color(0.267, 0.286, 0.337) #444956
##Yup we going crazy with this. They can technically fire out helpful items if I add it to the handler
@export var bullet:PackedScene
##How hard to launch it
@export var bullet_force:float = 50


var boomsound = [preload("res://audio/sounds/Explosion_long2.wav"),
preload("res://audio/sounds/Explosion_long.wav"),
preload("res://audio/sounds/Explosion_long3.wav")]
var bubblesound = [preload("res://audio/sounds/bubbles/bubble-2.wav"),
preload("res://audio/sounds/bubbles/bubble-3.wav"),
preload("res://audio/sounds/bubbles/bubble-4.wav"),
preload("res://audio/sounds/bubbles/bubble-7.wav")]

var has_ai = false
var shooting:bool = false

func _ready() -> void:
	$weakarea.body_entered.connect(clobbered)
	$OnScreen.screen_entered.connect(_on_zone_entered)
	createColor()

func _physics_process(_delta: float) -> void:
	if has_ai:
		run_ai()

func run_ai():
	goopy_body()
	passive_launching()

func _on_zone_entered():
	has_ai = true

func clobbered(body: Node2D):
	if body is CharacterBody2D:
		if body.is_in_group("Player") and body.velocity.y > -1:
			$AnimPlayer.play("squish")
			$Boom.stream = boomsound.pick_random()
			$Boom.play()
			await get_tree().create_timer(0.4).timeout
			queue_free()

func goopy_body():
	var bodies = $Body/slowarea.get_overlapping_bodies()
	for i in bodies:
		if i is CharacterBody2D:
			if i.is_in_group("Player"):
				i.velocity.x /= 2
				i.velocity.y /= 2

func passive_launching():
	if bullet == null:
		#print_debug("Worm not armed")
		return
	
	if not shooting:
		shooting = true
		$AnimPlayer.play("spit")
		await get_tree().create_timer(0.6).timeout
		var nowbullet = bullet.instantiate()
		$"..".add_child(nowbullet)
		nowbullet.global_position = $BulletPoint.global_position
		
		bullet_handler(nowbullet)
		
		await get_tree().create_timer(frequency).timeout
		shooting = false

func bullet_handler(bullet: Node2D):	
	if bullet is Area2D:
		print_debug("Forgot how to handle this one already and deleted the code argargargarg")
	elif bullet is RigidBody2D:
		bullet.apply_central_impulse(Vector2(direction_x * bullet_force, direction_y * bullet_force))

func createColor():
	var default_color_outline = default_color
	var new_color = Color.from_hsv(randf(), 0.33, 1, 0.6) #Color8(randColorValue, randColorValue, randColorValue, 175)
	var new_color_outline = new_color
	
	new_color_outline.a = 255
	default_color.a = 153
	default_color_outline.a = 255
	
	var selectionChance = randi_range(1,3)
	
	$Body/Gradient.color = default_color
	
	match color_mode:
		0: #default
			if selectionChance == 3:
				$Body/Gel.self_modulate = new_color
				$Body/Outline.self_modulate = new_color_outline
				$Body/Eyes.self_modulate = new_color_outline
			else:
				$Body/Gel.self_modulate = default_color
				$Body/Outline.self_modulate = default_color_outline
				$Body/Eyes.self_modulate = default_color_outline
		1: #force random
			$Body/Gel.self_modulate = new_color
			$Body/Outline.self_modulate = new_color_outline
		2: #no random
			$Body/Gel.self_modulate = default_color
			$Body/Outline.self_modulate = default_color_outline
