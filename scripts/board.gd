extends Node

class_name Board

const GRID_SIZE = 5
const tile_size = 17
@export var tile_scene: PackedScene  # Drag `Tile.tscn` here in the Inspector
@export var combo_label : Label
@export var background_node : TextureRect
@export var combo_bar : ProgressBar
@onready var spawn_manager = $"../SpawnManager"
var grid = []

var length = 10
var startPos: Vector2
var curPos: Vector2
var swiping = false
var threshold = 100
var combo_count = 0
var combo_timer = 0.0
var combo_timeout = 1.5 #seconds

var has_control = true

static var Instance : Board

var combo_milestones = {
	0: {"color": Color(0.1, 0.4, 0.6)}, # default
	5: { "color": Color(0.2, 0.5, 0.5)}, # blue-green
	10: { "color": Color(0.2, 0.4, 0.3)}, # green
	15: { "color": Color(0.7, 0.6, 0.3)}, # yellow
	25: { "color": Color(0.8, 0.4, 0.2)}, # orange
	50: { "color": Color(0.5, 0.2, 0.2)}, # red
	75: { "color": Color(0.3, 0.2, 0.2)}, # maroon
	100: { "color": Color(0.1, 0.1, 0.1)}, # black
}

func _ready():
	Instance = self
	reset_board(false)

func _process(_delta: float) -> void:
	if !has_control:
		swiping = false
		return
	
	show_combo_text(combo_count)
	if combo_count > 0:
		combo_timer -= _delta
		if combo_timer <= 0:
			combo_count = 0
			change_background(combo_milestones[0]["color"])
			
		if combo_count == 0: 
			ScoreManager.Instance.multilplier = 1 
		else:
			ScoreManager.Instance.multilplier = combo_count
		if combo_bar:
			combo_bar.value = clamp(combo_timer / combo_timeout, 0.0, 1.0)
	else:
		if combo_timer:
			combo_bar.value = 0.0
	
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			startPos = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed("press"):
		if swiping:
			curPos = get_viewport().get_mouse_position()
			if startPos.distance_to(curPos) >= length:
				var delta_x = curPos.x - startPos.x
				var delta_y = curPos.y - startPos.y
				Sword.Instance.slash()
	
				if abs(delta_x) > abs(delta_y): # Horizontal swipe
					if abs(delta_y) <= threshold: # Ensure it's mostly horizontal
						if delta_x > 0:
							move_tiles_right()
							ScoreManager.Instance.add_swipe()
						else:
							move_tiles_left()
							ScoreManager.Instance.add_swipe()
				elif abs(delta_y) > abs(delta_x): # Vertical swipe
					if abs(delta_x) <= threshold: # Ensure it's mostly vertical
						if delta_y > 0:
							move_tiles_down()
							ScoreManager.Instance.add_swipe()
						else:
							move_tiles_up()
							ScoreManager.Instance.add_swipe()
				swiping = false
	else:
		swiping = false

func reset_board(reset_score = true):
	initialize_grid()
	spawn_tile("player")
	spawn_tile("enemy")
	spawn_tile("immovable")
	update_visuals()
	toggle_control(true)
	combo_count = 0
	change_background(combo_milestones[0]["color"])
	if (reset_score):
		ScoreManager.Instance.multilplier = 1 
		ScoreManager.Instance.reset_score()

func continue_game():
	toggle_control(true)
	spawn_tile("player")

func initialize_grid():
	grid = []
	for row in range(GRID_SIZE):
		grid.append([null, null, null, null, null])
	for child in get_children():
		child.queue_free()

func print_grid():
	for row in grid:
		print(row)

func spawn_tile(type = "random"):
	var empty_positions = []
	
	# Find all empty positions in the grid
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			if grid[row][col] == null:
				empty_positions.append(Vector2i(row, col))
	
	# If there's space, spawn a new tile
	if empty_positions.size() > 0:
		var random_pos = empty_positions.pick_random()
		
		# Instead of a fixed tile type, get a random one using weighted logic
		var tile_instance
		if type != "random":
			tile_instance = spawn_manager.TILE_SCENES[type].instantiate()
		else:
			var tile_type = spawn_manager.get_random_tile_type()
			tile_instance = spawn_manager.TILE_SCENES[tile_type].instantiate()
		
		# Place the tile in the grid and scene
		grid[random_pos.x][random_pos.y] = tile_instance
		tile_instance.fade_in()
		add_child(tile_instance)
		
		# Convert grid position to world position
		tile_instance.position = Vector2(random_pos.y * tile_size, random_pos.x * tile_size)


func _unhandled_input(event):
	if !has_control:
		return
	
	# Keyboard input (for desktop)
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_UP:
				move_tiles_up()
				Sword.Instance.slash()
				ScoreManager.Instance.add_swipe()
			KEY_DOWN:
				move_tiles_down()
				Sword.Instance.slash()
				ScoreManager.Instance.add_swipe()
			KEY_LEFT:
				move_tiles_left()
				Sword.Instance.slash()
				ScoreManager.Instance.add_swipe()
			KEY_RIGHT:
				move_tiles_right()
				Sword.Instance.slash()
				ScoreManager.Instance.add_swipe()
			KEY_SPACE:
				spawn_tile()
			KEY_R:
				reset_board()

func move_tiles_left():
	Sword.Instance.set_offset(Vector2(2, 8))
	for row in range(GRID_SIZE):
		var target_col = 0  # Position to move the next movable tile into
		var last_tile = null
		for col in range(GRID_SIZE):
			var tile = grid[row][col]
			if tile != null:
				if last_tile != null:
					last_tile.take_damage(tile)
				if tile.is_movable:
					# Try to move as far left as possible until blocked
					var new_col = target_col
					while new_col > 0 and grid[row][new_col - 1] == null:
						new_col -= 1

					# Check if next position is blocked by immovable
					if new_col > 0 and grid[row][new_col - 1] != null:
						var next_tile = grid[row][new_col - 1]
						if !next_tile.is_movable:
							# Stop right before the immovable tile
							new_col = new_col

					# Move the tile if its position changed
					if new_col != col:
						grid[row][col] = null
						grid[row][new_col] = tile

					target_col = new_col + 1
				else:
					# If immovable, it becomes a barrier for next tiles
					target_col = col + 1
				last_tile = tile
	on_swipe_complete()

func move_tiles_right():
	Sword.Instance.set_offset(Vector2(14, 8))
	for row in range(GRID_SIZE):
		var target_col = GRID_SIZE - 1
		var last_tile = null
		for col in range(GRID_SIZE - 1, -1, -1):
			var tile = grid[row][col]
			if tile != null:
				if last_tile != null:
					last_tile.take_damage(tile)
				if tile.is_movable:
					var new_col = target_col
					while new_col < GRID_SIZE - 1 and grid[row][new_col + 1] == null:
						new_col += 1

					if new_col < GRID_SIZE - 1 and grid[row][new_col + 1] != null:
						var next_tile = grid[row][new_col + 1]
						if !next_tile.is_movable:
							new_col = new_col

					if new_col != col:
						grid[row][col] = null
						grid[row][new_col] = tile

					target_col = new_col - 1
				else:
					target_col = col - 1
				last_tile = tile
	on_swipe_complete()

func move_tiles_up():
	Sword.Instance.set_offset(Vector2(8, 2))
	for col in range(GRID_SIZE):
		var target_row = 0
		var last_tile = null
		for row in range(GRID_SIZE):
			var tile = grid[row][col]
			if tile != null:
				if last_tile != null:
					last_tile.take_damage(tile)
				if tile.is_movable:
					var new_row = target_row
					while new_row > 0 and grid[new_row - 1][col] == null:
						new_row -= 1

					if new_row > 0 and grid[new_row - 1][col] != null:
						var next_tile = grid[new_row - 1][col]
						if !next_tile.is_movable:
							new_row = new_row

					if new_row != row:
						grid[row][col] = null
						grid[new_row][col] = tile

					target_row = new_row + 1
				else:
					target_row = row + 1
				last_tile = tile
	on_swipe_complete()

func move_tiles_down():
	Sword.Instance.set_offset(Vector2(8, 14))
	for col in range(GRID_SIZE):
		var target_row = GRID_SIZE - 1
		var last_tile = null
		for row in range(GRID_SIZE - 1, -1, -1):
			var tile = grid[row][col]
			if tile != null:
				if last_tile != null:
					last_tile.take_damage(tile)
				if tile.is_movable:
					var new_row = target_row
					while new_row < GRID_SIZE - 1 and grid[new_row + 1][col] == null:
						new_row += 1

					if new_row < GRID_SIZE - 1 and grid[new_row + 1][col] != null:
						var next_tile = grid[new_row + 1][col]
						if !next_tile.is_movable:
							new_row = new_row

					if new_row != row:
						grid[row][col] = null
						grid[new_row][col] = tile

					target_row = new_row - 1
				else:
					target_row = row - 1
				last_tile = tile
	on_swipe_complete()

func update_visuals():
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var tile = grid[row][col]
			if tile != null:
				var target_position = Vector2(col * tile_size, row * tile_size)
				var direction = (target_position - tile.position).normalized()

				# Flip Sprite2D left/right for type 1 and 2
				if tile.type == 1 or tile.type == 2:
					var sprite = tile.get_node_or_null("Sprite2D")
					if sprite:
						if abs(direction.x) > abs(direction.y):
							sprite.flip_h = direction.x < 0  # true if moving left
						# Do nothing if mostly vertical

				# Stop any existing tween on the tile
				if tile.has_meta("active_tween"):
					var old_tween = tile.get_meta("active_tween")
					if old_tween and old_tween.is_valid():
						old_tween.kill()
						tile.scale = Vector2(1, 1)

				# Create a new tween
				var tween = get_tree().create_tween()
				tile.set_meta("active_tween", tween)
				tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

				if tile.is_movable and tile.position != target_position:
					# Directional squash and stretch
					var squash_scale = Vector2(1, 1)
					if abs(direction.x) > abs(direction.y):
						squash_scale = Vector2(1.2, 0.8)  # Horizontal
					else:
						squash_scale = Vector2(0.8, 1.2)  # Vertical

					# Animate movement and squash
					tween.tween_property(tile, "scale", squash_scale, 0.05)
					tween.parallel().tween_property(tile, "position", target_position, 0.1)
					tween.tween_property(tile, "scale", Vector2(1, 1), 0.05).set_delay(0.1)
					tween.tween_property(tile, "position", target_position, 0.03).set_delay(0.1)
				else:
					# Static or immovable tiles
					tween.tween_property(tile, "position", target_position, 0.1)

func on_swipe_complete():
	update_visuals()
	spawn_tile()
	
	if combo_count > 0 and combo_timer > 0:
		combo_timer = min(combo_timeout, combo_timer + 0.3)
	
	await get_tree().create_timer(0.5).timeout
	check_game_over()

func toggle_control(toggle : bool = !has_control):
	has_control = toggle
	pass

func check_game_over():
	var player_exists = false
	for row in grid:
		for tile in row:
			if tile != null and tile.type == 1:
				player_exists = true
				break
	if not player_exists:
		game_over()

func reset_combo_timer():
	if combo_bar:
		combo_bar.value = 1.0
	

func on_tile_hit():
	combo_count += 1
	combo_timer = combo_timeout
	
	reset_combo_timer()
	check_combo_bonus(combo_count)

func show_combo_text(count):
	combo_label.text = "x" + str(count)

func check_combo_bonus(count):
	if combo_milestones.has(count):
		var milestone = combo_milestones[count]
		change_background(milestone["color"])

func change_background(new_color):
	if background_node:
		var tween = create_tween()
		tween.tween_property(background_node, "self_modulate", new_color, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func get_player_child():
	for child in get_children():
		if child is Tile and child.type == 1:
			return child
	return null

func game_over():
	toggle_control(false)
	UIManager.Instance.toggle_game_over(true)
