extends Node2D

#var alive_players: int
#var prev_alive_players: int #last frame

func disable_extra_players():
	print("Starting player setup")
	for i in get_child_count():
		var tempname = "Player" + str(i + 1)
		var temp = get_parent().find_child(tempname)
		if i > GlobalVar.player_count - 1:
			find_child(tempname).disable(true, false)
			print("Disabled a player")
		else:
			print("Kept a player")

func _ready() -> void:
	call_deferred("disable_extra_players")
	GlobalVar.player_died.connect(check_for_alive_players)
	#alive_players = GlobalVar.player_count

func _process(delta: float) -> void:
	pass

func check_for_alive_players():
	for i in get_children():
		if i is CharacterBody2D and not i.index > GlobalVar.player_count - 1:
			if i.is_in_group("Player"):
				print("[  TEST  ] checking player with index: " + str(i.index) + " of state " + str(i.current_state))
				
				#Possible thanks to class_name setup
				if i.current_state != Player.states.DEAD and i.current_state != Player.states.OFF: #switching from == to !=
					print("[  INFO  ] current state (" + str(i.current_state) + ") is not dead or off, freeing from method")
					return
				elif i.current_state == Player.states.DEAD or i.current_state == Player.states.OFF:
					print("[  INFO  ] current state (" + str(i.current_state) + ") is dead or cant revive")
		else:
			print("[  OVER  ] attempted to check player index " + str(i.index) + ", which is greater than the current configured players (" + str(GlobalVar.player_count) + "). skipped this check.")
	
	print("no living players, gameover!")
	await get_tree().create_timer(1.0).timeout
	GlobalVar.finishLevel(false)
