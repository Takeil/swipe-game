extends CanvasLayer

class_name UIManager

@export var restart_button : Button
@export var continue_button : Button
@export var game_over_screen : Control
@export var settings_screen : Control
@export var ad_loading : Control
@onready var adMob = $"../Admob"

var is_initialized : bool = false

static var Instance : UIManager

const ADS_INTERVAL = 3
var curr_ads = 0;

func _ready():
	Instance = self
	toggle_game_over(false)
	restart_button.pressed.connect(_on_restart_pressed)
	
	adMob.initialize()
	adMob.load_interstitial_ad()
	adMob.load_rewarded_ad()

func toggle_game_over(val = !game_over_screen.visible):
	game_over_screen.visible = val

func _on_restart_pressed():
	Global.play_sound("Sound", preload("res://assets/sounds/restart.wav"))
	
	toggle_game_over(false)
	settings_screen.visible = false
	
	if ADManager.Instance.has_ad and is_initialized:
		curr_ads = curr_ads + 1
		if curr_ads >= ADS_INTERVAL:
			curr_ads = 0
			ad_loading.visible = true
			var success = await adMob.interstitial_ad_loaded.with_timeout(3.0)
			if success and adMob.is_interstitial_ad_loaded():
				adMob.show_interstitial_ad()
				adMob.load_interstitial_ad()
			else:
				print("Ad failed to load or show")
			ad_loading.visible = false
	
	Board.Instance.reset_board()
	continue_button.visible = true

func _open_settings_screen():
	Global.play_sound("Sound", preload("res://assets/sounds/click.wav"))
	Board.Instance.has_control = false
	settings_screen.visible = true

func _close_settings_screen():
	Global.play_sound("Sound", preload("res://assets/sounds/click2.wav"))
	Board.Instance.has_control = true
	settings_screen.visible = false

func _on_continue_button_pressed() -> void:
	game_over_screen.visible = false
	ad_loading.visible = true
	
	if is_initialized:
		var success = await adMob.rewarded_ad_loaded.with_timeout(3.0)

		if success and adMob.is_rewarded_ad_loaded():
			adMob.show_rewarded_ad()
			adMob.load_rewarded_ad()
		else:
			print("Ad failed to load or show")
			continue_game()
	else:
		print("Ad is not initialized")
		continue_game()
	
	ad_loading.visible = false

func _on_admob_initialization_completed(_status_data: InitializationStatus) -> void:
	is_initialized = true

func _on_admob_rewarded_ad_user_earned_reward(_ad_id: String, _reward_data: RewardItem) -> void:
	continue_game()

func continue_game(): 
	Global.play_sound("Sound", preload("res://assets/sounds/click2.wav"))
	toggle_game_over(false)
	Board.Instance.continue_game()
	continue_button.visible = false
	ad_loading.visible = false
