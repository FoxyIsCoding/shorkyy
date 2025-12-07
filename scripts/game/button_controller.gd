extends Node2D

func _ready():
	pass

func _on_shop_btn_pressed():
	$cookiee.save_stats()
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
	
func _on_menu_btn_pressed():
	$cookiee.save_stats()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
