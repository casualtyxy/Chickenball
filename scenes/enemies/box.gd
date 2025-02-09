extends CharacterBody2D

var player
var direction
var speed = 120

func _ready() -> void:
	await get_parent()

func check_for_player() -> bool:
	if get_tree().has_group("Player"):
		return true
	else:
		return false

func _physics_process(delta: float) -> void:
	if check_for_player():
		$NavigationAgent2D.target_position = GlobalVar.player.global_position
		direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
