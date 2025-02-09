extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveFunc.load_game_arcade()
	$Player.disable_camera()
	$StaticView.enabled = true
	$Coins.text = str(GlobalVar.tokens)
	$Coin.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GlobalVar.energy = 50
