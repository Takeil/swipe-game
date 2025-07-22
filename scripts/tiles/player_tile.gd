extends Tile
var explosion_particles = preload("res://effects/explosion_player.tscn")
var sprite_2d : Sprite2D

func _ready():
	MAX_HEALTH = 3
	hp = 3
	damage = 1
	type = 1
	is_movable = true
	sprite_2d = $Sprite2D

func play_damage_effect():
	super()
	if hp > 0:
		sprite_2d.frame = 3 - hp
	
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true

func check_limits():
	super()
	if (hp > 0):
		sprite_2d.frame = 3 - hp
