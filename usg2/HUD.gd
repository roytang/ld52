extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_player_stats_changed(_player):
	$ColorRect/HPOuter/HPInner.rect_size.x = 100 * _player.hpcurrent / _player.hpmax
