class_name Dispenser extends StaticBody2D

var spawn = preload("res://scenes/terrain/physics_item.tscn")
##Items stuffed in the dispenser. You can place chicklets in here too
@export var stored_items:Array[PackedScene]
##Amount of times to fire
@export var quantity := 7
##Velocity of the item
@export var velocity := -700.0
##How quick items are fired
@export var frequency := 0.1
##How wide of an angle items are spread
@export var spread := 4.0

var is_full = true
var is_asleep = false

var sfx_hit = preload("res://audio/sounds/item/dispenser.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitArea.body_entered.connect(smack)
	$AboveHitArea.body_entered.connect(slam)

func smack(body: Node2D):
	if body.is_in_group("Player") and is_full:
		$SFX.stream = sfx_hit
		$SFX.play()
		$AnimationPlayer.play("active")
		fountain()
		is_full = false
		await $AnimationPlayer.animation_finished
		is_asleep = true
	elif not is_full and is_asleep:
		$AnimationPlayer.play("knock_up")

func slam(body: Node2D):
	if body.is_in_group("Player"):
		if body.size > 1.4 and is_full:
			$AnimationPlayer.play("knock_down")
			if body.size > 1.9 and is_full:
				smack(body)
		elif not is_full and is_asleep:
			$AnimationPlayer.play("knock_down")

func fountain():
	for i in quantity:
		var spawned_item = spawn.instantiate()
		spawned_item.item = stored_items.pick_random()
		call_deferred("add_child", spawned_item)
		spawned_item.set_packed_scene()
		spawned_item.position = $SpawnPos.position
		spawned_item.launch(velocity, spread)
		$Timer.start(frequency)
		await $Timer.timeout
