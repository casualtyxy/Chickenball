extends Node2D

var lotus:PackedScene = preload("res://scenes/enemies/lotus.tscn")
@onready var bounds_section = $Bounds
var mobs = [lotus]

var min_playable_x
var max_playable_x
var min_playable_y
var max_playable_y

func _out_of_bounds(area: Area2D):
	if area.is_in_group("Lotus"):
		area.get_parent().queue_free()
		await get_tree().create_timer(0.1).timeout
		_on_timeout()
	elif area.is_in_group("Item"):
		area.queue_free()
		await get_tree().create_timer(0.1).timeout
		$FoodTick._on_timeout()

func _on_timeout():
	randomize()
	var choosen_mob = mobs.pick_random()
	var new_hazard = choosen_mob.instantiate()
	add_child(new_hazard)
	#new_hazard.global_position = hazard_signs[randi_range(0,5)].global_position
	new_hazard.global_position = Vector2(randi_range(min_playable_x,max_playable_x),randi_range(min_playable_y,max_playable_y))
	$HazardSpawner.start(randi_range(3,6))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_playable_x = -120
	max_playable_x = 744
	min_playable_y = 456
	max_playable_y = 1272
	$Bounds.area_entered.connect(_out_of_bounds)
	$HazardSpawner.timeout.connect(_on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
