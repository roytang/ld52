extends Node2D

var _player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func fire():
	_player = get_parent() 
	for child in get_children():
		child.fire()
	
