extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func apply_upgrade(player):
	if player.bomb_cost > 50:
		player.bomb_cost = player.bomb_cost - 20
	else:
		player.bomb_cost = player.bomb_cost - 10
