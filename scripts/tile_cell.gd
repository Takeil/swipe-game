extends Node

class_name tile_cell

@export var left : tile_cell
@export var right : tile_cell
@export var up : tile_cell
@export var down : tile_cell

func _ready() -> void:
	GameController.Instance.connect('swipe', swipe)

func swipe(dir) -> void:
	pass
