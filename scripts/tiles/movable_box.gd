extends Tile
var explosion_particles = preload("res://effects/explosion_box.tscn")

func _ready():
	hp = 1 # 5
	type = 4
	is_movable = true
	show_damage = false

func die(_attacker):
	
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true
	
	super(_attacker)
