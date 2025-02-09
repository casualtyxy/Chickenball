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
	"Let's get Rollin'!","The mountains scare me.","Maybe the real Chickenball was the friends we made along the way...",
	"Share this game to totally CHICKENBALL your friends."]
	#"Don't eat the crystals", "Beware of the prickly weeds", "Hover text boxes to see their tooltips", 
	#"I wonder who keeps polluting around here", "Are they seeds... or noodles?", "Press space to open and close this menu. Oh, you already figured that out",
	#"Bigger seed piles may obscure smaller obstacles",
@onready var text_bubble = $TextBubble

var portraits:Array = [0,1,2,6,7,12,16,17]

func _ready():
	sfx.stream = sfx_deny
	text_bubble.text = tips.pick_random()
	
func _process(_delta):
	$GUI_old/LLevel.text = "Level " + str(GlobalVar.level)
	$GUI_old/LFood.text = str(GlobalVar.score_food_value)
	
	################## ITEM 1 ####################
	#if GlobalVar.score_food_value > GlobalVar.nut_upcost:
		#$GUI/LNutrition.text = "[img]res://art/items/farm/seed.png[/img][color=#efcc95]Golden Seeds [color=#ffffff]+" + str(GlobalVar.nutrition_value) + "\n[color=#583016]Cost: [color=#ffe330]" + str(GlobalVar.nut_upcost)
	#else:
		#$GUI/LNutrition.text = "[img]res://art/items/farm/seed.png[/img][color=#efcc95]Golden Seeds [color=#ffffff]+" + str(GlobalVar.nutrition_value) + "\n[color=#583016]Cost: [color=#ff5430]" + str(GlobalVar.nut_upcost)
	#60ffc3
	
	################## ITEM 2 ####################
	#if GlobalVar.score_food_value > GlobalVar.prod_upcost:
		#$GUI/LProduction.text = "[color=#efcc95]Production [color=#ffffff]" + str(GlobalVar.production_rate * 100) + "%\n[color=#583016]Cost: 
		#[color=#ffe330]" + str(GlobalVar.prod_upcost)
	#else:
		#$GUI/LProduction.text = "[color=#efcc95]Production [color=#ffffff]" + str(GlobalVar.production_rate * 100) + "%\n[color=#583016]Cost: 
		#[color=#ff5430]" + str(GlobalVar.prod_upcost)
		
	################## ITEM 3 ####################
	#if GlobalVar.nutrition_value >= 10 and GlobalVar.resistance < 0.50:
		#if GlobalVar.score_food_value > GlobalVar.res_upcost:
			#$GUI/LIron_Upgrade.text = "[color=#efcc95]Resistance [color=#ffffff]" + str(GlobalVar.resistance * 100) + "%\n[color=#583016]Cost: 
			#[color=#ffe330]" + str(GlobalVar.res_upcost)
		#else:
			#$GUI/LIron_Upgrade.text = "[color=#efcc95]Resistance [color=#ffffff]" + str(GlobalVar.resistance * 100) + "%\n[color=#583016]Cost: 
			#[color=#ff5430]" + str(GlobalVar.res_upcost)
	#elif GlobalVar.resistance >= 0.50:
		#$GUI/LIron_Upgrade.text = "[color=#efcc95]Resistance: [color=#ffffff]" + str(GlobalVar.resistance * 100) + "%[color=#94963a]\nMAX"
	#else:
		#$GUI/LIron_Upgrade.text = "[color=#efcc95][Requires \nNutrition 10]"
	
	################## ITEM 4 ####################
	#$GUI/LPiles.text = "[color=#efcc95][Coming Soon] [color=#ffffff]"#"Batches: " + str(GlobalVar.largefoodchance) + "\nCost: " + str(GlobalVar.upgrade_cost)
	
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


func _on_text_click_pressed() -> void:
	randomize()
	text_bubble.text = tips.pick_random()
	sfx.stream = sfx_deny
	sfx.play()
	$TextBubble/AnimationPlayer.play("threading")


func _on_menu_open(_anim_name: StringName) -> void:
	$TextBubble/AnimationPlayer.play("threading")
