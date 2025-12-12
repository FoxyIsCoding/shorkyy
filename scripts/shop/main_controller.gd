extends Control
static var clicks: int
const SAVE_PATH = "user://click_data.save"
static var cps = pointer_owned

func _ready():
	load_stats()
	load_price()
	load_owned()
	$HBoxContainer/cookies.text = str(clicks)
	cps = pointer_owned


#region Var Exports
# ------------------------------------------------------------------------------------------------------
# Shop vars + exports
# ------------------------------------------------------------------------------------------------------
@export_category("Shop")
# main
@export_group("Selected Items")
@export_subgroup("Pointer")
static var pointer_price: int = 5
@export var pointer_sale = true
static var pointer_owned: int = 0
@export var pointer_object: Panel
@export var pointer_price_object: Label
@export_subgroup("Femboys")
static var femboys_price: int = 10
@export var femboys_sale = true
static var femboys_owned: int = 0
@export var femboys_object = Panel
@export var femboys_price_object: Label
@export_subgroup("Golden Cookie")
static var golden_cookie_price: int = 80
@export var golden_cookie_sale = true
static var golden_cookie_owned: int = 0
@export var golden_cookie_object = Panel
@export var golden_cookie_price_object: Label
@export_subgroup("Blahaj")
static var blahaj_price: int = 250
@export var blahaj_sale = true
static var blahaj_owned: int = 0
@export var blahaj_object = Panel
@export var blahaj_price_object: Label
@export_subgroup("Useless Coin")
static var useless_coin_price: int = 500
@export var useless_coin_sale = true
static var useless_coin_owned: int = 0
@export var useless_coin_object = Panel
@export var useless_coin_price_object: Label
# extra items
@export_group("Extra Items")
@export_subgroup("DVD")
static var dvd_price: int = 50
@export var dvd_sale = true
static var dvd_owned: int = 0
@export var dvd_price_object: Label
@export_subgroup("Subway Surfers")
static var subway_surfers_price: int = 150
@export var subway_surfers_sale = true
static var subway_surfers_owned: int = 0
@export var subway_surfers_price_object: Label
@export_subgroup("Slime")
static var slime_price: int = 500
@export var slime_sale = true
static var slime_owned: int = 0
@export var slime_price_object: Label
@export_subgroup("Lofi Girl")
static var lofi_price: int = 1000
@export var lofi_sale = true
static var lofi_owned: int = 0
@export var lofi_price_object: Label

# more 


#endregion

# --------------------------------------------------------------------------
# SHOP INITIALIZATION
# --------------------------------------------------------------------------

#region PRICE LOADING + OWNED COUNT
func load_price():

	if pointer_price_object:
		pointer_price_object.text = str(pointer_price)
	if femboys_price_object:
		femboys_price_object.text = str(femboys_price)
	if golden_cookie_price_object:
		golden_cookie_price_object.text = str(golden_cookie_price)
	if blahaj_price_object:
		blahaj_price_object.text = str(blahaj_price)
	if useless_coin_price_object:
		useless_coin_price_object.text = str(useless_coin_price)
	if dvd_price_object:
		dvd_price_object.text = str(dvd_price)
	if subway_surfers_price_object:
		subway_surfers_price_object.text = str(subway_surfers_price)
	if slime_price_object:
		slime_price_object.text = str(slime_price)
	if lofi_price_object:
		lofi_price_object.text = str(lofi_price)

func load_owned():
	$"HBoxContainer2/5/box/owned".text = str(useless_coin_owned) + "  Owned"
	$"HBoxContainer2/4/box/owned".text = str(blahaj_owned) + "  Owned"
	$"HBoxContainer2/3/box/owned".text = str(golden_cookie_owned) + "  Owned"
	$"HBoxContainer2/2/box/owned".text = str(femboys_owned) + "  Owned"
	$"HBoxContainer2/1/box/owned".text = str(pointer_owned) + "  Owned"
#endregion

# --------------------------------------------------------------------------
# BUY MECHANICS 
# --------------------------------------------------------------------------

#region BUY FUNCTIONS
func buy(item_name: String) -> bool:
	var price := 0
	var sale := false
	var owned := 0

	var ui_root: Control = $"."

	match item_name:
		"pointer":
			price = pointer_price
			sale = pointer_sale
			owned = pointer_owned
		"femboys":
			price = femboys_price
			sale = femboys_sale
			owned = femboys_owned
		"golden_cookie":
			price = golden_cookie_price
			sale = golden_cookie_sale
			owned = golden_cookie_owned
		"blahaj":
			price = blahaj_price
			sale = blahaj_sale
			owned = blahaj_owned
		"useless_coin":
			price = useless_coin_price
			sale = useless_coin_sale
			owned = useless_coin_owned
		"dvd":
			price = dvd_price
			sale = dvd_sale
			owned = dvd_owned
		"subway_surfers":
			price = subway_surfers_price
			sale = subway_surfers_sale
			owned = subway_surfers_owned
		"slime":
			price = slime_price
			sale = slime_sale
			owned = slime_owned
		"lofi":
			price = lofi_price
			sale = lofi_sale
			owned = lofi_owned
		_:
			print("Invalid item")
			return false

	# --------------------------------------------------------------------
	# NOT ENOUGH MONEY → SHAKE UI
	# --------------------------------------------------------------------
	if clicks < price or not sale:
		ui_shake(ui_root) 
		$audio/buy_fail.play()
		print("Not enough clicks for ", item_name)
		return false

	# --------------------------------------------------------------------
	# PURCHASE SUCCESSFUL
	# --------------------------------------------------------------------
	clicks -= price
	owned += 1
	$audio/buy_done.play()

	match item_name:
		"pointer":
			pointer_owned = owned
			pointer_price = int(pointer_price * 1.2)
		"femboys":
			femboys_owned = owned
			femboys_price = int(femboys_price * 1.15)
		"golden_cookie":
			golden_cookie_owned = owned
			golden_cookie_price = int(golden_cookie_price * 1.15)
		"blahaj":
			blahaj_owned = owned
			blahaj_price = int(blahaj_price * 1.15)
		"useless_coin":
			useless_coin_owned = owned
			useless_coin_price = int(useless_coin_price * 1.15)
		"dvd":
			dvd_owned = owned
			dvd_price = int(dvd_price * 1.15)
		"subway_surfers":
			subway_surfers_owned = owned
			subway_surfers_price = int(subway_surfers_price * 1.15)
		"slime":
			slime_owned = owned
			slime_price = int(slime_price * 1.15)
		"lofi":
			lofi_owned = owned
			lofi_price = int(lofi_price * 1.15)

	update_ui()
	save_shop()
	load_owned()

	# --------------------------------------------------------------------
	# SUCCESS → ZOOM PULSE
	# --------------------------------------------------------------------
	ui_zoom_pulse(ui_root,0.06)

	return true
#endregion


func update_ui():
	$HBoxContainer/cookies.text = str(clicks)
	load_price()
	

# --------------------------------------------------------------------------
# SAVE SYSTEM
# --------------------------------------------------------------------------
#region SAVE
static func save_shop():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"clicks": clicks,
			
			"pointer_owned": pointer_owned,
			"femboys_owned": femboys_owned,
			"golden_cookie_owned": golden_cookie_owned,
			"blahaj_owned": blahaj_owned,
			"useless_coin_owned": useless_coin_owned,
			"dvd_owned": dvd_owned,
			"subway_surfers_owned": subway_surfers_owned,
			"slime_owned": slime_owned,
			"lofi_owned": lofi_owned,
			"pointer_price": pointer_price,
			"femboys_price": femboys_price,
			"golden_cookie_price": golden_cookie_price,
			"blahaj_price": blahaj_price,
			"useless_coin_price": useless_coin_price,
			"dvd_price": dvd_price,
			"subway_surfers_price": subway_surfers_price,
			"slime_price": slime_price,
			"lofi_price": lofi_price
		}
		save_file.store_line(JSON.stringify(save_data))
		save_file.close()
		print("Game saved!")
#endregion

#region LOAD SAVE
static func load_stats():
	if not FileAccess.file_exists(SAVE_PATH):
		clicks = 0
		pointer_owned = 0
		femboys_owned = 0
		golden_cookie_owned = 0
		blahaj_owned = 0
		useless_coin_owned = 0
		dvd_owned = 0
		subway_surfers_owned = 0
		slime_owned = 0
		lofi_owned = 0
		print("=== NEW GAME STARTED ===")
		print("All values initialized to 0")
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file:
		var json_string = save_file.get_line()
		save_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var save_data = json.data
			# Load clicks umm owned stuff
			clicks = save_data.get("clicks", 0)
			pointer_owned = save_data.get("pointer_owned", 0)
			femboys_owned = save_data.get("femboys_owned", 0)
			golden_cookie_owned = save_data.get("golden_cookie_owned", 0)
			blahaj_owned = save_data.get("blahaj_owned", 0)
			useless_coin_owned = save_data.get("useless_coin_owned", 0)
			dvd_owned = save_data.get("dvd_owned", 0)
			subway_surfers_owned = save_data.get("subway_surfers_owned", 0)
			slime_owned = save_data.get("slime_owned", 0)
			lofi_owned = save_data.get("lofi_owned", 0)
			# Load prices 
			pointer_price = save_data.get("pointer_price", pointer_price)
			femboys_price = save_data.get("femboys_price", femboys_price)
			golden_cookie_price = save_data.get("golden_cookie_price", golden_cookie_price)
			blahaj_price = save_data.get("blahaj_price", blahaj_price)
			useless_coin_price = save_data.get("useless_coin_price", useless_coin_price)
			dvd_price = save_data.get("dvd_price", dvd_price)
			subway_surfers_price = save_data.get("subway_surfers_price", subway_surfers_price)
			slime_price = save_data.get("slime_price", slime_price)
			lofi_price = save_data.get("lofi_price", lofi_price)
			cps = pointer_owned
			print("=== GAME LOADED ===")
			print("Clicks: ", clicks)
			print("--- OWNED ITEMS ---")
			print("Pointer: ", pointer_owned)
			print("Femboys: ", femboys_owned)
			print("Golden Cookie: ", golden_cookie_owned)
			print("Blahaj: ", blahaj_owned)
			print("Useless Coin: ", useless_coin_owned)
			print("DVD: ", dvd_owned)
			print("Subway Surfers: ", subway_surfers_owned)
			print("Slime: ", slime_owned)
			print("Lofi Girl: ", lofi_owned)
			print("--- ITEM PRICES ---")
			print("Pointer Price: ", pointer_price)
			print("Femboys Price: ", femboys_price)
			print("Golden Cookie Price: ", golden_cookie_price)
			print("Blahaj Price: ", blahaj_price)
			print("Useless Coin Price: ", useless_coin_price)
			print("DVD Price: ", dvd_price)
			print("Subway Surfers Price: ", subway_surfers_price)
			print("Slime Price: ", slime_price)
			print("Lofi Girl Price: ", lofi_price)
			print("===================")
#endregion

# --------------------------------------------------------------------------
# Events and button clicks
# --------------------------------------------------------------------------

#region Events + button clicks

func _on_pointer_pressed():
	buy("pointer")


func _on_femboy_pressed():
	buy("femboys")


func _on_golden_cookie_pressed():
	buy("golden_cookie")


func _on_blahaj_pressed():
	buy("blahaj")


func _on_useless_coin_pressed():
	buy("useless_coin")

func _on_close_btn_pressed():
	$audio/button.play()
	get_tree().change_scene_to_file("res://scenes/map.tscn")
#endregion


# --------------------------------------------------------------------------
# Effects
# --------------------------------------------------------------------------


var shake_tween: Tween
var zoom_tween: Tween

#region UI SHAKE
var original_positions: Dictionary = {} 

func ui_shake(target: Control, strength: float = 12.0, duration: float = 0.2) -> void:
	if shake_tween:
		shake_tween.kill()
	
	if not original_positions.has(target):
		original_positions[target] = target.position
	
	shake_tween = create_tween()
	shake_tween.set_trans(Tween.TRANS_SINE)
	shake_tween.set_ease(Tween.EASE_IN_OUT)

	var original_pos: Vector2 = original_positions[target]

	for i in range(6):
		var offset = Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		shake_tween.tween_property(target, "position", original_pos + offset, duration / 6)

	shake_tween.tween_property(target, "position", original_pos, duration / 6)
#endregion

#region UI ZOOM
var original_scales: Dictionary = {} 

func ui_zoom_pulse(target: Control, zoom_amount: float = 0.1, duration: float = 0.25) -> void:
	if zoom_tween:
		zoom_tween.kill()
	
	if not original_scales.has(target):
		original_scales[target] = target.scale
	
	zoom_tween = create_tween()
	zoom_tween.set_trans(Tween.TRANS_CUBIC)
	zoom_tween.set_ease(Tween.EASE_OUT)

	var original_scale: Vector2 = original_scales[target]
	var zoomed_scale: Vector2 = original_scale + Vector2(zoom_amount, zoom_amount)
	
	zoom_tween.tween_property(target, "scale", zoomed_scale, duration)
	zoom_tween.tween_property(target, "scale", original_scale, duration * 1.2)
#endregion

var panel_tween: Tween = null
var panel_original_scale: Dictionary = {}
var panel_original_pivot: Dictionary = {}

func scale_panel(panel: Panel, target_scale: Vector2, duration: float = 0.3) -> void:
	if not panel:
		push_error("Panel is null!")
		return

	if panel_tween and panel_tween.is_valid():
		panel_tween.kill()

	if not panel_original_scale.has(panel):
		panel_original_scale[panel] = panel.scale
	if not panel_original_pivot.has(panel):
		panel_original_pivot[panel] = panel.pivot_offset

	panel.scale = panel_original_scale[panel]
	panel.pivot_offset = Vector2(120, 120)
	
	panel_tween = create_tween()
	panel_tween.set_trans(Tween.TRANS_CUBIC)
	panel_tween.set_ease(Tween.EASE_OUT)
	
	panel_tween.tween_property(panel, "scale", target_scale, duration)
	
	panel_tween.tween_property(panel, "scale", panel_original_scale[panel], duration)
	



func pointer_mouse_enter():
	scale_panel($"HBoxContainer2/1", Vector2(1.05, 1.05), 0.3)

func femboy_mouse_enter():
	scale_panel($"HBoxContainer2/2", Vector2(1.05, 1.05), 0.3)

func golden_cookie_mouse_enter():
	scale_panel($"HBoxContainer2/3", Vector2(1.05, 1.05), 0.3)

func blahaj_mouse_enter():
	scale_panel($"HBoxContainer2/4", Vector2(1.05, 1.05), 0.3)


func useless_coin_mouse_enter():
	scale_panel($"HBoxContainer2/5", Vector2(1.05, 1.05), 0.3)
 	

# ------


func dvd_mouse_enter():
	scale_panel($extra/horizontal_container/dvd, Vector2(1.05, 1.05), 0.3)


func subway_surfers_mouse_enter():
	scale_panel($extra/horizontal_container/subway_surfers, Vector2(1.05, 1.05), 0.3)


func slime_mouse_enter():
	scale_panel($extra/horizontal_container/slime, Vector2(1.05, 1.05), 0.3)


func lofi_mouse_enter():
	scale_panel($extra/horizontal_container/lofi, Vector2(1.05, 1.05), 0.3)
