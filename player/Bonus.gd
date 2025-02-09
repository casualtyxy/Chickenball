extends Timer

var sfx_firepower = preload("res://audio/sounds/FirePower.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../bonusfire".visible = true
	$"../SFXOverlay".stream = sfx_firepower
	$"../SFXOverlay".play()
	GlobalVar.health = GlobalVar.max_health
	#$"..".move_speed = 140
	print(GlobalVar.bonus_active)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if time_left <= 3.0 and $"../bonusfire".animation != "blinking":
		$"../bonusfire".play("blinking")
	elif time_left > 3.0:
		$"../bonusfire".play("default")
	GlobalVar.energy = 50


func _on_timeout():
	GlobalVar.bonus_active = false
	$"../bonusfire".hide()
	#$"..".move_speed = 120
	queue_free()
