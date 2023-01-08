extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply_upgrade(player):
	player.energycurrent = player.energycurrent + 50
	if player.energycurrent > player.energymax:
		player.energycurrent = player.energymax
	player.emit_signal("stats_changed")
