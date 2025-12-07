extends TextureButton

# exports
@export_category("Stats")
@export var coins: int 
@export var cps: int
@export_category("Animation settings")
@export var shrink_amount: Vector2 = Vector2(0.9, 0.9)
@export var rotate_amount: float = -0.1 
@export var tween_duration: float = 0.1
@export var tween_ease: Tween.EaseType = Tween.EASE_OUT
@export var tween_trans: Tween.TransitionType = Tween.TRANS_BOUNCE

# some shitty var's
var original_scale: Vector2
var original_rotation: float
var tween: Tween
var clicks: int = 0
const SAVE_PATH = "user://click_data.save"

#funcs 
func _ready():
	original_scale = scale
	original_rotation = rotation
	load_stats()
	$"../clicks".text = clicks

func _on_button_down():
	$"poper umm soun thingy".play(0)
	
	clicks += 1
	if clicks % 10 == 0:
		save_stats()
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(tween_ease)
	tween.set_trans(tween_trans)
	tween.tween_property(self, "scale", original_scale * shrink_amount, tween_duration)
	tween.tween_property(self, "rotation", original_rotation + rotate_amount, tween_duration)
	tween.tween_callback(_on_tween_done)
	$"../clicks".text = clicks

func _on_button_up():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", original_scale, tween_duration)
	tween.tween_property(self, "rotation", original_rotation, tween_duration)

func _on_tween_done():
	pass

func save_stats():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"clicks": clicks,
			"cps": cps
		}
		save_file.store_line(JSON.stringify(save_data))
		save_file.close()
		print("Saved clicks: ", clicks)

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
			cps = save_data.get("cps", 0)
			print("Loaded cps: ", cps)
