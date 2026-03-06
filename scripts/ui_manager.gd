extends CanvasLayer

class_name UIManager

@export var restart_button : Button
@export var continue_button : Button
@export var settings_button : Button
@export var game_over_screen : Control
@export var settings_screen : Control

@export var tutorial_screen : Control
@export var tutorial_animator : AnimatedSprite2D
var tutorial_page = 1

@export var ad_loading : Control
@onready var adMob = $"../Admob"

var is_initialized : bool = false

static var Instance : UIManager

var tries = 0
const ADS_INTERVAL = 3
var curr_ads = 0;
var reward_earned = false
var settings_animator : AnimationPlayer
var continues = 0
const CONTINUE_LIMIT = 2

func _unhandled_input(event):
	
	if game_over_screen.visible:
		if event.is_action_pressed("controller_b") and continue_button.visible:
			_on_continue_button_pressed()
		elif event.is_action_pressed("controller_a"):
			_on_restart_pressed()
	elif tutorial_screen.visible:
		if event.is_action_pressed("ui_left"):
			_change_tutorial_page(-1)
		elif event.is_action_pressed("ui_right"):
			_change_tutorial_page(1)
		elif event.is_action_pressed("settings") or event.is_action_pressed("controller_a"):
			_close_tutorial_screen()
	elif settings_screen.visible:
		if event.is_action_pressed("controller_x"):
			_on_restart_pressed(true)
		elif event.is_action_pressed("controller_y"):
			_open_tutorial_screen()
		elif event.is_action_pressed("controller_b"):
			ADManager.Instance._on_toggled(!ADManager.Instance.has_ad)
		elif event.is_action_pressed("controller_a"):
			_toggle_settings_screen()
		elif event.is_action_pressed("ui_left"):
			Volume.Instance._on_minus_button_pressed()
		elif event.is_action_pressed("ui_right"):
			Volume.Instance._on_plus_button_pressed()
		elif event.is_action_pressed("settings"):
			_toggle_settings_screen()
	else:
		if event.is_action_pressed("reset"):
			_on_restart_pressed()
		if event.is_action_pressed("settings"):
			_toggle_settings_screen()
		

func _ready():
	Instance = self
	toggle_game_over(false)
	restart_button.pressed.connect(_on_restart_pressed)
	adMob.initialize()
	settings_animator = settings_button.find_child("AnimationPlayer")
	
	if Global.get_setting_data("first_run") == 1:
		_open_tutorial_screen()

func toggle_game_over(val = !game_over_screen.visible):
	game_over_screen.visible = val
	if val:
		settings_button.visible = false
	if not is_initialized:
		continue_button.visible = false

func restart():
	reward_earned = false
	ad_loading.visible = false
	Board.Instance.reset_board()
	continue_button.visible = true
	continues = 0

func _on_restart_pressed(is_from_settings = false):
	Global.play_sound("Sound", preload("res://assets/sounds/restart.wav"))
	
	toggle_game_over(false)
	settings_button.visible = true
	if is_from_settings:
		hide_settings_screen()
	
	if ADManager.Instance.has_ad:
		curr_ads = curr_ads + 1
		if curr_ads >= ADS_INTERVAL:
			ad_loading.visible = true
			if is_initialized:
				if adMob.is_interstitial_ad_loaded():
					adMob.show_interstitial_ad()
				adMob.load_interstitial_ad()
			else:
				printerr("Ad is not initialized")
				# Retry initialization
				adMob.initialize()
			curr_ads = 0
	
	restart()

func _toggle_settings_screen():
	if settings_screen.visible == true:
		hide_settings_screen(true)
	else:
		show_settings_screen(true)

func show_settings_screen(play_sound = false) -> void:
	if play_sound:
		Global.play_sound("Sound", preload("res://assets/sounds/click.wav"))
	Board.Instance.has_control = false
	settings_screen.visible = true
	if settings_animator.current_animation != "open":
		settings_animator.play("open")

func hide_settings_screen(play_sound = false) -> void:
	if play_sound:
		Global.play_sound("Sound", preload("res://assets/sounds/click2.wav"))
	Board.Instance.has_control = true
	settings_screen.visible = false
	if settings_animator.current_animation != "close":
		settings_animator.play("close")

func _on_continue_button_pressed() -> void:
	game_over_screen.visible = false
	ad_loading.visible = true
	
	if is_initialized:
		if adMob.is_rewarded_ad_loaded():
			adMob.show_rewarded_ad()
		else:
			printerr("Ad failed to load or show")
			continue_game()
		adMob.load_rewarded_ad()
	else:
		printerr("Ad is not initialized")
		continue_game()

func _on_admob_initialization_completed(_status_data: InitializationStatus) -> void:
	is_initialized = true
	continue_button.visible = true
	adMob.load_interstitial_ad()
	adMob.load_rewarded_ad()

func _on_admob_rewarded_ad_dismissed_full_screen_content(_ad_id: String) -> void:
	if reward_earned != true:
		restart()
	else:
		continue_game()

func _on_admob_rewarded_ad_user_earned_reward(_ad_id: String, _reward_data: RewardItem) -> void:
	reward_earned = true

func continue_game(): 
	Global.play_sound("Sound", preload("res://assets/sounds/click2.wav"))
	toggle_game_over(false)
	Board.Instance.continue_game()
	Board.Instance.reset_combo_timer()
	settings_button.visible = true
	ad_loading.visible = false
	continues += 1
	
	if continues >= CONTINUE_LIMIT:
		continue_button.visible = false

func _close_tutorial_screen():
	Global.play_sound("Sound", preload("res://assets/sounds/click.wav"))
	tutorial_screen.visible = false
	Board.Instance.has_control = true
	Global.set_setting_data('first_run', 0)

func _open_tutorial_screen():
	_change_tutorial_page(0, 1)
	Global.play_sound("Sound", preload("res://assets/sounds/click.wav"))
	hide_settings_screen()
	tutorial_screen.visible = true
	Board.Instance.has_control = false

func _change_tutorial_page(delta: int, override : int = 0):
	var target = tutorial_page + delta
	if override != 0:
		target = override
	var anim = "page%d" % target
	
	if tutorial_animator.sprite_frames.has_animation(anim):
		Global.play_sound("Sound", preload("res://assets/sounds/click.wav"))
		tutorial_page = target
		tutorial_animator.play(anim)
