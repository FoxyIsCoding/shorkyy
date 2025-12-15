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
	femboy_repeater(controller.femboys_owned)
	


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

func femboy_repeater(count: int):
	var container = $"../misc/repeater"
	
	if container == null:
		print("Error: misc/repeater not found!")
		return
	
	if container is HBoxContainer:
		container.alignment = BoxContainer.ALIGNMENT_BEGIN
	
	for child in container.get_children():
		if child.name.begins_with("clone_"):
			child.queue_free()
	

	var placeholders = []
	if container.has_node("placeholder"):
		placeholders.append(container.get_node("placeholder"))
	for i in range(2, 9):
		var node_name = "placeholder" + str(i)
		if container.has_node(node_name):
			placeholders.append(container.get_node(node_name))
	
	if placeholders.size() == 0:
		print("Error: No placeholder nodes found!")
		return
	

	for placeholder in placeholders:
		placeholder.visible = false
	
	var max_width = get_viewport_rect().size.x - 40
	var separation = 1
	container.add_theme_constant_override("separation", separation)
	
	var total_separation = separation * (count - 1)
	var available_width = max_width - total_separation
	
	var original = placeholders[0]
	var original_width = original.size.x if original.size.x > 0 else 100
	var original_height = original.size.y if original.size.y > 0 else 100
	var aspect_ratio = original_height / original_width

	var new_width = min(available_width / count, original_width)
	var new_height = new_width * aspect_ratio
	
	for i in range(count):
		var placeholder_index = i % placeholders.size()
		var clone = placeholders[placeholder_index].duplicate()
		clone.name = "clone_" + str(i + 1)
		clone.visible = true
		clone.custom_minimum_size = Vector2(new_width, new_height)
		clone.size = Vector2(new_width, new_height)
		clone.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		clone.size_flags_vertical = Control.SIZE_SHRINK_END
		
		if clone is TextureRect:
			clone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			clone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		container.add_child(clone)
