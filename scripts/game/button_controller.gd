extends Node2D
var controller = load("res://scripts/shop/main_controller.gd")
func _ready():
	$cps.text = str(controller.pointer_owned) + "CPS"

func _on_shop_btn_pressed():
	controller.save_shop()
	$audio/button.play()
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
	
func _on_menu_btn_pressed():
	controller.save_shop()
	$audio/button.play()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
