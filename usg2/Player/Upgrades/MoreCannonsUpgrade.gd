extends Node2D

export(Resource) var resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func apply_upgrade(player):
	var scene = resource
	var upgrade = scene.instance()
	player.add_child(upgrade)
	player.connect("fire_cannons", upgrade, "fire")
