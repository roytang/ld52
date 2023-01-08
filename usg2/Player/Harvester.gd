extends Area2D

var harvest_speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent()
	var player_pos = player.get_global_position()
	for area in get_overlapping_areas():
		if area.is_in_group("pickups"):
			var direction = Vector2()
			direction = player_pos - area.get_global_position()
			direction = direction.normalized()
			area.position = area.position + direction*harvest_speed*delta
	
