extends Timer

###.. means parent node
@onready var map = $".."
var spawner: PackedScene = preload("res://scenes/items/old/food.tscn")
var dropper: PackedScene = preload("res://scenes/items/old/drop.tscn")
@onready var subtimer = $subtimer

@export var badfooddata:Resource = preload("res://Resources/badfood.tres")
@export var superfooddata:Resource = preload("res://Resources/superfood.tres")
@export var spikedata:Resource = preload("res://Resources/spike.tres")
@export var bluefooddata:Resource = preload("res://Resources/bluefood.tres")
@export var largefooddata:Resource = preload("res://Resources/largefood.tres")
@export var largebadfooddata:Resource = preload("res://Resources/largebadfood.tres")

#@export var item_array: Array[Resource] = []
@export var current_foodset: Array[Resource]

func _ready():
	current_foodset = GlobalVar.foodset

#func gen_type():
	#
	#var weighted_sum = 0
	#
	#for n in foodtypes:
		#weighted_sum += foodtypes[n]
		#
	#var item = randi_range(0, weighted_sum)
	#
	#for n in foodtypes:
		#if item <= foodtypes[n]:
			#return n
		#item -= foodtypes[n]

func _process(_delta):
	pass

func _on_timeout():
	
	if GlobalVar.death_controller == false:
		var temp_position = Vector2(randi_range($"..".min_playable_x,$"..".max_playable_x), randi_range($"..".min_playable_y,$"..".max_playable_y))
		var foodPicker = FoodPicker.new()
		var positioner = spawner.instantiate()
		var temp_dropper = dropper.instantiate()
		positioner.position = temp_position
		temp_dropper.position = temp_position
		map.add_child(temp_dropper)
		map.add_child(positioner)
		spawner = foodPicker.pick_item(current_foodset)
		#print(foodPicker.pick_item(current_foodset))
	randomize()
	wait_time = randf_range(1.0,6.0) / GlobalVar.production_rate #12 badoofd, 5 superfood, 8 spike
	#print("Next in: " + str(wait_time) + " seconds")
	#print(GlobalVar.update3, GlobalVar.update15, GlobalVar.update25)
	
