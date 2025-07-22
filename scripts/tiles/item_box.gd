extends Tile
var explosion_particles = preload("res://effects/explosion_item.tscn")
var animation_player : AnimationPlayer
var damager : Tile

func _ready():
	hp = 1
	type = 3  # Item Type (Cannot deal damage)
	is_movable = false  # Items are not movable
	show_damage = false
	animation_player = $Sprite2D/AnimationPlayer

func apply_effect(target):
	if target.type == 1: #or target.type == 2:  # Only apply effect to Player or Enemy
		#var effect = randi_range(0, 2)
		#if target.type == 1:
		Global.play_sound("Sound", preload("res://assets/sounds/item.wav"))
		#match effect:
			#0:
		target.hp += 1  # Heal
			#1:
				#target.damage += 1  # Damage boost
		target.check_limits()

func die(attacker):
	var particles = explosion_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position + Vector2(8, 8)
	particles.emitting = true
	
	if is_instance_valid(attacker):
		if (attacker.type == 1 or attacker.type == 2):
			apply_effect(attacker)  # Apply effect to the correct attacker
	queue_free()

func take_damage(attacker):
	damager = attacker
	super(attacker)
	print(attacker.name)

func play_damage_effect():
	if (damager.type == 1):
		animation_player.play("player_get")
	else:
		animation_player.play("destroyed")
	pass
