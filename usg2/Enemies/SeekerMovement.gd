extends Node2D

var velocity;
var parent;


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	velocity = Vector2(parent.speed, 0)

func _physics_process(delta):
	velocity.x = parent.speed

	var player = parent._player
	if !is_instance_valid(player):
		return
		
	var angle = parent.position.direction_to(player.position).angle()
		
	parent.rotation = lerp_angle(parent.rotation, angle, 0.5 * delta)	
		
	var motion = (velocity*delta)
	motion = motion.rotated(parent.rotation)
	
	parent.move_and_collide(motion)
	
