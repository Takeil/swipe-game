extends Node2D

class_name Sword

@export var target: Control  # Assign the Player node in the editor
@export var follow_speed: float = 10.0
@export var offset: Vector2 = Vector2(8, 16)  # Adjust as needed
@export var slash_angle: float = 1  # Radians (≈ 45 degrees)
@export var slash_duration: float = 0.15

static var Instance : Sword

var slashing := false
var last_flip := 1  # 1 = right, -1 = left

func _ready() -> void:
	Instance = self

func _process(delta):
	if !target:
		visible = false
		target = Board.Instance.get_player_child()
		return

	visible = true
	var target_position = target.global_position + offset
	var move_vector = target_position - global_position
	global_position = global_position.lerp(target_position, delta * follow_speed)

	if !slashing:
		if move_vector.length() > 1:
			rotation = move_vector.angle()

		# Flip if movement is mostly horizontal
		if abs(move_vector.x) > abs(move_vector.y):
			last_flip = -1 if move_vector.x < 0 else 1
			scale.y = last_flip

func set_offset(new_offset : Vector2):
	offset = new_offset

func slash():
	if slashing:
		return

	slashing = true
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	var original_rotation = rotation
	tween.tween_property(self, "rotation", original_rotation + slash_angle * last_flip, slash_duration * 0.5)
	tween.tween_property(self, "rotation", original_rotation, slash_duration * 0.5)

	await tween.finished
	slashing = false
