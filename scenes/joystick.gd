extends Node2D

var posVect: Vector2
var pressing = false
var maxDist = 100
var deadzone = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.button_down.connect(_when_down)
	$Button.button_up.connect(_when_up)

func _when_down():
	pressing = true
func _when_up():
	pressing = false

func calculateVect():
	if abs(($Joy.global_position.x - global_position.x)) >= deadzone:
		posVect.x = ($Joy.global_position.x - global_position.x) / maxDist
	if abs(($Joy.global_position.y - global_position.y)) >= deadzone:
		posVect.y = ($Joy.global_position.y - global_position.y) / maxDist

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing:
		if get_global_mouse_position().distance_to(global_position) <= maxDist:
			$Joy.global_position = get_global_mouse_position()
		else:
			var angle = global_position.angle_to_point(get_global_mouse_position())
			$Joy.global_position.x = global_position.x + cos(angle)*maxDist
			$Joy.global_position.y = global_position.y + sin(angle)*maxDist
		calculateVect()
	else:
		$Joy.global_position = lerp($Joy.global_position, global_position, delta * 10)
		posVect = Vector2.ZERO
	#print(posVect)
