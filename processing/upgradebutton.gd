extends Control

#P stands for physical
@onready var score_food_label = %PLabelFood
@onready var sprouts_label = %PLabelSprouts
#@onready var prod_label = %PLabelProd
@onready var health_label = %PLabelLevel
#@onready var foodtick = $"../../../../FoodTick"

@onready var gamemenu: Node2D = $"../..".gamemenu

# Called when the node enters the scene tree for the first time.
func _ready():
	$UpgradeButton.pressed.connect(_on_upgrade_button_pressed)
	print_debug(gamemenu)
	GlobalVar.food_increased.connect(on_food_up)
	GlobalVar.health_changed.connect(on_health_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	##We can reference GlobalVar script because we autoloaded it in project settings
	##%d is a placeholder for a specified integer. We can specify said integer with that second %
	
	score_food_label.text = str(GlobalVar.score_food_value)
	sprouts_label.text = str(GlobalVar.energy)
	$EnergyBar.value = GlobalVar.energy
	$HealthBar.value = GlobalVar.health
	$HealthBar.max_value = GlobalVar.max_health
	$PLabelLevel/max.text = "/" + str(GlobalVar.max_health)
	
	if GlobalVar.health < 3:
		health_label.text = "[left][color=e78289]" + str(GlobalVar.health)
	elif GlobalVar.health <= (GlobalVar.max_health * 0.5) + 1:
		health_label.text = "[left][color=fff777]" + str(GlobalVar.health)
	else:
		health_label.text = "[left][color=ffffff]" + str(GlobalVar.health)

func on_health_change():
	if GlobalVar.health < 3:
		$"../../HeartAnim".play("heartbeat")
		$"../../Critical_overlay".show()
	else:
		$"../../HeartAnim".play("RESET")
		$"../../HeartAnim".stop()
		$"../../Critical_overlay".hide()
func on_food_up():
	$"../../FoodAnim".play("food_increase")
	on_health_change()

func _on_upgrade_button_pressed():
	#fdcking stupid, that I even have to write this:
	if gamemenu == null:
		gamemenu = $"../..".gamemenu
	
	gamemenu.text_bubble.text = gamemenu.tips.pick_random()
	gamemenu.player_window.frame = gamemenu.portraits.pick_random()
	$"../../GUIAnimation".play("open_upgrade_menu")
	await $"../../GUIAnimation".animation_finished
	#Engine.time_scale = 0
