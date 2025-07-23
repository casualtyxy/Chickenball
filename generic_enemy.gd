class_name GenericEnemy extends CharacterBody2D

@export var has_ai:bool = false

func _on_zone_entered():
	has_ai = true

#May or may not use this class
