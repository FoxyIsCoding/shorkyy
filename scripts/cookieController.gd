extends TextureButton

# exports
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
var controller = load("res://scripts/shop/main_controller.gd")
const SAVE_PATH = "user://click_data.save"

var cps = controller.pointer_owned


#funcs 
func _ready():
	original_scale = scale
	original_rotation = rotation
	controller.load_stats()
	$"../cps".text = str(cps) + "CPS"
	$"../cps".text = str(controller.cps) + "CPS"
	$"../clicks".text = str(controller.clicks)
	


func _on_timer_timeout() -> void:
	controller.clicks += controller.pointer_owned
	$"../clicks".text = str(controller.clicks)
	$"../cps".text = str(controller.cps) + "CPS"


func _on_button_down():
	$"../cps".text = str(controller.cps) + "CPS"
	$"poper umm soun thingy".play(0)
	
	controller.clicks += 1
	if controller.clicks % 10 == 0:
		controller.save_shop()
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(tween_ease)
	tween.set_trans(tween_trans)
	tween.tween_property(self, "scale", original_scale * shrink_amount, tween_duration)
	tween.tween_property(self, "rotation", original_rotation + rotate_amount, tween_duration)
	tween.tween_callback(_on_tween_done)
	$"../clicks".text = str(controller.clicks)

func _on_button_up():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property( self, "scale", original_scale, tween_duration)
	tween.tween_property(self, "rotation", original_rotation, tween_duration)

func _on_tween_done():
	pass
