extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum PICKUP_TYPE {HEALTH, ENERGY, MINERALS}
export(PICKUP_TYPE) var pickuptype = PICKUP_TYPE.HEALTH

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HealthPickup_body_entered(body):
	if body.is_in_group("player"):
		body.emit_signal("pickup", pickuptype)
		queue_free()
