extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply_upgrade(player):
	player.hpmax = player.hpmax + 15
	player.hpcurrent = player.hpmax
	player.emit_signal("stats_changed")
