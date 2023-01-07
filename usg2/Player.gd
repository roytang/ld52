extends KinematicBody2D

signal hit
signal stats_changed
export var speed = 250
export var hpmax = 100
var hpcurrent = hpmax

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	look_at(get_global_mouse_position())

func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		direction += Vector2(1, 0)
		
	move_and_slide(direction * speed)
		


func _on_Player_hit(damage):
	print("PLAYER HIT")
	hpcurrent = hpcurrent - damage
	emit_signal("stats_changed", self)