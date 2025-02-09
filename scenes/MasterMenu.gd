extends Node

@onready var gamemenu: Node2D = $gamemenu
#@onready var upgradebutton: Control = $gamemenu/upgradebutton

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(gamemenu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if GlobalVar.death_controller == false and Input.is_action_just_pressed("space"):
		#if gamemenu.visible == false:
			#upgradebutton._on_upgrade_button_pressed()
		#else:
			#gamemenu._on_menu_exit_pressed()
	pass
