extends Node2D

var velocity;
var parent;


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	velocity = Vector2(parent.speed, 0)

func _physics_process(delta):
	var player = parent._player
	if !is_instance_valid(player):
		return
		
	var direction = Vector2()
	direction = player.get_global_position() - parent.get_global_position()
	direction = direction.normalized()
	parent.move_and_collide(direction*parent.speed*delta)
	
