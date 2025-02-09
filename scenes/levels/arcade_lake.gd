extends Node2D

var min_playable_x
var max_playable_x
var min_playable_y
var max_playable_y

var huckerworm:PackedScene = preload("res://scenes/enemies/huckerworm.tscn")
@onready var first_player = get_tree().get_first_node_in_group("Player")
@onready var bounds_section = $Bounds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bounds.area_entered.connect(_out_of_bounds)
	$HazardSpawner.timeout.connect(_on_timeout)
	
	min_playable_x = -167
	max_playable_x = 672
	min_playable_y = 48
	max_playable_y = 720
	
	#$"../Autosave".queue_free()

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(GlobalVar.mobs_defeated_arcade)
	pass
