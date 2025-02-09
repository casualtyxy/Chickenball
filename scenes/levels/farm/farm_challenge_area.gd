extends Area2D

signal challenge_started
signal challenge_stopped

@onready var enemy: PackedScene = preload("res://scenes/enemies/durian.tscn")
@onready var timer: Timer = $Timer

@onready var point_1 = $Point1
@onready var point_2 = $Point2
@onready var point_3 = $Point3
@onready var point_4 = $Point4


var points:Array[Node2D]

#var size_range_x
#var size_range_y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#size_range_x = $CollisionShape2D.shape.size.x
	#size_range_y = $CollisionShape2D.shape.size.y
	area_entered.connect(when_entered)
	area_exited.connect(when_exit)
	timer.timeout.connect(on_timeout)
	points = [point_1, point_2, point_3, point_4]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func when_entered(area):
	if area.is_in_group("Player"):
		challenge_started.emit()
		timer.start(1)

func when_exit(area):
	if area.is_in_group("Player"):
		challenge_stopped.emit()
		timer.stop()

func on_timeout():
	var selected_point:Node2D = points.pick_random()
	var enemy_inst:Area2D = enemy.instantiate()
	$"../..".add_child(enemy_inst)
	enemy_inst.global_position = selected_point.global_position
	timer.start(randi_range(1, 8))
