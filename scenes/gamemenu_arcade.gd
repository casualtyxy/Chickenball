extends Node2D
@onready var player_window = $PlayerWindow

@onready var sfx = $AudioStreamPlayer
var sfx_deny = preload("res://audio/sounds/Attack Tap 01.ogg")
var sfx_confirm = preload("res://audio/sounds/Smile.wav")
#var sfx_menu_close = preload("res://audio/sounds/close_menu.ogg")

var tips:Array[String] = ["I LOVE FOOD!!!", "More... More food.",
	"Upgrades! \nUpgrades! \nUpgrades! \nUpgrades!","Go for a walk!",
	"And here's your Nickel back.","Like a Sad Cartoon.","Yum yum.","FWEAKIN FWACKIN YEAH.","Ever tried those Sushi Cat flash games?","Probably the easiest game ever.",
	"It's harder.","It's easier.","Upgrade time.","I don't think anyone reads this.",
	"Spice doesn't have that effect on my gut, it just sets me ablaze.",
	"Why did the chicken cross the road? 'Cause he's raw as %@&$ that's why.","ChickenBallTM brought to you by obsessive work flow!",
	"Please don't slam the Upgrade Drawer, some body pulled it out once...","Something smells good.",
	"FEAST MODE ACTIVATED.\nHASHTAG HUNGRY.\nFEED ME MORE DOT COM.","Like the game? Even a tiny bit? Consider leaving a rating or a comment for the dev.",
	"I wonder if those are new updates steaming behind the menu.","Tap the speech bubble for more 'tips.'",
	"Always need to come up with new tips.","Everybody was Kung-Fu fighting...","Don't forget your fiber.\nI'll never make that mistake again.",
	"Let's get Rollin'!","Maybe the real Chickenball was the friends we made along the way...",
	"Share this game to totally CHICKENBALL your friends.","Right click to dash.","Drink some water. Drink water again. Stand up. Jump 10 times. Touch your toes."]
	#"Don't eat the crystals", "Beware of the prickly weeds", "Hover text boxes to see their tooltips", 
	#"I wonder who keeps polluting around here", "Are they seeds... or noodles?", "Press space to open and close this menu. Oh, you already figured that out",
	#"Bigger seed piles may obscure smaller obstacles",
@onready var text_bubble = $TextBubble

var portraits:Array = [0,2,7,8,11,15,18,19,23,24]

#***************** MISSIONS ****************

#var mis_action := ["Tank","Collect","Defeat"]
var mis_amount = 0 #see ready func
#var mis_target := [""]
var current_mission:String
var stat = 0
var selected_task

func createMission():
	var missions = ["1Defeat enemies", "2Hold food"]#, "3Collect noodles (lvl 15)"]
	selected_task = missions.pick_random()
	
	#mis_amount = GlobalVar.score_food_value / randi_range(1,5) * GlobalVar.level
	#mis_amount = roundi(mis_amount)
	
	#Balancing amount depending on situation
	match selected_task.substr(0,1):
		"1":
			mis_amount = randi_range(1,4) + GlobalVar.level
		"2":
			mis_amount = GlobalVar.score_food_value * 1.4
		"3":
			mis_amount = randi_range(1,5)
	
	mis_amount = roundi(mis_amount)
	
	#create clear condition
func checkMission():
	current_mission = "[b]Goal:[/b]\n" + str(selected_task.substr(1)) + "\n" + str(stat) + "/" + str(mis_amount)
	
	match selected_task.substr(0,1):
		"1":
			stat = GlobalVar.mobs_defeated_arcade
			#print("reached 1")
		"2":
			stat = GlobalVar.score_food_value
			#print("reached 2")
		"3":
			stat = GlobalVar.bonus_collected_arcade
			#print("reached 3")
	
	if stat >= mis_amount:
		GlobalVar.arcade_door_open.emit()
		$upgradebutton/Panel/Goal.text = "[b]Goal:[/b]\n[pulse][color=ffe354]Enter the gate"
	else:
		$upgradebutton/Panel/Goal.text = current_mission

#*******************************************

func _ready():
	$PlayerWindow.texture = GlobalVar.player_skin
	sfx.stream = sfx_deny
	text_bubble.text = tips.pick_random()
	createMission()
	$GUI/SaveScore/AcceptDialog.add_cancel_button("Cancel")
	$GUI/SaveScore.pressed.connect(_on_save_score_pressed)
	$GUI/SaveScore/AcceptDialog.confirmed.connect(_on_save_score_ok)
	
func _process(_delta):
	$GUI/LLevel.text = str(GlobalVar.tokens)
	$GUI/LFood.text = str(GlobalVar.score_food_value)
	checkMission()
	#print(GlobalVar.mobs_defeated_arcade)
	
	
	################## ITEM 1 ####################
	if GlobalVar.score_food_value >= GlobalVar.nut_upcost:
		$GUI/LNutrition.text = "[color=#efcc95]Golden Seeds [color=#ffffff]+" + str(GlobalVar.nutrition_value) + "\n[color=#583016]Cost: [color=#ffe330]" + str(GlobalVar.nut_upcost)
	else:
		$GUI/LNutrition.text = "[color=#efcc95]Golden Seeds [color=#ffffff]+" + str(GlobalVar.nutrition_value) + "\n[color=#583016]Cost: [color=#ff5430]" + str(GlobalVar.nut_upcost)
	#60ffc3
	
	################## ITEM 2 ####################
	if GlobalVar.score_food_value >= GlobalVar.prod_upcost:
		$GUI/LProduction.text = "[color=#efcc95]Production [color=#ffffff]" + str(GlobalVar.production_rate * 100) + "\n[color=#583016]Cost: [color=#ffe330]" + str(GlobalVar.prod_upcost)
	else:
		$GUI/LProduction.text = "[color=#efcc95]Production [color=#ffffff]" + str(GlobalVar.production_rate * 100) + "\n[color=#583016]Cost: [color=#ff5430]" + str(GlobalVar.prod_upcost)
		
	################## MAX HEALTH ####################
	if GlobalVar.nutrition_value >= 10:
		if GlobalVar.score_food_value >= GlobalVar.res_upcost:
			$GUI/LIron_Upgrade.text = "[color=#efcc95]Healthy Ball [color=#ffffff]" + str(GlobalVar.max_health) + "\n[color=#583016]Cost: [color=#ffe330]" + str(GlobalVar.res_upcost)
		else:
			$GUI/LIron_Upgrade.text = "[color=#efcc95]Healthy Ball [color=#ffffff]" + str(GlobalVar.max_health) + "\n[color=#583016]Cost: [color=#ff5430]" + str(GlobalVar.res_upcost)
	#elif GlobalVar.resistance >= 0.50:
		#$GUI/LIron_Upgrade.text = "[color=#efcc95]Healthy Chicken: [color=#ffffff]" + str(GlobalVar.max_health) + "%[color=#94963a]\nMAX"
	else:
		$GUI/LIron_Upgrade.text = "[color=#efcc95][Requires \nGolden Seeds 10]"
	
	#if GlobalVar.nutrition_value >= 10 and GlobalVar.resistance < 0.50:
		#if GlobalVar.score_food_value >= GlobalVar.res_upcost:
			#$GUI/LIron_Upgrade.text = "[color=#efcc95]Resistance [color=#ffffff]" + str(GlobalVar.resistance * 100) + "%\n[color=#583016]Cost: [color=#ffe330]" + str(GlobalVar.res_upcost)
		#else:
			#$GUI/LIron_Upgrade.text = "[color=#efcc95]Resistance [color=#ffffff]" + str(GlobalVar.resistance * 100) + "%\n[color=#583016]Cost: [color=#ff5430]" + str(GlobalVar.res_upcost)
	#elif GlobalVar.resistance >= 0.50:
		#$GUI/LIron_Upgrade.text = "[color=#efcc95]Resistance: [color=#ffffff]" + str(GlobalVar.resistance * 100) + "%[color=#94963a]\nMAX"
	#else:
		#$GUI/LIron_Upgrade.text = "[color=#efcc95][Requires \nGolden Seeds 10]"
	#
	################## ITEM 4 ####################
	$GUI/LPiles.text = "[color=#efcc95][Coming Soon] [color=#ffffff]"#"Batches: " + str(GlobalVar.largefoodchance) + "\nCost: " + str(GlobalVar.upgrade_cost)
	
	#print(str(GlobalVar.update3) + ", " + str(GlobalVar.update15) + ", " + str(GlobalVar.update25))



func button_update():
	randomize()
	text_bubble.text = tips.pick_random()
	if GlobalVar.level == 15:
		GlobalVar.update15.emit()
		GlobalVar.seen_update15 = true
	if GlobalVar.level == 3:
		GlobalVar.update3.emit()
		GlobalVar.seen_update3 = true
	if GlobalVar.level == 25:
		GlobalVar.update25.emit()
		GlobalVar.seen_update25 = true
		
	#if GlobalVar.update3 or GlobalVar.update15 or GlobalVar.update25:
		#GlobalVar.update_food_list()
	#print(str(GlobalVar.update3) + ", " + str(GlobalVar.update15) + ", " + str(GlobalVar.update25))

func _on_menu_exit_pressed():
	#sfx.stream = sfx_menu_close
	#sfx.play()
	$"../GUIAnimation".play("close_upgrade_menu")
	#Engine.time_scale = 1


func _on_nut_upgrade_pressed(): #ITEM 1
	if GlobalVar.score_food_value >= GlobalVar.nut_upcost:
		GlobalVar.nutrition_value += 1 #OG method nutrition * 1.363 rounded
		GlobalVar.nutrition_value = roundf(GlobalVar.nutrition_value)
		GlobalVar.score_food_value -= GlobalVar.nut_upcost
		GlobalVar.nut_upcost *= 1.2 #OG method * 1.5
		GlobalVar.nut_upcost = roundf(GlobalVar.nut_upcost)
		GlobalVar.level += 1
		button_update()
		sfx.stream = sfx_confirm
		sfx.play()
	else:
		sfx.stream = sfx_deny
		sfx.play()


func _on_prod_upgrade_pressed():
	if GlobalVar.score_food_value >= GlobalVar.prod_upcost:
		GlobalVar.production_rate += 0.20 #OG method 0.15
		GlobalVar.score_food_value -= GlobalVar.prod_upcost
		GlobalVar.prod_upcost *= 1.2
		GlobalVar.prod_upcost = roundf(GlobalVar.prod_upcost)
		GlobalVar.level += 1
		button_update()
		sfx.stream = sfx_confirm
		sfx.play()
	else:
		sfx.stream = sfx_deny
		sfx.play()


func _on_pile_upgrade_pressed(): #TEMP DISABLED
	#if GlobalVar.score_food_value < GlobalVar.prod_upcost * 0: #Remember to change cost type
		#GlobalVar.largefoodchance += 1
		#GlobalVar.score_food_value -= GlobalVar.prod_upcost
		#sfx.stream = sfx_confirm
		#sfx.play()
	#else:
		#sfx.stream = sfx_deny
		#sfx.play()
		pass


func _on_iron_upgrade_pressed():
	if GlobalVar.score_food_value >= GlobalVar.res_upcost and GlobalVar.nutrition_value >= 10:
		#if GlobalVar.resistance < 0.50:
			#GlobalVar.resistance += 0.05
			#GlobalVar.score_food_value -= GlobalVar.res_upcost
			#GlobalVar.res_upcost *= 1.7
			#GlobalVar.res_upcost = roundf(GlobalVar.res_upcost)
			#GlobalVar.level += 1
		if 1 == 1:
			GlobalVar.max_health += 1
			GlobalVar.score_food_value -= GlobalVar.res_upcost
			GlobalVar.res_upcost *= 2.7
			GlobalVar.res_upcost = roundf(GlobalVar.res_upcost)
			GlobalVar.level += 1
			GlobalVar.health = GlobalVar.max_health
			button_update()
			sfx.stream = sfx_confirm
			sfx.play()
		else:
			sfx.stream = sfx_deny
			sfx.play()
	else:
		sfx.stream = sfx_deny
		sfx.play()

func _on_save_score_pressed():
	$GUI/SaveScore/AcceptDialog.popup()
	$GUI/SaveScore/AcceptDialog.dialog_text = "End your run and save current score?\n(" + str(GlobalVar.calculate_score()) + ")"
func _on_save_score_ok():
	$GUI/MenuExit.pressed.emit()
	GlobalVar.dmg_type = "Exit"
	GlobalVar.health = 0

#func _on_quit_pressed():
	#sfx.stream = sfx_deny
	#sfx.play()
	#SaveFunc.save_game()
	#Screendrip.transition()
	#await Screendrip.on_transition_finished
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_text_click_pressed() -> void:
	randomize()
	text_bubble.text = tips.pick_random()
	sfx.stream = sfx_deny
	sfx.play()
	$TextBubble/AnimationPlayer.play("threading")


func _on_menu_open(_anim_name: StringName) -> void:
	$TextBubble/AnimationPlayer.play("threading")
