extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# random shits 


func shake_button():

	var tween = create_tween()
	var original_pos = position
	var shake_amount = 10 
	var duration = 0.2

	tween.tween_property(self, "position", original_pos + Vector2(shake_amount, 0), duration / 4.0)
	tween.tween_property(self, "position", original_pos, duration / 4.0)
	tween.tween_property(self, "position", original_pos + Vector2(-shake_amount, 0), duration / 4.0)
	tween.tween_property(self, "position", original_pos, duration / 4.0)

	# some extra wobble effect or whatever :3
	var scale_tween = create_tween().set_parallel()
	scale_tween.tween_property(self, "scale", scale * 1.1, duration / 4.0)
	scale_tween.tween_property(self, "scale", scale, duration / 4.0)
	

func load_level():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	

# buttons 


func _on_start_btn_pressed():
	load_level()

func _on_exit_btn_pressed():
	get_tree().quit()

func _on_setting_btn_pressed():
	shake_button()
