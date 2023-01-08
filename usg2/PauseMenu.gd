extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var can_pause = true
var pause_cooldown = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("pause") and can_pause:
		can_pause = false
		if get_tree().paused:
			get_tree().paused = false
			visible = false
		else:
			get_tree().paused = true
			visible = true
		yield(get_tree().create_timer(pause_cooldown), "timeout")
		can_pause = true
