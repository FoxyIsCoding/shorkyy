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
