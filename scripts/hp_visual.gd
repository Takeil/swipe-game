extends Node

class_name HPVisual

static var Instance : HPVisual

var heart = preload("res://assets/images/heart.png")
var heart_broken = preload("res://assets/images/heart-broken.png")

func _ready() -> void:
	Instance = self

func setup():
	PlayerTile.Instance.on_change_hp.connect(on_change_hp)
	update_visual()

func on_change_hp():
	update_visual()

func update_visual():
	var hp := PlayerTile.Instance.hp
	var hearts := get_children()

	for i in hearts.size():
		var heart_node := hearts[i] as TextureRect
		heart_node.texture = heart if i < hp else heart_broken
