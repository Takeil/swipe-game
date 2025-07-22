extends Control

class_name SpawnManager

const TILE_SCENES = {
	"player": 		preload("res://scenes/tiles/player_tile.tscn"),
	"enemy": 		preload("res://scenes/tiles/enemy_tile.tscn"),
	"item_box": 	preload("res://scenes/tiles/item_box.tscn"),
	"movable_box": 	preload("res://scenes/tiles/movable_box.tscn"),
	"immovable": 	preload("res://scenes/tiles/immovable_tile.tscn"),
	"bomb": 		preload("res://scenes/tiles/bomb.tscn")
}

# Tile spawn chances (higher means more common)
const TILE_WEIGHTS = {
	#"player": 1,
	"enemy": 45,
	"item_box": 5,
	"movable_box": 20,
	"immovable": 20,
	"bomb": 5
}

func get_random_tile_type():
	var total_weight = TILE_WEIGHTS.values().reduce(func(a, b): return a + b)
	var rand = randi_range(0, total_weight)
	
	var cumulative = 0
	for type in TILE_WEIGHTS.keys():
		cumulative += TILE_WEIGHTS[type]
		if rand < cumulative:
			return type
	return "enemy"  # Default in case of an error
