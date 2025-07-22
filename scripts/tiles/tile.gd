extends Control

class_name Tile

var MAX_HEALTH = 5
@export var hp: int = 3
@export var damage: int = 1
@export var type: int = 0  # 1 = Player, 2 = Enemy, 3 = Item
@export var is_movable: bool = true  # Tracks if the tile can be moved
@export var show_damage: bool = true

func fade_in():
	modulate.a = 0                    # Start fully transparent
	scale = Vector2(0.3, 0.3)         # Start very small for a strong pop effect

	var tween = create_tween()
	# Fade-in effect (smooth fade)
	tween.tween_property(self, "modulate:a", 1, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Scale-up with bounce effect for extra pop
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)\
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	# Slight shrink back for the final bounce effect
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func take_damage(attacker):
	if attacker.type == self.type or (attacker.type in [3, 4]):  # Items cannot be damaged
		return  

	hp -= attacker.damage
	
	match attacker.type:
		1:
			match type:
				2:
					ScoreManager.Instance.add_score(3)
					ScoreManager.Instance.add_damage(attacker.damage)
				3:
					ScoreManager.Instance.add_score(5)
					ScoreManager.Instance.add_item()
				4:
					ScoreManager.Instance.add_score(1)
		5:
			match type:
				2:
					ScoreManager.Instance.bomb_damage()
	
	#if show_damage:
		#show_floating_damage(attacker.damage)
	play_damage_effect()
	
	# Check if the tile is destroyed
	if hp <= 0:
		if type in [1, 2]:
			Global.play_sound("Sound", preload("res://assets/sounds/die.wav"))
		var tween = create_tween()
		tween.tween_interval(0.1)  # Small delay to allow animations
		tween.finished.connect(die.bind(attacker))
	
	if type == 1:
		Global.play_sound("Sound", preload("res://assets/sounds/hurt.wav"))
	
	if attacker.type == 1:
		if type == 2:
			Global.play_sound("Sound", preload("res://assets/sounds/hit.wav"))
		if type == 4:
			if is_movable:
				Global.play_sound("Sound", preload("res://assets/sounds/light_hit.wav"))
			else:
				Global.play_sound("Sound", preload("res://assets/sounds/medium_hit.wav"))
	
	check_limits()

func die(_attacker):
	queue_free()

func show_floating_damage(amount):
	var floating_text = preload("res://scenes/floating_text.tscn").instantiate()
	
	floating_text.position = position
	get_parent().add_child(floating_text)
	floating_text.set_text(str(amount), Color(1, 0, 0))  # Red for damage

func play_damage_effect():
	var tween = create_tween()
	var sprite = $"."

	# Flash red
	tween.tween_property(sprite, "modulate", Color(1, 0.3, 0.3), 0.1)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.1)

func check_limits():
	if type in [1, 2]:
		if (hp > MAX_HEALTH):
			hp = MAX_HEALTH
		#if (damage > hp):
			#damage = hp
