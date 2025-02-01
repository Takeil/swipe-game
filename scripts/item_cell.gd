extends Node2D

class_name ItemCell

var MAX_HP = 10;

var damage = 1
var shield = 1
var health = 2

@export var movable = true
@export var show_hp = true
var pix = preload("res://scenes/misc/1px_texturerect.tscn")

var hp_bar = null
var df_bar = null

func _ready() -> void:
	hp_bar = $Control/HPBarContainer
	df_bar = $Control/DFBarContainer
	
	modulate = Color(randf(), randf(), randf(), 1.0)
	
	if show_hp:
		update_hp_def()

func _process(delta: float) -> void:
	if position != Vector2.ZERO:
		position = position.move_toward(Vector2.ZERO, delta * 500)

func damage_and_health_check(_damage):
	var excess = 0;
	shield = shield - _damage
	
	if shield < 0:
		excess = shield
		shield = 0
	health = health + excess
	
	if show_hp:
		update_hp_def()
	
	if (health <= 0):
		return false
	return true

func update_hp_def():
	Global.delete_children(hp_bar)
	Global.delete_children(df_bar)
	
	for n in health:
		Global.instantiate_and_parent(pix, hp_bar)
	
	for n in shield:
		Global.instantiate_and_parent(pix, df_bar)
	
