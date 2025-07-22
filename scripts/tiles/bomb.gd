extends Tile
var explosion_particles = preload("res://effects/explosion.tscn")

func _ready():
	hp = 1
	type = 4
	damage = 2
	is_movable = false  # Bombs are not movable
	show_damage = false

func die(_attacker):
	# Explode and deal damage to surrounding tiles
	Global.play_sound("Sound", preload("res://assets/sounds/explosion.wav"))
	
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true
	
	for tile in get_parent().get_children():
		# Check if the tile is a valid Tile instance and within range
		if tile != self and tile.position.distance_to(self.position) < 30:
			if tile is Tile:  # Check if it's a Tile instance
				type = 5
				tile.take_damage(self)  # Pass the bomb as the attacker
	
	queue_free()  # Remove the bomb after it explodes
