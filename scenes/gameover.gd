extends Node2D

var score
var coin_reward

var coin_sound = preload("res://audio/sounds/Pickup_Coin5.wav")
var coin_scene:PackedScene = preload("res://special_effects/particles/coin_toss.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = GlobalVar.calculate_score()
	coin_reward = roundi(score / 100)
	if GlobalVar.score_food_value < 1:
		$CanvasLayer/Cause.text = "[center]Cause of Death:\n\n[img]string_icons/badfood.png[/img][color=ff5151] Malnutrition"
	else:
		$CanvasLayer/Cause.text = "[center]Cause of Death:\n\n[color=ff5151]" + str(GlobalVar.dmg_type)
	$PlayerPos.texture = GlobalVar.player_skin
	if GlobalVar.player_facing == 0:
		$PlayerPos.flip_h = true
	GlobalMusic.stop()
		
	$CanvasLayer/Score.text = "[center]Your Score:\n[color=d945ff]" + str(score) + "[/color]\n\nBest:\n[color=d945ff]" + str(GlobalVar.best_score)
	if score > GlobalVar.best_score:
		$CanvasLayer/Score.text = "[center]Previous Score:\n[color=d945ff]" + str(GlobalVar.best_score) + "[/color]\n\n[pulse]New Best!\n[color=ffe354]" + str(score)
		GlobalVar.best_score = GlobalVar.calculate_score()
	
	print("Mobs defeated:" + str(GlobalVar.mobs_defeated_arcade))
	
	$CanvasLayer/StatGroup/Food.text = "\tFood Retained >> [color=d945ff]" + str(GlobalVar.score_food_value) #Replace with a var that tracks all food collecte din a session
	$CanvasLayer/StatGroup/Mobs.text = "\tMobs Defeated >> [color=d945ff]" + str(GlobalVar.mobs_defeated_arcade)
	$CanvasLayer/StatGroup/Coins.text = "\tCoin Reward >> [color=d945ff]" + str(coin_reward) + " [img]string_icons/coin.png[/img]"
	GlobalVar.tokens += coin_reward
	
	GlobalVar.death_controller = false
	await get_tree().create_timer(1).timeout
	$Intro.play("animate_stats")
	$music.play()
	SaveFunc.save_game()
	SaveFunc.save_game_arcade()
	print(GlobalVar.best_score)
	
	$Intro.animation_finished.connect(_on_intro_done)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space") or Input.is_action_just_pressed("ui_accept"):
		GlobalVar.reset_arcade()
		randomize()
		Screendrip.transition()
		await Screendrip.on_transition_finished
		#GlobalVar.level_queued = load("res://scenes/levels/arcade_tutorial.tscn")
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		GlobalMusic.play_random()
		SaveFunc.load_game_arcade()
	elif Input.is_action_just_pressed("escape"):
		Screendrip.transition()
		await Screendrip.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_intro_done(anim_name: StringName):
	$Float.play("default")
	$sound.stream = coin_sound
	
	for i in coin_reward:
		var coin_ptc = coin_scene.instantiate()
		add_child(coin_ptc)
		coin_ptc.global_position = $Marker2D.global_position#Vector2(380, 280)
		coin_ptc.emitting = true
		$sound.play()
		
		await get_tree().create_timer(0.1).timeout
