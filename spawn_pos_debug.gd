extends Node2D

@export var enabled:bool = true

func _ready() -> void:
	if enabled:
		var players:Node2D = get_parent().find_child("PlayerSetup")
		
		if players != null:
			players.global_position = global_position
		else:
			print_debug("PROBLEM: PlayerSetup was not found in the tree")
