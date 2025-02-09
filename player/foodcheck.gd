extends Area2D

var bonus_timer = preload("res://processing/bonus.tscn")
@onready var sfx_overlay = $"../SFXOverlay"
@onready var local_screen_shake: AnimationPlayer = $"../LocalScreenShake"

var food_particle = preload("res://special_effects/particles/foodmunch.tscn")
var char_particle = preload("res://special_effects/particles/charred.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Ensure label is not null before accessing it
	area_entered.connect(has_collided)

func has_collided(area):
	GlobalVar.food_increased.emit()
	
	var insta_collide = false
	
	if area.visible == false:
		insta_collide = false
	elif area.visible:
		insta_collide = true
	if GlobalVar.bonus_active:
		insta_collide = true
	
	if insta_collide: #********* FOOD **********
		if area.is_in_group("Seed"): ########################################### FOOD ###########################################
			GlobalVar.score_food_value += GlobalVar.nutrition_value
			GlobalVar.energy += 3
			GlobalVar.food_touch = true
			area.queue_free()
			var ptc = food_particle.instantiate()
			$"../..".add_child(ptc)
			ptc.position = $"..".get_global_position()
			
		elif area.is_in_group("Crystal"): ###################################### BADFOOD ###########################################
			if GlobalVar.bonus_active:
				area.queue_free()
				var ptc = char_particle.instantiate()
				$"../..".add_child(ptc)
				ptc.position = $"..".get_global_position()
				local_screen_shake.play("fire")
			else:
				GlobalVar.score_food_value -= GlobalVar.nutrition_value - roundf(GlobalVar.nutrition_value * GlobalVar.resistance)
				GlobalVar.hurt_touch = true
				area.queue_free()
				local_screen_shake.play("screenshake")
				
		elif area.is_in_group("GoldSeed"): ##################################### SUPERFOOD ###########################################
			GlobalVar.score_food_value += GlobalVar.nutrition_value * 1.5
			GlobalVar.energy += 6
			GlobalVar.food_touch = true
			sfx_overlay.stream = $"..".sfx_bonus
			sfx_overlay.play()
			area.queue_free()
			var ptc = food_particle.instantiate()
			$"../..".add_child(ptc)
			ptc.position = $"..".get_global_position()
			
		elif area.is_in_group("CropKiller"): ################################### BLUEFOOD ###########################################
			if GlobalVar.bonus_active:
				$"../Bonus".start()
				area.queue_free()
				var ptc = char_particle.instantiate()
				$"../..".add_child(ptc)
				ptc.position = $"..".get_global_position()
				local_screen_shake.play("fire")
				GlobalVar.bonus_collected_arcade += 1
			else:
				GlobalVar.bonus_active = true
				$"..".add_child(bonus_timer.instantiate())
				area.queue_free()
				var ptc = char_particle.instantiate()
				$"../..".add_child(ptc)
				ptc.position = $"..".get_global_position()
				local_screen_shake.play("fire")
				GlobalVar.bonus_collected_arcade += 1
				
		elif area.is_in_group("LargeSpike"): ################################### SPIKE ###########################################
			if GlobalVar.bonus_active:
				area.queue_free()
				var ptc = char_particle.instantiate()
				$"../..".add_child(ptc)
				ptc.position = $"..".get_global_position()
				local_screen_shake.play("fire")
			else:
				GlobalVar.score_food_value += GlobalVar.nutrition_value * -2 - GlobalVar.resistance
				GlobalVar.hurt_touch = true
				area.queue_free()
				local_screen_shake.play("screenshake")
				
		elif area.is_in_group("LargeSeed"): #################################### LARGEFOOD ###########################################
			GlobalVar.score_food_value += GlobalVar.nutrition_value * 2
			if GlobalVar.energy < 50:
				GlobalVar.energy += 6
			GlobalVar.food_touch = true
			area.queue_free()
			var ptc = food_particle.instantiate()
			$"../..".add_child(ptc)
			ptc.position = $"..".get_global_position()
			
		elif area.is_in_group("LargeCrystal"): ################################# LARGEBADFOOD ###########################################
			
			if GlobalVar.bonus_active:
				area.queue_free()
				var ptc = char_particle.instantiate()
				$"../..".add_child(ptc)
				ptc.position = $"..".get_global_position()
				local_screen_shake.play("fire")
			else:
				GlobalVar.score_food_value -= GlobalVar.nutrition_value * 2 - roundf(GlobalVar.nutrition_value * GlobalVar.resistance)
				GlobalVar.hurt_touch = true
				area.queue_free()
				local_screen_shake.play("screenshake")
				
		#if area.is_in_group("Porquinut"): ###################################### TEST
			#
			#if GlobalVar.bonus_active or $"..".is_dashing:
				#var ptc = char_particle.instantiate()
				#$"../..".add_child(ptc)
				#ptc.position = area.get_global_position()
				#area.queue_free()
			#else:
				#if $"..".is_invincible == false:
					#GlobalVar.health -= 1
					#GlobalVar.hurt_touch = true
					#local_screen_shake.play("screenshake")
		if GlobalVar.energy > 50:
			GlobalVar.energy = 50
	
	GlobalVar.score_food_value = roundf(GlobalVar.score_food_value)

#func _process(_delta):
	#if $nose.overlaps_body(area):
		#if area.collision_layer == 1:
			#GlobalVar.smelling_food = true
