extends Node2D

class_name ItemCell

const MAX_HP: int = 5

@export var movable: bool = true
@export var show_hp: bool = true

var damage: int = 0
var shield: int = 0
var health: int = 0

var hp_bar : Control = null
var df_bar : Control = null

var at_bar1 : Control = null

var unit_sprite: AnimatedSprite2D = null
var box_sprite: AnimatedSprite2D = null
var immovable_sprite : AnimatedSprite2D = null
var item_sprite: Node2D = null

var item_sprite_visual : AnimatedSprite2D = null
var item_label : Label = null

var animation_player : AnimationPlayer = null

var damaged_by: Array[ItemCell] = []
var type = 0
var item_type = 0
var item_value = 0

@onready var pix = preload("res://scenes/misc/1px_texturerect.tscn")

func setup(_type : int):
	animation_player = $AnimationPlayer
	
	hp_bar = $Control/HPBarContainer
	df_bar = $Control/DFBarContainer
	
	at_bar1 = $Control/ATBarContainer
	
	unit_sprite = $UnitSprite
	box_sprite = $BoxSprite
	item_sprite = $ItemSprite
	immovable_sprite = $ImmovableSprite
	
	item_sprite_visual = $ItemSprite/AnimatedSprite2D
	item_label = $ItemSprite/Control/Label
	
	pix = preload("res://scenes/misc/1px_texturerect.tscn")
	
	type = _type
	show_type(_type)
	
	animation_player.play('spawn-in')
	
	match _type:
		0 : 
			health = 2
			damage = 1
			shield = 2
			print('Friend')
		1 : 
			var highest = Global.get_highest_ally_stats()
			health = randi_range(1, highest)
			damage = randi_range(1, highest)
			shield = randi_range(1, health)
			print('Enemy')
			modulate = Color(randf(), randf(), randf(), 1.0)
		2 : 
			health = 3
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
			item_type = randi_range(0, 2)
			item_value = randi_range(1, 2)
			item_sprite_visual.frame = item_type
			item_label.text = '+' + str(item_value)
		4 : 
			health = 5
			damage = 0
			shield = 0
			print('Immovable Object')
			movable = false
			show_hp = false
	
	if show_hp:
		update_hp_def()

func show_type(_type : int):
	unit_sprite.visible = _type in [0, 1]
	box_sprite.visible = _type == 2
	item_sprite.visible = _type == 3
	immovable_sprite.visible = _type == 4

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

func get_item(_item_type, _item_value):
	match _item_type:
		0:
			damage += _item_value
			if damage >= MAX_HP:
				damage = MAX_HP
		1:
			shield += _item_value
			if shield >= health:
				shield = health
		2:
			health += _item_value
			if health >= MAX_HP:
				health = MAX_HP
	update_hp_def()

func update_hp_def() -> void:
	Global.delete_children(hp_bar)
	Global.delete_children(df_bar)
	
	Global.delete_children(at_bar1)
	
	for _i in health:
		Global.instantiate_and_parent(pix, hp_bar)
	
	for _i in shield:
		Global.instantiate_and_parent(pix, df_bar)
	
	for _i in damage:
		Global.instantiate_and_parent(pix, at_bar1)

func reset_damaged_by() -> void:
	damaged_by.clear()

func damage_by_enemy_and_health_check(damaging_cell: ItemCell) -> bool:
	if damaged_by.has(damaging_cell):
		return true
	
	if damaging_cell.type == type or damaging_cell.type not in [0, 1]:
		return true
	
	damaged_by.append(damaging_cell)
	
	if damaging_cell.type in [0, 1] and type != 3:
		damaging_cell.unit_sprite.play("attack")
		if not damaging_cell.unit_sprite.animation_finished.is_connected(damaging_cell.on_attack_animation_finished):
			damaging_cell.unit_sprite.animation_finished.connect(damaging_cell.on_attack_animation_finished.bind(damaging_cell))
	
	var excess_damage: int = 0
	shield -= damaging_cell.damage
	
	if shield < 0:
		excess_damage = shield
		shield = 0
	
	health += excess_damage
	
	if show_hp:
		update_hp_def()
	
	return health > 0

func on_attack_animation_finished(damaging_cell: ItemCell):
	if damaging_cell and damaging_cell.unit_sprite:
		damaging_cell.unit_sprite.play("idle")
		damaging_cell.unit_sprite.animation_finished.disconnect(damaging_cell.on_attack_animation_finished)

func die():
	unit_sprite.play("die")
	if unit_sprite.animation_finished.is_connected(_on_death_animation_finished) == false:
		unit_sprite.animation_finished.connect(_on_death_animation_finished)

func _on_death_animation_finished():
	unit_sprite.animation_finished.disconnect(_on_death_animation_finished)
	queue_free()
