extends RigidBody2D

signal hit
var friendly = true
var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Bullet_body_entered(body):
	if friendly:
		body.emit_signal("hit", damage)
		queue_free()
	else:
		if body.is_in_group("player"):
			body.emit_signal("hit", damage)
			queue_free()


func _on_Timer_timeout():
	queue_free()


func _on_Bullet_hit():
	print("BULLET HIT!")
	queue_free()
