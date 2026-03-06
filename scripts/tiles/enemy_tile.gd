extends Tile

enum ENEMY_TYPE {
	Easy,
	Medium,
	Hard
}

@export var enemy_type : ENEMY_TYPE
@export var explosion_particles = preload("res://effects/explosion_enemy.tscn")
var sprite_2d : Sprite2D

func _ready():
	type = 2
	is_movable = true
	sprite_2d = $Sprite2D
	
	if ENEMY_TYPE.Easy == enemy_type:
		MAX_HEALTH = 1
		hp = 1
		damage = 1
	elif ENEMY_TYPE.Medium == enemy_type:
		MAX_HEALTH = 2
		hp = 2
		damage = 1
	elif ENEMY_TYPE.Hard == enemy_type:
		MAX_HEALTH = 3
		hp = 3
		damage = 2

func play_damage_effect():
	super()
	if hp > 0:
		sprite_2d.frame = MAX_HEALTH - hp
	
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true

func die(_attacker):
	
	if ENEMY_TYPE.Easy == enemy_type:
		ScoreManager.Instance.add_score(5)
	elif ENEMY_TYPE.Medium == enemy_type:
		ScoreManager.Instance.add_score(10)
	elif ENEMY_TYPE.Hard == enemy_type:
		ScoreManager.Instance.add_score(20)
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true
	
	Board.Instance.on_tile_hit()
	
	super(_attacker)
