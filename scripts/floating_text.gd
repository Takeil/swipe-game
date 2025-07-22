extends Control

@export var float_speed: float = 50.0
@export var duration: float = 0.8

func _ready():
	var tween = create_tween()
	
	# Move up and fade out
	tween.tween_property(self, "position", position + Vector2(0, -30), duration)
	tween.parallel().tween_property(self, "modulate", Color(1, 1, 1, 0), duration)
	
	tween.finished.connect(queue_free)  # Remove after animation

func set_text(value: String, color: Color):
	$Label.text = value
	$Label.modulate = color
