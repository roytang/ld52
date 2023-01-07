extends RigidBody2D

signal hit
var friendly = true
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Bullet_body_entered(body):
	print(body, friendly)
	if friendly:
		body.emit_signal("hit", damage)
		queue_free()
	else:
		if body.is_in_group("player"):
			print("HIT HIT!")
			body.emit_signal("hit", damage)
			queue_free()


func _on_Timer_timeout():
	queue_free()


func _on_Bullet_hit():
	queue_free()
