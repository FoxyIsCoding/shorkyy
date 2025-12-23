extends Node

static var enabled: bool = true
static var volume: int = 80

func _ready():
	Debugger.debug_badge("AudioManager initialized")
	load_settings()
	apply_audio_settings()

static func load_settings():
	if not FileAccess.file_exists("user://settings.save"):
		Debugger.debug("AudioManager", "No settings file found, creating with defaults")
		save_settings() 
		return
	
	var save_file = FileAccess.open("user://settings.save", FileAccess.READ)
	
	var json_string = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		var data = json.data
		if typeof(data) == TYPE_DICTIONARY:
			enabled = data.get("enabled", true)
			volume = data.get("volume", 80)
			Debugger.debug("AudioManager","Settings loaded: enabled=" + str(enabled) + " volume=" + str(volume))
	else:
		Debugger.debug_error("audiomanager.gd - Error parsing settings file")

func apply_audio_settings():
	var audio_player = $AudioStreamPlayer
	
	if audio_player:
		var volume_db = linear_to_db(volume / 100.0)
		audio_player.volume_db = volume_db
		audio_player.stream_paused = !enabled
		Debugger.debug("AudioManager", "Audio settings applied to AudioStreamPlayer")
	else:
		Debugger.debug_error("audiomanager.gd - AudioStreamPlayer not found!")

static func save_settings():
	var save_data = {
		"enabled": enabled,
		"volume": volume
	}
	
	var save_file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(save_data))
		save_file.close()
		Debugger.debug("AudioManager", "Settings saved")
