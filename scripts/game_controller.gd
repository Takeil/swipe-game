extends Node

class_name GameController

@export var tiles : Node2D
@export var item_prefab : PackedScene
@export var score_label : Label
@export var ui_controller : UIController

static var Instance: GameController
static var ticker : int

var cells : Array[Node2D]
var score = 0
var spawning = false

signal swipe
signal scored(score)

func _ready() -> void:
	Instance = self
	
	for child in tiles.get_children():
		cells.append(child)
	
	spawn_item(0, true)
	spawn_item(1, true)
	spawn_item(4, true)

func restart() -> void:
	score = 0
	score_label.text = '0'
	ui_controller.set_game_over(false)
	
	for cell in cells:
		if cell.get_child_count() == 2:
			cell.clear_item()
			cell.get_child(1).queue_free()
	
	await get_tree().create_timer(0.2).timeout
	
	spawn_item(0, true)
	spawn_item(1, true)
	spawn_item(4, true)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		spawn_item(999,true)
		
	if Input.is_action_just_pressed('right'):
		handle_swipe('Right')
	elif Input.is_action_just_pressed('left'):
		handle_swipe('Left')
	elif Input.is_action_just_pressed('up'):
		handle_swipe('Up')
	elif Input.is_action_just_pressed('down'):
		handle_swipe('Down')

func handle_swipe(direction: String) -> void:
	swipe.emit(direction)
	spawn_item()
	game_over_check()

func game_over_check():
	var has_friendly = false
	
	for cell in cells:
		if cell.item != null:
			if cell.item.type == 0:
				has_friendly = true
	
	if !has_friendly:
		ui_controller.set_game_over(true)
		return

func spawn_item(type: int = 999, override : bool = false) -> void:
	var is_full = true
	
	for cell in cells:
		if cell.item == null and cell.get_child_count() == 1:
			is_full = false
	
	if is_full:
		print('full')
		return
	
	if randi_range(1, 100) <= 30 and !override:  # 70% chance to spawn
		return
	
	if type == 999:
		var chance = randi_range(1, 100)
		if chance <= 50:
			type = 1
		elif chance <= 60:
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

func add_score(value : int):
	score += value
	score_label.text = str(score)
	scored.emit(score)
	pass
