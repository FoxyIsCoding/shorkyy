extends Window

@onready var tab_container: TabContainer = $VBoxContainer/TabContainer
@onready var drag_header: Panel = $VBoxContainer/DragHeader
@onready var raw_editor: TextEdit = $VBoxContainer/RawEditor
@onready var save_button: Button = $VBoxContainer/HBoxContainer/SaveButton
@onready var close_button: Button = $VBoxContainer/HBoxContainer/CloseButton

var save_files: Array[String] = []
var save_data: Dictionary = {}

var Reloader = load("res://scripts/dev/reload.gd")

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var current_raw_filename: String = ""
var is_updating_raw_from_code: bool = false

func _ready() -> void:
	set_flag(Window.FLAG_ALWAYS_ON_TOP, true)

	save_button.pressed.connect(_on_save_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	tab_container.tab_changed.connect(_on_tab_changed)
	raw_editor.text_changed.connect(_on_raw_editor_changed)

	load_save_files()

func open_save_editor() -> void:
	visible = true
	size = Vector2(800, 600)
	position = get_viewport().get_visible_rect().size / 2.0 - size / 2.0 / 5
	load_save_files()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("devmenu"):
		if visible:
			visible = false
		else:
			open_save_editor()

func load_save_files() -> void:
	for child in tab_container.get_children():
		child.queue_free()

	save_files.clear()
	save_data.clear()

	var dir := DirAccess.open("user://")
	if dir == null:
		push_error("Cannot access user:// directory")
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".save"):
			save_files.append(file_name)
			parse_save_file(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	for filename in save_files:
		create_save_tab(filename)

	if not save_files.is_empty():
		_refresh_raw_editor_for_file(save_files[tab_container.current_tab])
	else:
		_clear_raw_editor()

func parse_save_file(filename: String) -> void:
	var path: String = "user://%s" % filename
	if not FileAccess.file_exists(path):
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open %s" % path)
		return

	var json_string: String = file.get_as_text()
	file.close()

	var json := JSON.new()
	var err: int = json.parse(json_string)
	if err == OK:
		save_data[filename] = json.data
	else:
		save_data[filename] = {
			"error": "Invalid JSON: %s at line %d" %
			[json.get_error_message(), json.get_error_line()]
		}

func create_save_tab(filename: String) -> void:
	var tab := ScrollContainer.new()
	tab.name = filename.get_basename()
	tab_container.add_child(tab)

	var editor_container := VBoxContainer.new()
	editor_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	editor_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tab.add_child(editor_container)

	var data: Variant = save_data.get(filename, {})
	build_editor_recursive(editor_container, data, "", filename)

func build_editor_recursive(
		container: Container,
		data: Variant,
		path: String,
		filename: String
	) -> void:
	match typeof(data):
		TYPE_DICTIONARY:
			var dict: Dictionary = data
			for key in dict.keys():
				var key_str: String = str(key)
				var sub_path: String = key_str if path == "" else "%s/%s" % [path, key_str]

				var label := Label.new()
				label.text = "%s:" % key_str
				label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				container.add_child(label)

				var sub_container := VBoxContainer.new()
				sub_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				container.add_child(sub_container)

				build_editor_recursive(sub_container, dict[key], sub_path, filename)

		TYPE_ARRAY:
			var arr: Array = data
			for i in arr.size():
				var index_label := Label.new()
				index_label.text = "[%d]:" % i
				container.add_child(index_label)

				var sub_container := VBoxContainer.new()
				sub_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				container.add_child(sub_container)

				var sub_path: String = "%s[%d]" % [path, i] if path != "" else "[%d]" % i
				build_editor_recursive(sub_container, arr[i], sub_path, filename)

		_:
			var line_edit := LineEdit.new()
			line_edit.text = str(data)
			line_edit.placeholder_text = path
			line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			var local_path: String = path
			var local_filename: String = filename
			line_edit.text_changed.connect(
				func(new_text: String) -> void:
					on_value_changed(local_path, new_text, local_filename)
			)
			container.add_child(line_edit)

func parse_value(text: String) -> Variant:

	var trimmed := text.strip_edges()

	if trimmed.to_lower() == "true":
		return true
	if trimmed.to_lower() == "false":
		return false

	if trimmed.to_lower() == "null":
		return null

	if trimmed.is_valid_int():
		return int(trimmed)

	if trimmed.is_valid_float():
		return float(trimmed)

	return text

func on_value_changed(path: String, new_value: String, filename: String) -> void:
	var data: Variant = save_data[filename]
	var parsed_value: Variant = parse_value(new_value)

	if path == "":
		save_data[filename] = parsed_value
		_refresh_raw_editor_for_file(filename)
		return

	var parts: PackedStringArray = path.split("/")
	var current: Variant = data

	for i in range(parts.size() - 1):
		var part: String = parts[i]
		if part.begins_with("[") and part.ends_with("]"):
			var idx_str: String = part.substr(1, part.length() - 2)
			var idx: int = int(idx_str)
			current = current[idx]
		else:
			current = current[part]

	var last: String = parts[parts.size() - 1]
	if last.begins_with("[") and last.ends_with("]"):
		var idx_str2: String = last.substr(1, last.length() - 2)
		var idx2: int = int(idx_str2)
		current[idx2] = parsed_value
	else:
		current[last] = parsed_value

	save_data[filename] = data
	_refresh_raw_editor_for_file(filename)

func _on_tab_changed(tab_idx: int) -> void:
	if tab_idx < 0 or tab_idx >= save_files.size():
		_clear_raw_editor()
		return
	var filename: String = save_files[tab_idx]
	_refresh_raw_editor_for_file(filename)

func _refresh_raw_editor_for_file(filename: String) -> void:
	current_raw_filename = filename
	var data: Variant = save_data.get(filename, {})
	var json_string: String = JSON.stringify(data, "  ")
	is_updating_raw_from_code = true
	raw_editor.text = json_string
	is_updating_raw_from_code = false

func _clear_raw_editor() -> void:
	current_raw_filename = ""
	is_updating_raw_from_code = true
	raw_editor.text = ""
	is_updating_raw_from_code = false

func _on_raw_editor_changed() -> void:
	if is_updating_raw_from_code:
		return
	if current_raw_filename == "":
		return

	var text: String = raw_editor.text
	var json := JSON.new()
	var err: int = json.parse(text)
	if err != OK:
		return

	save_data[current_raw_filename] = json.data

	var current_idx := tab_container.current_tab
	if current_idx >= 0 and current_idx < save_files.size():
		var filename := save_files[current_idx]
		var current_tab := tab_container.get_child(current_idx)
		if current_tab:
			current_tab.queue_free()
			tab_container.remove_child(current_tab)

		create_save_tab(filename)
		tab_container.current_tab = current_idx

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mb := event as InputEventMouseButton
		if mb.pressed:
			var global_pos: Vector2 = get_viewport().get_mouse_position()
			var win_pos: Vector2 = Vector2(position)
			if drag_header.get_global_rect().has_point(global_pos):
				is_dragging = true
				drag_offset = global_pos - win_pos
		else:
			is_dragging = false

	elif event is InputEventMouseMotion and is_dragging:
		var global_pos2: Vector2 = get_viewport().get_mouse_position()
		var new_pos: Vector2 = global_pos2 - drag_offset
		position = Vector2i(new_pos)

func _on_save_button_pressed() -> void:
	if save_files.is_empty():
		return
	var filename: String = save_files[tab_container.current_tab]
	save_file(filename)

func save_file(filename: String) -> void:
	var path: String = "user://%s" % filename
	var data: Variant = save_data[filename]

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Cannot write to %s" % path)
		return

	var json_string: String = JSON.stringify(data, "  ")
	file.store_string(json_string)
	file.close()
	Reloader.reload()
	Reload.reload()
	print("Saved: %s" % filename)

func _on_close_button_pressed() -> void:
	visible = false
