extends Area2D

@onready var local_screen_shake: AnimationPlayer = $"../LocalScreenShake"
var char_particle = preload("res://special_effects/particles/charred.tscn")
var lap_areas:Array[Area2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if has_overlapping_areas():
		lap_areas = get_overlapping_areas()
		for i in lap_areas.size():
			enemy_overlap_processing(lap_areas[i])
			if GlobalVar.hurt_touch:
				return
		#var temp = get_overlapping_areas()
		##print(get_overlapping_areas())
		#if temp.size() > 0:
			#enemy_overlap_processing(temp[0])
		##print(temp[0])

func enemy_overlap_processing(area:Area2D):
	# **************** ENEMIES *********************
	
	if area.is_in_group("Huckerworm"): ##################################### WORM
		
		if GlobalVar.bonus_active:
			var ptc = char_particle.instantiate()
			$"../..".add_child(ptc)
			ptc.position = area.get_global_position()
			area.get_parent().explode()
			local_screen_shake.play("fire")
		elif $"..".is_dashing and not area.get_parent().invincible:
			area.get_parent().hurt()
			#if $"..".is_invincible == false:
				#GlobalVar.health -= 1
				#GlobalVar.hurt_touch = true
				#local_screen_shake.play("screenshake")
	elif area.is_in_group("Durian"): ################################# DURIAN
			
			if GlobalVar.bonus_active:
				var ptc = char_particle.instantiate()
				$"../..".add_child(ptc)
				ptc.position = area.get_global_position()
				area.queue_free()
				local_screen_shake.play("fire")
			else:
				if $"..".is_invincible == false:
					GlobalVar.health -= 1
					GlobalVar.health_changed.emit()
					GlobalVar.hurt_touch = true
					local_screen_shake.play("screenshake")
					GlobalVar.dmg_type = "[img]string_icons/durian.png[/img] Spiky Fruit"
				area.explode()
	elif area.is_in_group("Lotus"): ########################################### Lotus
		
		if GlobalVar.bonus_active:
			var ptc = char_particle.instantiate()
			$"../..".add_child(ptc)
			ptc.position = area.get_global_position()
			area.get_parent().explode()
			local_screen_shake.play("fire")
		elif $"..".is_dashing and not area.get_parent().invincible:
			area.get_parent().hurt()
	
	elif area.is_in_group("LotusBall"):
		
		if GlobalVar.bonus_active:
			var ptc = char_particle.instantiate()
			$"../..".add_child(ptc)
			ptc.position = area.get_global_position()
			area.queue_free()
			local_screen_shake.play("fire")
		else:
			if $"..".is_invincible == false:
					GlobalVar.health -= 1
					GlobalVar.health_changed.emit()
					GlobalVar.hurt_touch = true
					local_screen_shake.play("screenshake")
					GlobalVar.dmg_type = "[img]res://string_icons/big_lotus_ball.png[/img] Hard Pearl"
