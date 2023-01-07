extends Node2D

var player_scene = preload("res://Player.tscn")
var asteroid_scene = preload("res://Asteroid.tscn")
var _player

export var timer_base_time = 1.0
var spawn_count = 0

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

var Spreader = {
			"name": "Spreader",
			"scene": "res://Enemies/Spreader.tscn",
			"id": 1
		}
var Seeker = {
			"name": "Seeker",
			"scene": "res://Enemies/Seeker.tscn",
			"id": 2
		}
var Hunter = {
			"name": "Hunter",
			"scene": "res://Enemies/Hunter.tscn",
			"id": 3
		}

var spawn_list = [Seeker, Seeker, Seeker, Spreader, Hunter]

### Upgrades

var SpeedUpgrade1 = {
	"title": "Engine Upgrade 1",
	"text": "Increase your ship's movement speed.",
	"icon": "res://assets/speedup.png"
}
var HPUpgrade1 = {
	"title": "Hull Upgrade 1",
	"text": "Increase your ship's HP. Also fully heals your HP.",
	"icon": "res://assets/hpup.png"
}

var available_upgrades = [HPUpgrade1, SpeedUpgrade1]
var upgrade_buttons = [
	"HUD/UpgradeMenu/Inner/UpgradeButton1", 
	"HUD/UpgradeMenu/Inner/UpgradeButton2", 
	"HUD/UpgradeMenu/Inner/UpgradeButton3", 
	"HUD/UpgradeMenu/Inner/UpgradeButton4", 
	]

func _ready():
	randomize()
	call_deferred("start_game")

func start_game():
	_player = player_scene.instance()
	get_tree().get_root().add_child(_player)
	_player.position.x = 200
	_player.position.y = 200
	_player.connect("stats_changed", $HUD, "_on_player_stats_changed")
	_player.emit_signal("stats_changed", _player)
	_player.connect("select_upgrade", self, "start_upgrade")
	start_upgrade()
	
	$SpawnTimer.wait_time = timer_base_time + randf() * timer_base_time
	$SpawnTimer.start()
	


func _on_AsteroidSpawner_timeout():
	return
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


func _on_SpawnTimer_timeout():
	if is_instance_valid(_player):
		var count_opts = spawn_list.size()
		var new_spawn_data = spawn_list[randi() % count_opts]
		var spawn_scene = load(new_spawn_data["scene"])
		var spawn_instance = spawn_scene.instance()
		count_opts = spawn_points.size()
		spawn_instance.position = spawn_points[randi() % count_opts]
		get_tree().get_root().call_deferred("add_child", spawn_instance)
		spawn_count = spawn_count + 1

	# random wait until next drop
	$SpawnTimer.wait_time = timer_base_time + randf() * timer_base_time

func start_upgrade():
	get_tree().paused = true
	$HUD/UpgradeMenu.visible = true
	var index = 0
	var this_upgrade_set = available_upgrades.duplicate()
	this_upgrade_set.shuffle()
	for upgrade in this_upgrade_set:
		var button = get_node(upgrade_buttons[index])
		button.visible = true
		button.icon = load(upgrade["icon"])
		button.get_node("Title").text = upgrade["title"]
		button.get_node("Description").text = upgrade["text"]
		index = index + 1
	if index < 4:
		$HUD/UpgradeMenu/Inner/UpgradeButton4.visible = false
	if index < 3:
		$HUD/UpgradeMenu/Inner/UpgradeButton3.visible = false
	if index < 2:
		$HUD/UpgradeMenu/Inner/UpgradeButton2.visible = false

func _on_UpgradeButton1_pressed():
	print("Upgrade 1 selected!")
	$HUD/UpgradeMenu.visible = false
	get_tree().paused = false

func _on_UpgradeButton2_pressed():
	print("Upgrade 2 selected!")
	$HUD/UpgradeMenu.visible = false
	get_tree().paused = false

func _on_UpgradeButton3_pressed():
	print("Upgrade 3 selected!")
	$HUD/UpgradeMenu.visible = false
	get_tree().paused = false

func _on_UpgradeButton4_pressed():
	print("Upgrade 4 selected!")
	$HUD/UpgradeMenu.visible = false
	get_tree().paused = false
