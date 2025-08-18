extends Tile
var explosion_particles = preload("res://effects/explosion_enemy.tscn")

func _ready():
	MAX_HEALTH = 1 #5
	hp = 1 # randi_range(2, 4)
	damage = 1 # randi_range(1, 2)
	type = 2
	is_movable = true

func die(_attacker):
	
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true
	
	Board.Instance.on_tile_hit()
	
	super(_attacker)
