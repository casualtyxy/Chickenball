class_name PhysicsDurian extends RigidBody2D

@export var durability:int = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Redzone.body_entered.connect(_on_hit)

func burst():
	var colliders = get_colliding_bodies().size()
	if colliders > 0:
		durability -= 1
	
	if durability <= 0:
		$AnimPlayer.play("burst")
		freeze = true
		$WorldCol.set_deferred("disabled", true)
		$Redzone/CollisionShape2D.set_deferred("disabled", true)
		await $AnimPlayer.animation_finished
		queue_free()

func _on_hit(body: Node2D):
	if body is CharacterBody2D:
		if body.is_in_group("Player"):
			body.hurt()
			durability -= 1
		elif body.is_in_group("Squishable"):
			body.clobbered()
			durability -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	burst()
	$Particles.global_rotation = 0.0
