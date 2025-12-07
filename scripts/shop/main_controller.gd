extends Control

var clicks: int
const SAVE_PATH = "user://click_data.save"


func _ready():
	load_stats()
	$HBoxContainer/cookies.text = clicks
	
func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	

func load_stats():
	if not FileAccess.file_exists(SAVE_PATH):
		clicks = 0
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file:
		var json_string = save_file.get_line()
		save_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var save_data = json.data
			clicks = save_data.get("clicks", 0)
			print("Loaded clicks: ", clicks)

# hover effects 

func _on_pointer_mouse_entered():
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Shrink the object to 90% of its size
	tween.tween_property(self, "scale", scale * 0.9, 0.2)
	
	# Rotate to the right (15 degrees)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + 15, 0.2)
	
	# Chain the return animations
	tween.set_parallel(false)
	
	# Return to original scale
	tween.tween_property(self, "scale", scale / 0.9, 0.2)
	
	# Return to original rotation
	tween.tween_property(self, "rotation_degrees", rotation_degrees - 15, 0.2)
