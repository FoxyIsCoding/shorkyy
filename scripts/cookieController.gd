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



#funcs 
func _ready():
	original_scale = scale
	original_rotation = rotation
	controller.load_stats()
	$"../cps".text = str(cps) + "CPS"
	$"../cps".text = str(controller.cps) + "CPS"
	$"../clicks".text = str(controller.clicks)
	pointer_count = controller.cps
	print("CPS:" + str(controller.cps))
	print("CPS but real fr" + str(pointer_count))
	
	# pointer ahh thing
	
	create_pointers()
	


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

func create_pointers():
	# Clear existing pointers
	for pointer in pointers:
		pointer.queue_free()
	pointers.clear()
	
	# Create new pointers
	for i in range(pointer_count):
		var pointer = TextureRect.new()
		pointer.texture = pointer_texture
		pointer.custom_minimum_size = pointer_size
		pointer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pointer.pivot_offset = pointer_size / 2  # Rotate around center
		
		add_child(pointer)
		pointers.append(pointer)

func _process(delta):
	if target_button == null or pointers.is_empty():
		return
	
	time_elapsed += delta
	
	# Get the center of the button
	var button_center = target_button.global_position + (target_button.size / 2)
	
	# Update each pointer
	for i in range(pointers.size()):
		var pointer = pointers[i]
		
		# Calculate angle for this pointer (evenly distributed + rotation over time)
		var angle_offset = (TAU / pointer_count) * i
		var final_angle = angle_offset + (rotation_speed * time_elapsed)
		
		# Position pointer around the button center
		var offset = Vector2(cos(final_angle), sin(final_angle)) * distance_from_target
		pointer.global_position = button_center + offset - (pointer_size / 2)
		
		# Rotate pointer to point inward towards the button (or outward)
		pointer.rotation = final_angle + PI  # Point inward, use +0 for outward
