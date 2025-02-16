extends Node2D

var alive_players: int
var prev_alive_players: int #last frame

func disable_extra_players():
	print("Starting player setup")
	for i in get_child_count():
		var tempname = "Player" + str(i + 1)
		var temp = get_parent().find_child(tempname)
		if i > GlobalVar.player_count - 1:
			find_child(tempname).disable()
			print("Disabled a player")
		else:
			print("Kept a player")

func _ready() -> void:
	call_deferred("disable_extra_players")
	

func _process(delta: float) -> void:
	check_for_alive_players()

func check_for_alive_players():
	alive_players = GlobalVar.player_count #reset value
	for i in get_children():
		if i.is_in_group("Player"):
			if i.current_state == 5: #dead
				alive_players -= 1
	
	if alive_players == 0 and prev_alive_players != 0: #everyone died, check prev frame to avoid spamming the function eternally
		GlobalVar.finishLevel(false)
	
	prev_alive_players = alive_players
