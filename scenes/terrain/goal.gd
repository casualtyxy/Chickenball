extends StaticBody2D

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Goal.body_entered.connect(_on_enter)

func _on_enter(body: Node2D):
	if body is CharacterBody2D:
		if body.is_in_group("Player"):
			GlobalVar.request_camera_shake()
			if not active:
				active = true
				await get_tree().create_timer(3.0).timeout # wait 3 sec for other players
				GlobalVar.finishLevel(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
