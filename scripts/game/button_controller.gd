extends Control
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
		   


func _on_content_mouse_entered():
	if $AnimationPlayer.current_animation == "sidebar_slide_out" or "RESET":
		$AnimationPlayer.play("sidebar_slide_in")


func _on_content_mouse_exited():
	if $AnimationPlayer.current_animation == "sidebar_slide_in":
		$AnimationPlayer.play("sidebar_slide_out")	
