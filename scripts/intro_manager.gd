extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"dyam holy animations".play("introo")
	





func _on_dyam_holy_animations_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
