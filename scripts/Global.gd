extends Node

var settings_file_path = "user://swipe_settings.json"

var settings_data = {
	"Music": 1,
	"Sound": 1,
	"high_score" : 0,
	"high_combo" : 0,
	"first_run" : 1,
}

func _ready() -> void:
	load_settings()

func set_setting_data(key : String, value):
	settings_data[key] = value
	save_settings()

func get_setting_data(key : String):
	return settings_data[key]

func save_settings():
	var f = FileAccess.open(settings_file_path, FileAccess.WRITE)
	f.store_var(settings_data)

func load_settings():
	if FileAccess.file_exists(settings_file_path):
		var f = FileAccess.open(settings_file_path, FileAccess.READ)
		var loaded_data = f.get_var()
		f.close()
		
		if loaded_data is Dictionary:
			for key in loaded_data:
				settings_data[key] = loaded_data[key]
	else:
		save_settings()

func play_sound(bus: String, audio: AudioStream, random_pitch : bool = false) -> void:
	var temp_player := AudioStreamPlayer.new()
	temp_player.stream = audio
	temp_player.bus = bus
	temp_player.autoplay = false
	temp_player.volume_db = 0.0
	get_tree().get_root().add_child(temp_player)
	temp_player.connect("finished", temp_player.queue_free)
	if random_pitch:
		temp_player.pitch_scale = randf_range(0.9, 1.1)
	temp_player.play()
