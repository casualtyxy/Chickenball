extends Node2D

signal player_off_screen
signal player_on_screen
#signal player_range(range: StringName)

func left_the_screen():
	player_off_screen.emit()
func entered_the_screen():
	player_on_screen.emit()

func _ready() -> void:
	get_parent().get_parent().find_child("PlatformerUILayer").show_p2()
	get_parent().get_parent().find_child("SidescrollCamera").add_player_2(self)
	$MainOnScreen.screen_exited.connect(left_the_screen)
	$MainOnScreen.screen_entered.connect(entered_the_screen)

func _process(delta: float) -> void:
	#if $LeftOnScreenNear.is_on_screen() and $RightOnScreenNear.screen_entered or $RightOnScreenNear.is_on_screen() and $LeftOnScreenNear.screen_entered:
		#player_range.emit("Near")
	#if $LeftOnScreenFar.is_on_screen() and $RightOnScreenFar.screen_entered or $RightOnScreenFar.is_on_screen() and $LeftOnScreenFar.screen_entered:
		#player_range.emit("Far")
		pass
