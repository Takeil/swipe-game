extends CanvasLayer

class_name UIController

var background_overlay : CanvasItem
var game_over_panel : CanvasItem
var crown_texture : CanvasItem
var high_score_label : Label

var data_file_path = "user://data.sav"
var score = 0

var saves_data = {
	"master": 1,
	"music": 1,
	"sounds": 1,
	"high_score": 0,
}

func _ready() -> void:
	background_overlay = $Control/BackgroundOverlay
	game_over_panel = $Control/GameOverPanel
	crown_texture = $"../Control/TextureRect/CrownRect"
	high_score_label = $"../Control/TextureRect/HighScore"
	GameController.Instance.connect('scored', _on_scored)
	load_data()
	
	high_score_label.text = str(saves_data['high_score'])
	
	crown_texture.visible = false
	set_background_overlay(false)
	set_game_over(false)
	

func set_background_overlay(value : bool) -> void:
	background_overlay.visible = value

func set_game_over(value : bool) -> void:
	if score > saves_data['high_score'] :
		saves_data['high_score'] = score
		save_data()
	
	game_over_panel.visible = value

func _on_restart_button_pressed() -> void:
	crown_texture.visible = false
	GameController.Instance.restart()

func _on_scored(_score : int):
	if _score > saves_data['high_score']:
		score = _score
		high_score_label.text = str(_score)
		if crown_texture.visible == false:
				crown_texture.visible = true

func load_data():
	if FileAccess.file_exists(data_file_path):
		var f = FileAccess.open(data_file_path, FileAccess.READ)
		saves_data = f.get_var()
		f.close()
	else:
		save_data()

func save_data():
	var f = FileAccess.open(data_file_path, FileAccess.WRITE)
	f.store_var(saves_data)
