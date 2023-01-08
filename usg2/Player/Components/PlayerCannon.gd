extends Node2D

var bullet = preload("res://Items/PlayerBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	var parent = get_parent()
	var player = parent._player
	var bullet_instance = bullet.instance()
	bullet_instance.damage = player.bullet_damage
	bullet_instance.position = $BulletPoint.get_global_position()
	# bullet_instance.rotation_degrees = player.rotation_degrees
	var angle = bullet_instance.position - player.get_global_position()
	angle = angle.angle()
	bullet_instance.apply_impulse(Vector2(), Vector2(player.bullet_speed, 0).rotated(angle))
	get_tree().get_root().add_child(bullet_instance)
	$FireSound.play()

