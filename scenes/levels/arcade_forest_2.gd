extends Node2D

var min_playable_x
var max_playable_x
var min_playable_y
var max_playable_y

var durian:PackedScene = preload("res://scenes/enemies/durian.tscn")
var huckerworm:PackedScene = preload("res://scenes/enemies/huckerworm.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_playable_x = -336
	min_playable_y = -144
	max_playable_x = 815
	max_playable_y = 1007
	$Bounds.area_entered.connect(_out_of_bounds)
	$HazardSpawner.timeout.connect(_on_timeout)
	#$"../Autosave".queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _out_of_bounds(area: Area2D):
	if not area.is_in_group("Player") and not area.is_in_group("Durian"):
		area.queue_free()
	if area.is_in_group("Huckerworm"):
		area.get_parent().queue_free()
		await get_tree().create_timer(0.1).timeout
		_on_timeout()

func _on_timeout():
	var new_hazard = huckerworm.instantiate()
	add_child(new_hazard)
	#new_hazard.global_position = hazard_signs[randi_range(0,5)].global_position
	new_hazard.global_position = Vector2(randi_range(min_playable_x,max_playable_x),randi_range(min_playable_y,max_playable_y))
	$HazardSpawner.start(randi_range(3,6))
