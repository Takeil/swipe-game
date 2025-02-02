extends Node2D

class_name ItemCell

const MAX_HP: int = 10

@export var movable: bool = true
@export var show_hp: bool = true

var damage: int = 0
var shield: int = 0
var health: int = 0

var hp_bar: Control = null
var df_bar: Control = null
var unit_sprite: AnimatedSprite2D = null
var box_sprite: AnimatedSprite2D = null
var immovable_sprite : AnimatedSprite2D = null
var item_sprite: Node2D = null

var damaged_by: Array[ItemCell] = []
var type = 0

@onready var pix = preload("res://scenes/misc/1px_texturerect.tscn")

func _ready() -> void:
	hp_bar = $Control/HPBarContainer
	df_bar = $Control/DFBarContainer
	unit_sprite = $UnitSprite
	box_sprite = $BoxSprite
	item_sprite = $ItemSprite
	immovable_sprite = $ImmovableSprite

func setup(_type : int):
	hp_bar = $Control/HPBarContainer
	df_bar = $Control/DFBarContainer
	unit_sprite = $UnitSprite
	box_sprite = $BoxSprite
	item_sprite = $ItemSprite
	immovable_sprite = $ImmovableSprite
	pix = preload("res://scenes/misc/1px_texturerect.tscn")
	
	type = _type
	show_type(_type)
	
	match _type:
		0 : 
			health = 2
			damage = 1
			shield = 2
			print('Friend')
		1 : 
			health = 2
			damage = 1
			shield = 2
			print('Enemy')
			modulate = Color(randf(), randf(), randf(), 1.0)
		2 : 
			health = 2
			damage = 0
			shield = 0
			print('Box')
			show_hp = false
		3 : 
			health = 0
			damage = 0
			shield = 0
			print('Item')
			movable = false
			show_hp = false
		4 : 
			health = 3
			damage = 0
			shield = 0
			print('Immovable Object')
			movable = false
			show_hp = false
	
	if show_hp:
		update_hp_def()

func show_type(type : int):
	unit_sprite.visible = type in [0, 1]
	box_sprite.visible = type == 2
	item_sprite.visible = type == 3
	immovable_sprite.visible = type == 4

func _process(delta: float) -> void:
	if position != Vector2.ZERO:
		position = position.move_toward(Vector2.ZERO, delta * 500)

func flip_to(dir : String):
	if type in [0,1]:
		match dir:
			'left':
				unit_sprite.flip_h = true
			'right':
				unit_sprite.flip_h = false
		pass

func update_hp_def() -> void:
	Global.delete_children(hp_bar)
	Global.delete_children(df_bar)
	
	for _i in health:
		Global.instantiate_and_parent(pix, hp_bar)
	
	for _i in shield:
		Global.instantiate_and_parent(pix, df_bar)

func reset_damaged_by() -> void:
	damaged_by.clear()

func damage_by_enemy_and_health_check(damaging_cell: ItemCell) -> bool:
	if damaged_by.has(damaging_cell):
		return true
	
	if damaging_cell.type == type or damaging_cell.type not in [0, 1]:
		return true
	
	damaged_by.append(damaging_cell)
	
	var excess_damage: int = 0
	shield -= damaging_cell.damage
	
	if shield < 0:
		excess_damage = shield
		shield = 0
	
	health += excess_damage
	
	if show_hp:
		update_hp_def()
	
	return health > 0
