extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Close.pressed.connect(close)

func close():
	$"..".camera_anim.play("title")
	$"../Control/Adventure".grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# This assumes RichTextLabel's `meta_clicked` signal was connected to
# the function below using the signal connection dialog.
func _on_meta_clicked(meta):
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at run-time.
	OS.shell_open(str(meta))
