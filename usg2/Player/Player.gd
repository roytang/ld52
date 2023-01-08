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
var energycurrent = 100
export var mineralsmax = 100
var mineralscurrent = 0

var explosion = preload("res://Items/Explosion.tscn")

var bullet = preload("res://Items/PlayerBullet.tscn")
var bullet_speed = 800
var bullet_damage = 20
var fire_rate = 0.3
var can_fire = true
var _player = self
var level = 1
var can_be_hit = true
var hit_recovery = 0.2

export var bomb_cost = 100
export var bomb_damage = 30
export var armor = 0
export var regen = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var cannon = $PlayerCannon
	connect("fire_cannons", cannon, "fire")

func _process(delta):
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("fire") and can_fire:
		emit_signal("fire_cannons")
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		
	if Input.is_action_pressed("fire2"):
		if energycurrent >= bomb_cost:
			$AnimationPlayer.play("bombex")
			$BombSound.play()
			get_tree().call_group("enemy", "emit_signal", "hit", bomb_damage)
			get_tree().call_group("enemy_bullet", "queue_free")
			energycurrent = energycurrent - bomb_cost
			emit_signal("stats_changed", self)
		else:
			$FailSound.play()
		
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
	if can_be_hit:
		can_be_hit = false
		$Sprite.material.set_shader_param("flash_modifier", 1.0)
		$FlashTimer.start()
		$HitSound.play()
		damage = damage - armor
		if damage < 1:
			damage = 1
		hpcurrent = hpcurrent - damage
		emit_signal("stats_changed", self)
		if hpcurrent <= 0:
			die()
		yield(get_tree().create_timer(hit_recovery), "timeout")
		can_be_hit = true



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
			mineralsmax = mineralsmax + 30
	emit_signal("stats_changed", self)
		


func die():
	var explosion_instance = explosion.instance()
	explosion_instance.position = get_global_position()
	get_tree().get_root().add_child(explosion_instance)
	emit_signal("died")



func _on_FlashTimer_timeout():
	$Sprite.material.set_shader_param("flash_modifier", 0.0)

func _on_RegenTimer_timeout():
	if regen > 0 and hpcurrent < hpmax:
		hpcurrent = hpcurrent + regen
		if hpcurrent > hpmax:
			hpcurrent = hpmax
		emit_signal("stats_changed")
