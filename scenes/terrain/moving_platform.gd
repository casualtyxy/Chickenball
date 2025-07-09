extends Path2D

@export_enum("forward <- -> reverse", "linear ->", "<- swing ->", "don't loop") var loop_type: int = 0
@export var speed: float = 1.0
@export var auto_start:bool = true #false -> ill start on player contact

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if auto_start:
		start_loop()
	else:
		$AnimatableBody2D/ActivationZone.body_entered.connect(_on_contact)

func _on_contact(_body: Node2D):
	start_loop()

func start_loop():
	match loop_type:
		0: #forward reverse
			$AnimationPlayer.play("back_and_fourth", -1.0, speed, false)
		1: #linear
			$AnimationPlayer.play("forward", -1.0, speed, false)
		2: #swing
			$AnimationPlayer.play("swing", -1.0, speed, false)
		3: #no loop
			$AnimationPlayer.play("dont_loop", -1.0, speed, false)
			$AnimatableBody2D/ActivationZone.set_deferred("monitoring", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
