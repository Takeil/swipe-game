extends Node2D

class_name ItemCell

const MAX_HP: int = 10

@export var movable: bool = true
@export var show_hp: bool = true

var damage: int = 1
var shield: int = 1
var health: int = 2

var hp_bar: Control = null
var df_bar: Control = null

var damaged_by: Array[ItemCell] = []

@onready var pix = preload("res://scenes/misc/1px_texturerect.tscn")

func _ready() -> void:
	hp_bar = $Control/HPBarContainer
	df_bar = $Control/DFBarContainer
	
	modulate = Color(randf(), randf(), randf(), 1.0)
	
	if show_hp:
		update_hp_def()

func _process(delta: float) -> void:
	if position != Vector2.ZERO:
		position = position.move_toward(Vector2.ZERO, delta * 500)

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
