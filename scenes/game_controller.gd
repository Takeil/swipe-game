extends Node2D

var length = 50
var startPos : Vector2
var currPos : Vector2
var swiping = false

var threshold = 10

func _process(delta: float):
	if Input.is_action_just_pressed("press"):
		if !swiping: 
			swiping = true
			startPos = get_global_mouse_position()
			print("Start Position ", startPos)
	if Input.is_action_pressed("press"):
		if swiping:
			currPos = get_global_mouse_position()
			if startPos.distance_to(currPos) >= length:
				if (abs(startPos.y - currPos.y) <= threshold):
					if startPos.x > currPos.x:
						print('Left')
					else:
						print('Right')
					swiping = false
				if (abs(startPos.x - currPos.x) <= threshold):
					if startPos.y > currPos.y:
						print('Up')
					else:
						print('Down')
					swiping = false
	else:
		swiping = false
