extends Node

class_name GameController

@export var tiles : Node2D
@export var item_prefab : PackedScene
var cells : Array[Node2D]
var rng = RandomNumberGenerator.new()

static var Instance: GameController
signal swipe

func _ready() -> void:
	Instance = self
	
	for child in tiles.get_children():
		cells.append(child)
	rng.seed = hash(Time.get_datetime_string_from_system())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		spawn_item()
	
	if Input.is_action_just_pressed('right'):
		swipe.emit('Right')
	if Input.is_action_just_pressed('left'):
		swipe.emit('Left')
	if Input.is_action_just_pressed('up'):
		swipe.emit('Up')
	if Input.is_action_just_pressed('down'):
		swipe.emit('Down')

func spawn_item() -> void:
	rng.randi_range(0, 100)
	var spawn = randi_range(0, cells.size() - 1)
	
	if cells[spawn].get_child_count() != 1 :
		spawn_item()
		return
	
	var instance = item_prefab.instantiate()
	#instance.position = cells[spawn].position
	cells[spawn].add_child(instance)
	var s = cells[spawn] as TileCell
	s.set_item(instance)
