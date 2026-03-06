extends Control

class_name AchievementPopup

static var Instance

@export var popup : Control
@export var label : Label

var achievement_queue = []
var is_displaying = false

func _ready() -> void:
	Instance = self

func show_achievement_popup(ach_id: String):
	achievement_queue.append(ach_id)
	
	_process_queue()

func _process_queue():
	if is_displaying or achievement_queue.size() == 0:
		return
	
	is_displaying = true
	var current_ach = achievement_queue.pop_front()
	
	_animate_popup(current_ach)
	
func _animate_popup(ach_id: String):
	label.text = str(ach_id).replace("_", " ").capitalize()
	
	popup.modulate.a = 0.0
	var start_y = popup.position.y
	var target_y = start_y - 25
	
	var tween = create_tween()
	tween.set_parallel(false)
	
	tween.parallel().tween_property(popup, "position:y", target_y, 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(popup, "modulate:a", 1.0, 0.4)
	
	tween.tween_interval(3)
	
	tween.tween_property(popup, "position:y", start_y, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(popup, "modulate:a", 0.0, 0.4)
	
	# 5. Finish
	await tween.finished
	is_displaying = false
	_process_queue()
