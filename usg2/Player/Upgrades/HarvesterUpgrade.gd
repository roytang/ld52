extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func apply_upgrade(player):
	var scene = load("res://Player/Components/Harvester.tscn")
	var upgrade = scene.instance()
	player.add_child(upgrade)
