extends Timer


func _ready():
	start(60.5)


func _process(_delta):
	#if GlobalVar.broadcast_clear:
		#$"..".queue_free()
	pass


func _on_timeout():
	$"..".queue_free()
