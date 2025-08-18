extends Node

class_name ScoreManager
static var Instance : ScoreManager

var damage_dealt : int = 0
var items_collected : int = 0
var swipes_count : int = 0
var bomb_exploded : int = 0
var score : int = 0:
	set(value):
		if value != score:
			animate_score_change()
		score = value

var high_score = 0

const ITEM_VALUE = 5
const BOMB_HIT_VALUE = 10

var original_scale = Vector2(1, 1)
var original_color = Color(1, 1, 1)
var original_position = Vector2(0, 0)

@export var crown_image : TextureRect
@export var score_label : Label
@export var high_score_label : Label

@export var GO_score_label : Label

var multilplier = 1

func _ready():
	Instance = self
	reset_score()
	set_reset_score()
	high_score = Global.get_setting_data("high_score")
	high_score_label.text = str(high_score)

func reset_score():
	damage_dealt = 0
	items_collected = 0
	swipes_count = 0
	bomb_exploded = 0
	score = 0
	update_score_label()
	crown_image.visible = false

func add_score(amount: int):
	score += amount * multilplier
	update_score()

func add_damage(amount: int):
	damage_dealt += amount
	update_score()

func add_item():
	items_collected += 1
	update_score()

func bomb_damage():
	bomb_exploded += 1
	update_score()

func add_swipe():
	swipes_count += 1
	update_score()

func update_score():
	# score = damage_dealt + (items_collected * ITEM_VALUE) + (bomb_exploded * BOMB_HIT_VALUE)
	if !crown_image.visible and score > high_score:
		crown_image.visible = true
	update_score_label()
	trigger_score_feedback()

func update_score_label():
	if score > high_score:
		high_score = score
		Global.set_setting_data("high_score", score)
		
	if score_label:
		score_label.text = str(score)
	if high_score_label:
		high_score_label.text = str(high_score)
	
	GO_score_label.text = ("%s\n%s" % ["NEW HIGH SCORE" if score >= high_score else "SCORE", score])

func set_reset_score():
	original_scale = score_label.scale
	original_color = score_label.modulate
	original_position = score_label.position

func reset_score_display():
	score_label.scale = original_scale
	score_label.modulate = original_color
	score_label.position = original_position

func animate_score_change():
	reset_score_display()
	shake_score_label()

func shake_score_label():
	# Simple shake animation
	var score_tween = create_tween()
	score_tween.tween_property(score_label, "position", original_position + Vector2(5, 0), 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	score_tween.tween_property(score_label, "position", original_position - Vector2(5, 0), 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	score_tween.tween_property(score_label, "position", original_position, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func trigger_score_feedback():
	# Optional sound or particle feedback
	if has_node("ScoreParticle"):
		$ScoreParticle.restart()
	if has_node("ScoreSound"):
		$ScoreSound.play()

func get_score() -> int:
	return score
