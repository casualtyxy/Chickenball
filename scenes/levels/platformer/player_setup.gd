extends Node2D

func remove_extra_players():
	print("Starting player seup")
	for i in get_child_count():
		var tempname = "Player" + str(i + 1)
		var temp = get_parent().find_child(tempname)
		if i > GlobalVar.player_count - 1:
			get_parent().find_child(tempname).queue_free()
			print("Removed a player")
		else:
			print("Kept a player")

func _ready() -> void:
	call_deferred("remove_extra_players")
