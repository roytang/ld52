extends Node2D


var time

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0

func _process(delta):
	time += delta

func get_time_str():
	var seconds = fmod(time,60)
	var minutes = fmod(time, 3600) / 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	return str_elapsed
	
