extends KinematicBody2D


export var speed = 75
var _player

# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_node("/root/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
