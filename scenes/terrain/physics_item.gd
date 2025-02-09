extends RigidBody2D

@export var item:PackedScene

func _ready() -> void:
	$Timer.timeout.connect(_on_timeout)

func set_packed_scene():
	if item != null:
		for i in $ItemSlot.get_child_count():
			$ItemSlot.get_child(i).queue_free()
		var add = item.instantiate()
		$ItemSlot.call_deferred("add_child", add)
		call_deferred("find_child", "Collect_this_item", true)
	else:
		print_debug("Warning: No item stored in this dispenser")

func launch(power: float, spread: float):
	
	spread *= randf_range(1.0,4.0)
	spread = spread * 10.0
	
	var throw_direction
	if randi_range(0, 1) == 0:
		throw_direction = -1
	else:
		throw_direction = 1
	
	apply_impulse(Vector2(spread * throw_direction, power), Vector2(spread, global_position.y + 12))
	

func _on_timeout():
	if $ItemSlot.get_child_count() == 0:
		queue_free()
