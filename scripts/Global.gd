extends Node

func delete_children(parent : Node):
	for child in parent.get_children():
		child.free()

func instantiate_and_parent(child, parent):
	var instance = child.instantiate()
	parent.add_child(instance)

func get_highest_ally_stats() -> int:
	var tiles_node = get_node_or_null("/root/Main/Tiles")
	if tiles_node == null:
		print("Tiles node not found!")
		return 2  # Default value if no allies are found
	
	var highest_stat = 2
	
	for tile in tiles_node.get_children():
		if tile is TileCell and tile.item and is_instance_valid(tile.item):  # Check if tile.item is valid
			if tile.item.type == 0:
				var max_stat = max(tile.item.health, tile.item.shield, tile.item.damage)
				highest_stat = max(highest_stat, max_stat)
	
	return highest_stat
