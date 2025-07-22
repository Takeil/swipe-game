extends CheckBox

class_name ADManager

@export var dog : Node2D

static var Instance : ADManager
var has_ad = true

func _ready():
	Instance = self

func _on_toggled(toggled_on: bool) -> void:
	has_ad = toggled_on
	
	print(has_ad)
	if toggled_on:
		Global.play_sound("Sound", preload("res://assets/sounds/happy.wav"))
	else:
		Global.play_sound("Sound", preload("res://assets/sounds/sad.wav"))
	dog.visible = toggled_on
