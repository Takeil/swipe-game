extends Node

@export var tiles : Node2D
@export var item_prefab : PackedScene
var cells : Array[Node2D]
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	for child in tiles.get_children():
		cells.append(child)
		print(cells[0].get_child_count())
	rng.seed = hash(Time.get_datetime_string_from_system())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		spawn_item()

func spawn_item() -> void:
	rng.randi_range(0, 100)
	var spawn = randi_range(0, cells.size() - 1)
	
	if cells[spawn].get_child_count() != 1 :
		spawn_item()
		return
	
	var instance = item_prefab.instantiate()
	#instance.position = cells[spawn].position
	cells[spawn].add_child(instance)
