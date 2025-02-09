extends Sprite2D

var chance_to_dance := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chance_to_dance = randi_range(1,3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if chance_to_dance == 1:
		$AnimationPlayer.play("dance")
