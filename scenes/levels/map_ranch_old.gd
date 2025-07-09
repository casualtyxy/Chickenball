extends Node2D

#var min_playable_x = -275
#var max_playable_x = 1045
#var min_playable_y = 315
#var max_playable_y = 355

#@onready var character_food_hitbox = $CharacterBody2D/foodcheck

@onready var marker_1: Node2D = $LevelMarker

var cloud_speed = -5

var world_levels:Array[Node2D] = []

#@export var player_map_pos = Vector2(0,0)
#var merge_tile_array:Array[Node2D]
#var item1 = preload("res://scenes/items/farm/small_seed.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveFunc.saving_game.connect(when_saving)
	SaveFunc.load_game()
	#$WateringCan/Pressable.watering_can_pressed.connect(spawn_seed)
	#merge_tile_array.assign(get_tree().get_nodes_in_group("MergeTile"))
	GlobalMusic.play_music(GlobalMusic.berry_farm)
	GlobalMusic.song_finished.connect(when_song_finished)
	$ChallengeArea/CollisionShape2D.shape.size.x = 216
	$ChallengeArea/CollisionShape2D.shape.size.y = 216
	$ChallengeArea/CollisionShape2D.position = Vector2i(108, 108)
	$DurianKillZone.area_entered.connect(durian_wall_collision)
	
	world_levels = [marker_1]
	
	if GlobalVar.currentLevel < 1:
		pass
		print("Current level is less than 1: " + str(GlobalVar.currentLevel))
	else:
		print("Current level is more than 0: " + str(GlobalVar.currentLevel))
		for i in world_levels:
			if i.level_id == GlobalVar.currentLevel:
				print("Found level id: " + str(i.level_id))
				$Player.global_position = i.global_position
	
	GlobalVar.menu_theme = GlobalVar.menu_bg_elements.RANCH
	
	GlobalVar.on_map_loaded()
	
	await get_tree().create_timer(1.5).timeout
	GlobalVar.level_completed.emit(GlobalVar.currentLevel, GlobalVar.currentLevelDone)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ParallaxBackground/Clouds1.motion_offset.x += cloud_speed * delta

func when_song_finished():
	print("Song finished")

func when_saving():
	if get_tree().get_node_count_in_group("Item") > 0:
		print("Found " + str(get_tree().get_node_count_in_group("Item")) + " Items")

func durian_wall_collision(area:Area2D):
	if area.is_in_group("SpikedCabbage"):
		area.explode()

func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area == character_food_hitbox:
		#$BrokenDoor/AnimationPlayer.play("popup")
		print_debug("Get rid of this too")

func _on_area_2d_area_exited(area: Area2D) -> void:
	#if area == character_food_hitbox:
		#$BrokenDoor/AnimationPlayer.play_backwards("popup")
		print_debug("You gotta remove this man")
#func spawn_seed():
	
	#var found_empty = false
	
	#for item in merge_tile_array:
		#if item.get_child_count() > 2:
			#pass
		#else:
			##found_empty = true
			#item.add_child(item1.instantiate())
			#return
