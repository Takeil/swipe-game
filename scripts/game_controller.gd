extends Node

class_name GameController

@export var tiles : Node2D
@export var item_prefab : PackedScene
var cells : Array[Node2D]
var rng = RandomNumberGenerator.new()

static var Instance: GameController
static var ticker : int
var spawning = false

signal swipe

func _ready() -> void:
	Instance = self
	
	for child in tiles.get_children():
		cells.append(child)
	rng.seed = hash(Time.get_datetime_string_from_system())
	
	spawn_item(0)
	spawn_item(0)
	spawn_item(1)
	spawn_item(4)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		spawn_item()
	
	if Input.is_action_just_pressed('right'):
		swipe.emit('Right')
		spawn_item()
	if Input.is_action_just_pressed('left'):
		swipe.emit('Left')
		spawn_item()
	if Input.is_action_just_pressed('up'):
		swipe.emit('Up')
		spawn_item()
	if Input.is_action_just_pressed('down'):
		swipe.emit('Down')
		spawn_item()

func spawn_item(type = randi_range(1, 4)) -> void:
	if !spawning:
		spawning = true
	
	else:
		return
	
	rng.randi_range(0, 100)
	var spawn = randi_range(0, cells.size() - 1)
	
	if cells[spawn].get_child_count() != 1 :
		spawning = false
		spawn_item(type)
		return
	
	var instance = item_prefab.instantiate() as ItemCell
	#instance.position = cells[spawn].position
	cells[spawn].add_child(instance)
	var s = cells[spawn] as TileCell
	instance.setup(type)
	s.set_item(instance)
	spawning = false
