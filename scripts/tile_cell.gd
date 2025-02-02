extends Node2D

class_name TileCell

@export var left : TileCell
@export var right : TileCell
@export var up : TileCell
@export var down : TileCell

var item : ItemCell

func set_item(_item : ItemCell) -> void:
	item = _item

func clear_item() -> void:
	item = null

func _ready() -> void:
	GameController.Instance.connect('swipe', on_swipe)

func on_swipe(dir) -> void:
	if item != null:
		item.reset_damaged_by()
	
	match dir:
		'Left':
			if left != null:
				return
			slide_left(self)
		'Right':
			if right != null:
				return
			slide_right(self)
		'Up':
			if up != null:
				return
			slide_up(self)
		'Down':
			if down != null:
				return
			slide_down(self)

func slide_right(curr_cell: TileCell) -> void:
	if curr_cell.left == null:
		return
	if curr_cell.item != null:
		curr_cell.item.flip_to('right')
		var next_cell: TileCell = curr_cell.left
		while next_cell.left != null and next_cell.item == null:
			next_cell = next_cell.left
		if next_cell.item != null:
			next_cell.item.flip_to('right')
			var old_curr_item = curr_cell.item
			var old_next_item = next_cell.item
			if curr_cell.left.item != next_cell.item:
				next_cell.item.reparent(curr_cell.left)
				curr_cell.left.set_item(next_cell.item)
				next_cell.clear_item()
			if !old_curr_item.damage_by_enemy_and_health_check(old_next_item):
				old_curr_item.queue_free()
	else:
		var next_cell: TileCell = curr_cell.left
		while next_cell.left != null and next_cell.item == null:
			next_cell = next_cell.left
		if next_cell.item != null:
			next_cell.item.flip_to('right')
			next_cell.item.reparent(curr_cell)
			curr_cell.item = next_cell.item
			next_cell.item = null
			slide_right(curr_cell)
		if curr_cell.left == null:
			return
	slide_right(curr_cell.left)

func slide_left(curr_cell: TileCell) -> void:
	if curr_cell.right == null:
		return
	if curr_cell.item != null:
		curr_cell.item.flip_to('left')
		var next_cell: TileCell = curr_cell.right
		while next_cell.right != null and next_cell.item == null:
			next_cell = next_cell.right
		if next_cell.item != null:
			next_cell.item.flip_to('left')
			var old_curr_item = curr_cell.item
			var old_next_item = next_cell.item
			if curr_cell.right.item != next_cell.item:
				next_cell.item.reparent(curr_cell.right)
				curr_cell.right.set_item(next_cell.item)
				next_cell.clear_item()
			if !old_curr_item.damage_by_enemy_and_health_check(old_next_item):
				old_curr_item.queue_free()
	else:
		var next_cell: TileCell = curr_cell.right
		while next_cell.right != null and next_cell.item == null:
			next_cell = next_cell.right
		if next_cell.item != null:
			next_cell.item.flip_to('left')
			next_cell.item.reparent(curr_cell)
			curr_cell.item = next_cell.item
			next_cell.item = null
			slide_left(curr_cell)
		if curr_cell.right == null:
			return
	slide_left(curr_cell.right)

func slide_up(curr_cell: TileCell) -> void:
	if curr_cell.down == null:
		return
	
	if curr_cell.item != null:
		var next_cell: TileCell = curr_cell.down
		while next_cell.down != null and next_cell.item == null:
			next_cell = next_cell.down
		if next_cell.item != null:
			var old_curr_item = curr_cell.item
			var old_next_item = next_cell.item
			if curr_cell.down.item != next_cell.item:
				next_cell.item.reparent(curr_cell.down)
				curr_cell.down.set_item(next_cell.item)
				next_cell.clear_item()
			if !old_curr_item.damage_by_enemy_and_health_check(old_next_item):
				old_curr_item.queue_free()
	else:
		var next_cell: TileCell = curr_cell.down
		while next_cell.down != null and next_cell.item == null:
			next_cell = next_cell.down
		if next_cell.item != null:
			next_cell.item.reparent(curr_cell)
			curr_cell.item = next_cell.item
			next_cell.item = null
			slide_up(curr_cell)
		if curr_cell.down == null:
			return
	slide_up(curr_cell.down)

func slide_down(curr_cell: TileCell) -> void:
	if curr_cell.up == null:
		return
	
	if curr_cell.item != null:
		var next_cell: TileCell = curr_cell.up
		while next_cell.up != null and next_cell.item == null:
			next_cell = next_cell.up
		if next_cell.item != null:
			var old_curr_item = curr_cell.item
			var old_next_item = next_cell.item
			if curr_cell.up.item != next_cell.item:
				next_cell.item.reparent(curr_cell.up)
				curr_cell.up.set_item(next_cell.item)
				next_cell.clear_item()
			if !old_curr_item.damage_by_enemy_and_health_check(old_next_item):
				old_curr_item.queue_free()
	else:
		var next_cell: TileCell = curr_cell.up
		while next_cell.up != null and next_cell.item == null:
			next_cell = next_cell.up
		if next_cell.item != null:
			next_cell.item.reparent(curr_cell)
			curr_cell.item = next_cell.item
			next_cell.item = null
			slide_down(curr_cell)
		if curr_cell.up == null:
			return
	slide_down(curr_cell.up)
