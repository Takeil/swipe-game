extends Tile

class_name PlayerTile

var explosion_particles = preload("res://effects/explosion_player.tscn")
var sprite_2d : Sprite2D

signal on_change_hp

static var Instance : PlayerTile

func _ready():
	Instance = self
	MAX_HEALTH = 3
	hp = 3
	damage = 1
	type = 1
	is_movable = true
	sprite_2d = $Sprite2D

func play_damage_effect():
	super()
	if hp > 0:
		sprite_2d.frame = MAX_HEALTH - hp
	
	on_change_hp.emit()
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true

func check_limits():
	super()
	if (hp > 0):
		sprite_2d.frame = 3 - hp
