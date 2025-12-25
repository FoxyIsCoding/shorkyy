extends TextureButton

# exports
@export_category("Animation settings")
@export var shrink_amount: Vector2 = Vector2(0.9, 0.9)
@export var rotate_amount: float = -0.1 
@export var tween_duration: float = 0.1
@export var tween_ease: Tween.EaseType = Tween.EASE_OUT
@export var tween_trans: Tween.TransitionType = Tween.TRANS_BOUNCE




@export_category("Pointer")
@export var pointer_texture: Texture2D 
@export var target_button: TextureButton  
var pointer_count: int 
@export var distance_from_target: float = 150.0
@export var rotation_speed: float = 1.0  
@export var pointer_size: Vector2 = Vector2(32, 32)  

var pointers = []
var time_elapsed = 0.0

# some shitty var's
var original_scale: Vector2
var original_rotation: float
var tween: Tween
const SAVE_PATH = "user://click_data.save"
var controller = load("res://scripts/shop/main_controller.gd")
var cps = controller.pointer_owned


var boost
var boost_multiplier = 1.0
var boost_percentage = (boost_multiplier - 1.0) * 100
#funcs 
func _ready():
	original_scale = scale
	original_rotation = rotation
	controller.load_stats()
	boost_calc()
	$"../cps".text = str(controller.cps) + "CPS \n+" + str(int(boost_percentage)) + "% Boost"
	$"../clicks".text = str(controller.clicks)
	pointer_count = controller.cps
	
	# pointer ahh thing
	
	create_pointers()
	set_as_top_level(true)
	


func _on_timer_timeout() -> void:
	controller.clicks += controller.pointer_owned
	$"../clicks".text = str(controller.clicks)
	boost_calc()
	$"../cps".text = str(controller.cps) + "CPS \n+" + str(int(boost_percentage)) + "% Boost"


func _on_button_down():
	$"poper umm soun thingy".play(0)
	boost_calc()
	
	controller.clicks += 1 * boost
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


func create_pointers():
	for pointer in pointers:
		pointer.queue_free()
	pointers.clear()
	
	for i in range(pointer_count):
		var pointer = TextureRect.new()
		pointer.texture = pointer_texture
		pointer.custom_minimum_size = pointer_size
		pointer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pointer.pivot_offset = pointer_size / 2 
		pointer.z_index = 100 
		pointer.top_level = true 
		
		add_child(pointer)
		pointers.append(pointer)

func _process(delta):
	if target_button == null or pointers.is_empty():
		return
	time_elapsed += delta
	var button_rect = target_button.get_global_rect()
	var button_center = button_rect.position + (button_rect.size / 2)
	
	for i in range(pointers.size()):
		var pointer = pointers[i]
		
		var angle_offset = (TAU / pointer_count) * i
		var final_angle = angle_offset + (rotation_speed * time_elapsed)
		
		var offset = Vector2(cos(final_angle), sin(final_angle)) * distance_from_target
		pointer.global_position = button_center + offset - (pointer_size / 2)
		
		pointer.rotation = final_angle + PI


func boost_calc():
	var entries = [controller.femboys_owned, controller.blahaj_owned, controller.useless_coin_owned]
	var entry_value = [1.03, 1.01, 1.09]
	
	boost_multiplier = 1.0  
	
	for i in range(entries.size()):
		boost_multiplier *= pow(entry_value[i], entries[i])
	
	boost = boost_multiplier 
	boost_percentage = (boost_multiplier - 1.0) * 100
