extends Node2D

class_name ItemCell

var damage = 1
var defense = 0
var health = 2

@export var movable = true

func _ready() -> void:
	modulate = Color(randf(), randf(), randf(), 1.0)

func _process(delta: float) -> void:
	if position != Vector2.ZERO:
		position = position.move_toward(Vector2.ZERO, delta * 500)

func damage_and_health_check(_damage):
	health = (health + defense) - _damage
	if (health <= 0):
		return false
	return true
