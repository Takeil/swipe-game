extends Node

func delete_children(parent : Node):
	for child in parent.get_children():
		child.free()

func instantiate_and_parent(child, parent):
	var instance = child.instantiate()
	parent.add_child(instance)
