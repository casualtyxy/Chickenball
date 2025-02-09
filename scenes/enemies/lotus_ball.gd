extends Area2D

var faces = [preload("res://art/enemies/lotusball.png"),preload("res://art/enemies/lotusball2.png"),preload("res://art/enemies/lotusball3.png"),preload("res://art/enemies/lotusball4.png"),preload("res://art/enemies/lotusball5.png")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(shield)
	$texture.texture = faces.pick_random()
	#if $AnimationPlayer.is_playing() == false:
		#$AnimationPlayer.play("counterspin")

func reset_rot():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("counterspin")

func shield(area: Area2D):
	if area.is_in_group("Durian"):
		area.explode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
