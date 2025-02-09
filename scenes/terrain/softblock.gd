extends StaticBody2D

@export var durability = 3

var sfx_hit = preload("res://audio/sounds/ExplosionShort.wav")
var sfx_explode = preload("res://audio/sounds/ExplosionShort2.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitArea.body_entered.connect(smack)
	$AboveHitArea.body_entered.connect(slam)

func smack(body: Node2D):
	if body.is_in_group("Player"):
		$SFX.stream = sfx_hit
		$SFX.play()
		$AnimationPlayer.play("shake")
		
		if body.size < 1.5:
			durability -= 1
			if $Sprite.frame < 3:
				$Sprite.frame += 1
		elif body.size > 1.4:
			durability -= 1
			if $Sprite.frame < 3:
				$Sprite.frame += 1
			if body.size > 1.9:
				durability -= 1
				if $Sprite.frame < 3:
					$Sprite.frame += 1
			
		if durability < 1:
			call_deferred("break_apart")

func slam(body: Node2D):
	if body.is_in_group("Player"):
		if body.size > 1.4:
			smack(body)
			if body.size > 1.9:
				smack(body)

func break_apart():
	$SFX.stream = sfx_explode
	$SFX.play()
	$Sprite.hide()
	$WorldCol.disabled = true
	$HitArea/Col.disabled = true
	await get_tree().create_timer(1).timeout
	queue_free()
