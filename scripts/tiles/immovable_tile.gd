extends Tile
var explosion_particles = preload("res://effects/explosion_block.tscn")
var sprite_2d : Sprite2D

func _ready():
	hp = 3 #10
	type = 4
	is_movable = false
	show_damage = false
	sprite_2d = $Sprite2D

func play_damage_effect():
	super()
	if hp > 0:
		sprite_2d.frame = 3 - hp
	
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true
