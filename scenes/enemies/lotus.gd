extends CharacterBody2D

@export var health: int
@export var invincible := false

func turn_off_balls():
	for i in $Balls/Balls2.get_child_count(false):
		$Balls/Balls2.get_child(i).get_child(0).disabled = true
		#$Balls/Balls2.get_child(i).reset_rot()
	for i in $Balls.get_child_count(false) - 1:
		$Balls.get_child(i).get_child(0).disabled = true
		#$Balls/Balls2.get_child(i).reset_rot()
	$Balls/Balls2.hide()
	$Balls.hide()
func turn_on_balls():
	for i in $Balls/Balls2.get_child_count(false):
		$Balls/Balls2.get_child(i).get_child(0).disabled = false
	for i in $Balls.get_child_count(false) - 1:
		$Balls.get_child(i).get_child(0).disabled = false
	$Balls/Balls2.show()
	$Balls.show()
	toggleBalls()

func toggleBalls():
	if not $CShape.disabled:
		#Disable collisions for extra balls
		for i in $Balls/Balls2.get_child_count(false):
			$Balls/Balls2.get_child(i).get_child(0).disabled = !$Balls/Balls2.get_child(i).get_child(0).disabled
			#print($Balls/Balls2.get_child(i).get_child(0).disabled)
		#Hide extra balls
		$Balls/Balls2.visible = !$Balls/Balls2.visible

func explode():
	$HealthStat.hide()
	$AnimationPlayer.play("explode")
	print("Exploding")
	if get_child(1).name == "CShape":
		$CShape.disabled = true
		$Balls.queue_free()
		print("Deleted shape")
	
func explode_end():
	$Perish.start(0.4)
	await $Perish.timeout
	GlobalVar.mobs_defeated_arcade += 1
	queue_free()

func _ready() -> void:
	#Timer.timeout.connect(toggleBalls)
	summon_balls()

func summon_balls():
	if $AnimationPlayer.is_playing():
		await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("summon_balls")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("ballspin")

func hurt():
	$Switch.stop()
	$HealthStat.show()
	$HealthStat.value = health - 1
	if $CShape.disabled == false:
		toggle_world_col()
		$AnimationPlayer.play("hurt")
	
		if health <= 1:
			explode()
		else:
			#$AnimationPlayer.play("ballspin")
			pass
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("ballspin")
	$Switch.play("switchloop")
func hurt_adjacent(): #Called in anim player to avoid insta death
	health -= 1
	if $CShape.disabled:
		toggle_world_col()
	summon_balls()

func toggle_world_col():
	$CShape.disabled = !$CShape.disabled
