extends Control

var clicks: int
const SAVE_PATH = "user://click_data.save"

func _ready():
	load_stats()
	$HBoxContainer/cookies.text = clicks
	

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")


# ------------------------------------------------------------------------------------------------------
# Shop vars + exports
# ------------------------------------------------------------------------------------------------------
@export_category("Shop")

# main
@export_group("Selected Items")
@export_subgroup("Pointer")
@export var pointer_price: int = 5
@export var pointer_sale = true
@export_subgroup("Femboys")
@export var femboys_price: int = 10
@export var femboys_sale = true
@export_subgroup("Golden Cookie")
@export var golden_cookie_price: int = 80
@export var golden_cookie_sale = true
@export_subgroup("Blahaj")
@export var blahaj_price: int = 250
@export var blahaj_sale = true
@export_subgroup("Useless Coin")
@export var useless_coin_price: int = 500
@export var useless_coin_sale = true

# extra items

@export_group("Extra Items")
@export_subgroup("DVD")
@export var dvd_price: int = 50
@export var dvd_sale = true
@export_subgroup("Subway Surfers")
@export var subway_surfers_price: int = 150
@export var subway_surfers_sale = true
@export_subgroup("Slime")
@export var slime_price: int = 500
@export var slime_sale = true
@export_subgroup("Lofi Girl")
@export var lofi_price: int = 1000
@export var lofi_sale = true


# --------------------------------------------------------------------------
# SHOP INITIALIZATION
# --------------------------------------------------------------------------



# --------------------------------------------------------------------------
# SAVE SYSTEM
# --------------------------------------------------------------------------


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
