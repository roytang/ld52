extends KinematicBody2D

signal hit
signal stats_changed
signal pickup
signal select_upgrade
signal died
signal fire_cannons

enum PICKUP_TYPE {HEALTH, ENERGY, MINERALS}

export var speed = 250
export var hpmax = 100
var hpcurrent = hpmax
export var energymax = 100
var energycurrent = energymax
export var mineralsmax = 100
var mineralscurrent = 0

var bullet = preload("res://Items/PlayerBullet.tscn")
var bullet_speed = 800
var bullet_damage = 20
var fire_rate = 0.3
var can_fire = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("fire") and can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.damage = bullet_damage
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		emit_signal("fire_cannons")
		# $LaserSound.play()
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		
func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		direction += Vector2(1, 0)
		
	move_and_slide(direction * speed)
		


func _on_Player_hit(damage):
	$Sprite.material.set_shader_param("flash_modifier", 1.0)
	$FlashTimer.start()
	hpcurrent = hpcurrent - damage
	emit_signal("stats_changed", self)
	if hpcurrent < 0:
		die()


func _on_Player_pickup(pickup, amount):
	if pickup == PICKUP_TYPE.ENERGY:
		energycurrent = energycurrent + amount
		if energycurrent > energymax:
			energycurrent = energymax
	if pickup == PICKUP_TYPE.HEALTH:
		hpcurrent = hpcurrent + amount
		if hpcurrent > hpmax:
			hpcurrent = hpmax
	if pickup == PICKUP_TYPE.MINERALS:
		mineralscurrent = mineralscurrent + amount
		if mineralscurrent >= mineralsmax:
			mineralscurrent = 0
			emit_signal("select_upgrade")
			mineralsmax = mineralsmax + 20
	emit_signal("stats_changed", self)
		


func _on_EnergyDrainTimer_timeout():
	energycurrent = energycurrent - 1
	emit_signal("stats_changed", self)
	if energycurrent <= 0:
		die()
		
func die():
	print("YOU DIED!")
	emit_signal("died")



func _on_FlashTimer_timeout():
	$Sprite.material.set_shader_param("flash_modifier", 0.0)
