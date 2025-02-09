extends Node
class_name FoodPicker

#var food = preload("res://scenes/items/food.tscn")
#var badfood = preload("res://scenes/items/badfood.tscn")
#var superfood = preload("res://scenes/items/superfood.tscn")
#var bluefood = preload("res://scenes/items/bluefood.tscn")
#var spike = preload("res://scenes/items/spike.tscn")
#var largefood = preload("res://scenes/items/largefood.tscn")

#var food_weight = 20
#var badfood_weight = 10
#var superfood_weight = 3
#var bluefood_weight = 0
#var spike_weight = 0
#
#var largefood_weight = 0

#var food_weight_list: Array = [food_weight, badfood_weight, superfood_weight, bluefood_weight, spike_weight]

@export var fooddatalist: Array[Resource] = []

#I don't get this at all I just followed tutorial, all resources here are from tutorial
func pick_item(item_array: Array = fooddatalist):
	var chosen_value = null
	if item_array.size() > 0:
		#Calculate overall chance, is this the weight sum?
		var overall_chance: int = 0
		for item in item_array:
			if item.can_pick:
				overall_chance += item.PICK_CHANCE
		#Gen rand number
		var random_number = randi() % overall_chance #Overallchance creates a rand num from 0 to overall chance
		#Pick rand item
		var offset: int = 0
		for item in item_array:
			if item.can_pick and random_number < item.PICK_CHANCE + offset:
				chosen_value = item.VALUE
				break
			else:
				offset += item.PICK_CHANCE
	#return value
	return chosen_value
	
#func gen_food_level_3():
	#randomize()
	#
	#var sum = 33
	#var randnum = randi_range(0, sum)
	#
	#if randnum >= sum - superfood_weight:
		#return superfood
	#elif randnum >= sum - badfood_weight:
		#return badfood
	#elif randnum >= sum - food_weight:
		#return food
	#else:
		#return food
