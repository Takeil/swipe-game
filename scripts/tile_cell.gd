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
	if (dir == 'Left'):
		if left != null:
			return
		slide_left(self)
	if (dir == 'Right'):
		if right != null:
			return
		slide_right(self)
	if (dir == 'Up'):
		if up != null:
			return
		slide_up(self)
	if (dir == 'Down'):
		if down != null:
			return
		slide_down(self)

func slide_right(curr_cell: TileCell) -> void:
	if curr_cell.left == null:
		return
	
	var next_cell: TileCell = curr_cell.left
	while next_cell.left != null and next_cell.item == null:
		next_cell = next_cell.left
	
	if next_cell.item != null:
		if curr_cell.item == null:
			next_cell.item.reparent(curr_cell)
			curr_cell.set_item(next_cell.item)
			next_cell.clear_item()
			slide_right(curr_cell)
		elif curr_cell.left.item != next_cell.item:
			next_cell.item.reparent(curr_cell.left)
			if curr_cell.item != null:
				if !curr_cell.item.damage_and_health_check(next_cell.item.damage):
					curr_cell.item.queue_free()
					curr_cell.clear_item()
			curr_cell.left.set_item(next_cell.item)
			next_cell.clear_item()
	
	slide_right(curr_cell.left)

func slide_left(curr_cell: TileCell) -> void:
	if curr_cell.right == null:
		return
	
	var next_cell: TileCell = curr_cell.right
	while next_cell.right != null and next_cell.item == null:
		next_cell = next_cell.right
	
	if next_cell.item != null:
		if curr_cell.item == null:
			next_cell.item.reparent(curr_cell)
			curr_cell.set_item(next_cell.item)
			next_cell.clear_item()
			slide_left(curr_cell)
		elif curr_cell.right.item != next_cell.item:
			next_cell.item.reparent(curr_cell.right)
			if curr_cell.item != null:
				if !curr_cell.item.damage_and_health_check(next_cell.item.damage):
					curr_cell.item.queue_free()
					curr_cell.clear_item()
			curr_cell.right.set_item(next_cell.item)
			next_cell.clear_item()
	
	slide_left(curr_cell.right)

func slide_up(curr_cell: TileCell) -> void:
	if curr_cell.down == null:
		return
	
	var next_cell: TileCell = curr_cell.down
	while next_cell.down != null and next_cell.item == null:
		next_cell = next_cell.down
	
	if next_cell.item != null:
		if curr_cell.item == null:
			next_cell.item.reparent(curr_cell)
			curr_cell.set_item(next_cell.item)
			next_cell.clear_item()
			slide_up(curr_cell)
		elif curr_cell.down.item != next_cell.item:
			next_cell.item.reparent(curr_cell.down)
			if curr_cell.item != null:
				if !curr_cell.item.damage_and_health_check(next_cell.item.damage):
					curr_cell.item.queue_free()
					curr_cell.clear_item()
			curr_cell.down.set_item(next_cell.item)
			next_cell.clear_item()
	
	slide_up(curr_cell.down)

func slide_down(curr_cell: TileCell) -> void:
	if curr_cell.up == null:
		return
	
	var next_cell: TileCell = curr_cell.up
	while next_cell.up != null and next_cell.item == null:
		next_cell = next_cell.up
	
	if next_cell.item != null:
		if curr_cell.item == null:
			next_cell.item.reparent(curr_cell)
			curr_cell.set_item(next_cell.item)
			next_cell.clear_item()
			slide_down(curr_cell)
		elif curr_cell.up.item != next_cell.item:
			next_cell.item.reparent(curr_cell.up)
			if curr_cell.item != null:
				if !curr_cell.item.damage_and_health_check(next_cell.item.damage):
					curr_cell.item.queue_free()
					curr_cell.clear_item()
			curr_cell.up.set_item(next_cell.item)
			next_cell.clear_item()
	
	slide_down(curr_cell.up)
