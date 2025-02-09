extends Area2D

@onready var player = get_parent().get_node("Player")
var direction = Vector2(0,0)
var speed = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_thing():
	direction = (global_position - player.global_position).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position -= direction * speed * delta
