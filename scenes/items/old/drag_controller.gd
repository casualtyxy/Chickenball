extends Area2D

class_name DragController

#@export var item = Sprite2D

var selected = false
var saved_pos

func _ready() -> void:
	$"../AnimationPlayer".play("spawn")
	saved_pos = $"..".global_position

func _process(_delta: float) -> void:
	if selected:
		$"..".global_position = get_global_mouse_position()
	else:
		#print("not dragging")
		if has_overlapping_areas():
			var checklist:Array[Area2D] = get_overlapping_areas()
			#print(checklist)
			if checklist[0].get_child_count() < 3:
				checklist[0].add_child(load("res://scenes/items/farm/small_seed.tscn").instantiate())
				$"..".queue_free()
			else:
				$"..".global_position = saved_pos
		else:
			$"..".global_position = saved_pos
	

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_pressed("click_left") and GlobalVar.dragging_item == false:
		selected = true
		GlobalVar.dragging_item = true
		print(GlobalVar.dragging_item)
	elif not Input.is_action_pressed("click_left"):
		selected = false
		GlobalVar.dragging_item = false
		print(GlobalVar.dragging_item)
