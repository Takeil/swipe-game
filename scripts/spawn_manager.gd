extends Control

class_name SpawnManager

const TILE_SCENES = {
	"player": 		preload("res://scenes/tiles/player_tile.tscn"),
	"enemy": 		preload("res://scenes/tiles/enemy_tile.tscn"),
	"enemy2": 		preload("res://scenes/tiles/enemy2_tile.tscn"),
	"enemy3": 		preload("res://scenes/tiles/enemy3_tile.tscn"),
	"item_box": 	preload("res://scenes/tiles/item_box.tscn"),
	"movable_box": 	preload("res://scenes/tiles/movable_box.tscn"),
	"immovable": 	preload("res://scenes/tiles/immovable_tile.tscn"),
	"bomb": 		preload("res://scenes/tiles/bomb.tscn")
}

func get_score(type):
	var val = Board.Instance.get_combo_count()
	
	if type == 1:
		if val <= 30:
			return 45
		elif val <= 75:
			return 35
		else:
			return 30
	elif type == 2:
		if val <= 30:
			return 0
		elif val <= 75:
			return 10
		else:
			return 10
	elif type == 3:
		if val <= 30:
			return 0
		elif val <= 75:
			return 0
		else:
			return 5

func get_tile_weights() -> Dictionary:
	return {
		"enemy": get_score(1),
		"enemy2": get_score(2),
		"enemy3": get_score(3),
		"item_box": 5,
		"movable_box": 20,
		"immovable": 20,
		"bomb": 5
	}

func get_random_tile_type():
	var total_weight = get_tile_weights().values().reduce(func(a, b): return a + b)
	var rand = randi_range(0, total_weight)
	
	var cumulative = 0
	for type in get_tile_weights().keys():
		cumulative += get_tile_weights()[type]
		if rand < cumulative:
			return type
	return "enemy"  # Default in case of an error
