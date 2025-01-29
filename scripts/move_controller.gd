extends Node2D

var length = 10
var startPos : Vector2
var currPos : Vector2
var swiping = false

var threshold = 10

func _process(delta: float):
	control()

func control() -> String:
	var output = ''
	
	if Input.is_action_just_pressed('right'):
		output = 'R'
	if Input.is_action_just_pressed('left'):
		output = 'L'
	if Input.is_action_just_pressed('up'):
		output = 'U'
	if Input.is_action_just_pressed('down'):
		output = 'D'
	
	if Input.is_action_just_pressed("press"):
		if !swiping: 
			swiping = true
			startPos = get_global_mouse_position()
	if Input.is_action_pressed("press"):
		if swiping:
			currPos = get_global_mouse_position()
			if startPos.distance_to(currPos) >= length:
				if (abs(startPos.y - currPos.y) <= threshold):
					if startPos.x > currPos.x:
						output = 'L'
					else:
						output = 'R'
					swiping = false
				if (abs(startPos.x - currPos.x) <= threshold):
					if startPos.y > currPos.y:
						output = 'U'
					else:
						output = 'D'
					swiping = false
	else:
		swiping = false
	
	if output != '' : print(output)
	return output
