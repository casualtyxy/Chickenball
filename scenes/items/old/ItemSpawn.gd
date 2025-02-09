extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".hide()
	start(0.4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timeout():
	$"..".show()
