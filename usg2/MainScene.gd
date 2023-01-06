extends Node2D

var player_scene = preload("res://Player.tscn")
var asteroid_scene = preload("res://Asteroid.tscn")
var _player

export var timer_base_time = 1.5

var spawn_points = [
	Vector2(0, -100),
	Vector2(256, -100),
	Vector2(512, -100),
	Vector2(768, -100),
	Vector2(1024, -100),
	Vector2(0-100, 300),
	Vector2(1024+100, 300),
	Vector2(0, 700),
	Vector2(256, 700),
	Vector2(512, 700),
	Vector2(768, 700),
	Vector2(1024, 700),
]

var inner_points = [
	Vector2(256, 200),
	Vector2(256, 400),
	Vector2(512, 200),
	Vector2(512, 400),
]

func _ready():
	randomize()
	call_deferred("start_game")

func start_game():
	_player = player_scene.instance()
	get_tree().get_root().add_child(_player)
	_player.position.x = 200
	_player.position.y = 200
	
	$AsteroidSpawner.wait_time = timer_base_time + randf() * timer_base_time
	$AsteroidSpawner.start()
	


func _on_AsteroidSpawner_timeout():
	var asteroid = asteroid_scene.instance()
	get_tree().get_root().add_child(asteroid)
	var count_opts = spawn_points.size()
	# asteroid.position = spawn_points[randi() % count_opts] + _player.position
	
	var rand_direction = Vector2(randf()*2-1, randf()*2-1)
	var rand_x = rand_range(-768, 768)
	var rand_y = rand_range(-450, 450)
	var offset = Vector2(rand_x, rand_y) * rand_direction
	asteroid.position = _player.get_global_position() + offset
	
	var target_opts = inner_points.size()
	var target_pos = inner_points[randi() % target_opts]
	var direction = target_pos - asteroid.position
	var size_factor = rand_range(0.75, 1.25)
	asteroid.scale.x = size_factor
	asteroid.scale.y = size_factor
	asteroid.rotation_degrees = randi() % 360
	asteroid.direction = direction.normalized()
	asteroid.size_factor = size_factor
