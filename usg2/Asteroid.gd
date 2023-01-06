extends KinematicBody2D


var max_speed = 500
var speed
var direction
var size_factor

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	speed = randi() % max_speed


func _physics_process(delta):
	move_and_slide(direction * speed)
