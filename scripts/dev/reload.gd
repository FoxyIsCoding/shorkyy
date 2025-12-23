extends Node

var Save = load("res://scripts/shop/main_controller.gd")
var Volume = load("res://scripts/audiocontroller.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reload():
	Save.save_shop()
	Save.load_owned()
	Save.update_ui()
	Volume.save_settings()
	Volume.load_settings()
	Volume.apply_audio_settings()
