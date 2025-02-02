extends Node

class_name GameController

@export var tiles : Node2D
@export var item_prefab : PackedScene
var cells : Array[Node2D]

static var Instance: GameController
static var ticker : int
var spawning = false

signal swipe

func _ready() -> void:
	Instance = self
	
	for child in tiles.get_children():
		cells.append(child)
	
	spawn_item(0, true)
	spawn_item(1, true)
	spawn_item(4, true)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		spawn_item(999,true)
	
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

func spawn_item(type: int = 999, override : bool = false) -> void:
	
	if randi_range(1, 100) <= 30 and !override:  # 70% chance to spawn
		return
	
	if type == 999:
		var chance = randi_range(1, 100)
		if chance <= 60:
			type = 1
		elif chance <= 75:
			type = 2
		elif chance <= 90:
			type = 3
		elif chance <= 99:
			type = 4
		else: 
			type = 0
	
	if !spawning:
		spawning = true
	else:
		return
	
	var spawn = randi_range(0, cells.size() - 1)
	
	if cells[spawn].get_child_count() != 1 :
		spawning = false
		spawn_item(type, true)
		return
	
	var instance = item_prefab.instantiate() as ItemCell
	#instance.position = cells[spawn].position
	cells[spawn].add_child(instance)
	var s = cells[spawn] as TileCell
	instance.setup(type)
	s.set_item(instance)
	spawning = false
