extends KinematicBody2D

signal hit

export var speed = 75
var _player

export var hpmax = 100
var hpcurrent = hpmax

export var can_be_hit = true
var hit_recovery_secs = 0.2 

var health_pickup = "res://Items/HealthPickup.tscn" 
var energy_pickup = "res://Items/EnergyPickup.tscn" 
var minerals_pickup = "res://Items/MineralsPickup.tscn" 

var drop_list = [minerals_pickup, minerals_pickup, minerals_pickup, energy_pickup, health_pickup]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_player = get_node("/root/Player")
	hpcurrent = hpmax
	connect("hit", self, "_on_Enemy_hit")

func _on_Enemy_hit(damage):
	print("Hit for damage ", damage)
	if can_be_hit:
		hpcurrent = hpcurrent - damage
		print("Remaining HP ", hpcurrent)
		can_be_hit = false
		if hpcurrent <= 0:
			die()
		else:
			var _anim = get_node("AnimationPlayer")
			if is_instance_valid(_anim):
				_anim.play("hit")
		yield(get_tree().create_timer(hit_recovery_secs), "timeout")
		can_be_hit = true

func die():
	# drop a random pickup
	var count_opts = drop_list.size()
	var new_scene = drop_list[randi() % count_opts]
	var pickup = load(new_scene).instance()
	pickup.position = get_global_position()
	get_tree().get_root().call_deferred("add_child", pickup)
	
	queue_free()
