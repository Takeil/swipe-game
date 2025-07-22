extends Control

class_name Volume

@export var image_container : Container
@export var audio_bus : String
var image_array : Array
var visible_count = 9

func _ready():
	for child in image_container.get_children():
		image_array.append(child)
	set_volume(Global.get_setting_data(audio_bus))

func _on_minus_button_pressed():
	Global.play_sound("Sound", preload("res://assets/sounds/minus.wav"))
	if visible_count > 0:
		for i in range(image_array.size()):
			if image_array[i].visible:
				image_array[i].hide()
				visible_count -= 1
				break 
	update_volume()

func _on_plus_button_pressed():
	Global.play_sound("Sound", preload("res://assets/sounds/plus.wav"))
	if visible_count < image_array.size():
		for i in range(image_array.size()):
			if !image_array[i].visible:
				image_array[i].show()
				visible_count += 1
				break
	update_volume()

func update_volume():
	var max_volume = 1.0
	var volume = (visible_count / float(image_array.size())) * max_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), linear_to_db(volume))
	Global.set_setting_data(audio_bus, volume)

func set_volume(new_volume):
	var count = round(new_volume * image_array.size())
	visible_count = count
	for i in range(image_array.size()):
		image_array[i].visible = i < count
	update_volume()
