extends Node2D

var player_scene = preload("res://Player/Player.tscn")
var asteroid_scene = preload("res://Asteroid.tscn")
var _player

export var timer_base_time = 1.0
export var mid_timer_mult = 12.0
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

var Corvette = {
			"name": "Corvette",
			"scene": "res://Enemies/Corvette.tscn",
			"id": 4
		}

var Cruiser = {
			"name": "Cruiser",
			"scene": "res://Enemies/Cruiser.tscn",
			"id": 5
		}

var DreadWing = {
			"name": "DreadWing",
			"scene": "res://Enemies/DreadWing.tscn",
			"id": 6
		}

var _spawn_list = [Seeker, Seeker, Seeker, Spreader, Hunter]
var _mid_spawn_list = [Corvette, Corvette, Cruiser, DreadWing]

### Upgrades

var SpeedUpgrade1 = {
	"title": "Engine Upgrade",
	"text": "Increase your ship's movement speed.",
	"icon": "res://assets/speedup.png",
	"executor": "res://Player/SpeedUp1.tscn",
	"remove": false,
	"next": []
}
var HPUpgrade1 = {
	"title": "Hull Upgrade",
	"text": "Increase your ship's HP. Also fully heals your HP.",
	"icon": "res://assets/hpup.png",
	"executor": "res://Player/HPUp1.tscn",
	"remove": false,
	"next": []
}

var DmgUp1 = {
	"title": "Heavy Ammunition",
	"text": "Increase the damage dealt by your cannon bullets.",
	"icon": "res://assets/dmgup.png",
	"executor": "res://Player/DMGUp.tscn",
	"remove": false,
	"next": []
}

var FireRateUp1 = {
	"title": "Accelerated Reload",
	"text": "Increases the fire rate of your cannon.",
	"icon": "res://assets/firerateup.png",
	"executor": "res://Player/FireRateUp.tscn",
	"remove": false,
	"next": []
}

var EvenMoreCannons = {
	"title": "Even More Cannons",
	"text": "Even more cannons!",
	"icon": "res://assets/firerateup.png",
	"executor": "res://Player/EvenMoreCannonsUpgrade.tscn",
	"remove": true,
	"next": []
}

var MoreCannons = {
	"title": "More Cannons",
	"text": "More cannons!",
	"icon": "res://assets/firerateup.png",
	"executor": "res://Player/MoreCannonsUpgrade.tscn",
	"remove": true,
	"next": [EvenMoreCannons]
}


var available_upgrades = [MoreCannons, HPUpgrade1, SpeedUpgrade1, FireRateUp1, DmgUp1]
var upgrade_buttons = [
	"HUD/UpgradeMenu/Inner/UpgradeButton1", 
	"HUD/UpgradeMenu/Inner/UpgradeButton2", 
	"HUD/UpgradeMenu/Inner/UpgradeButton3", 
	"HUD/UpgradeMenu/Inner/UpgradeButton4", 
	]
var assigned_upgrades = []

func _ready():
	randomize()
	call_deferred("start_game")

func start_game():
	_player = player_scene.instance()
	get_tree().get_root().add_child(_player)
	_player.position.x = 200
	_player.position.y = 200
	_player.connect("stats_changed", $HUD, "_on_player_stats_changed")
	_player.connect("died", self, "_on_player_died")
	_player.emit_signal("stats_changed", _player)
	_player.connect("select_upgrade", self, "start_upgrade")
	# start_upgrade()
	
	$SpawnTimer.wait_time = timer_base_time + randf() * timer_base_time
	$SpawnTimer.start()
	$MidSpawnTimer.wait_time = (mid_timer_mult * timer_base_time) + randf() * timer_base_time
	print($MidSpawnTimer.wait_time)
	$MidSpawnTimer.start()
	


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
	spawn(_spawn_list, $SpawnTimer, 1.0)

func start_upgrade():
	get_tree().paused = true
	for button in upgrade_buttons:
		var actual_button = get_node(button)
		actual_button.visible = false
	$HUD/UpgradeMenu.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	var index = 0
	var this_upgrade_set = available_upgrades.duplicate()
	this_upgrade_set.shuffle()
	assigned_upgrades = []
	for upgrade in this_upgrade_set:
		var button = get_node(upgrade_buttons[index])
		button.visible = true
		button.icon = load(upgrade["icon"])
		button.get_node("Title").text = upgrade["title"]
		button.get_node("Description").text = upgrade["text"]
		assigned_upgrades.append(upgrade)
		index = index + 1
		if index >= 4:
			break
	print(assigned_upgrades)

func _on_UpgradeButton1_pressed():
	exec_upgrade(0)

func _on_UpgradeButton2_pressed():
	exec_upgrade(1)

func _on_UpgradeButton3_pressed():
	exec_upgrade(2)

func _on_UpgradeButton4_pressed():
	exec_upgrade(3)

func exec_upgrade(index):
	var upgrade_deets = assigned_upgrades[index]
	var executor_scene = upgrade_deets["executor"]
	var executor_instance = load(executor_scene).instance()
	executor_instance.apply_upgrade(_player)
	
	if upgrade_deets["remove"]:
		available_upgrades.erase(upgrade_deets)
		
	for next_upgrade in upgrade_deets["next"]:
		available_upgrades.append(next_upgrade)
	
	$HUD/UpgradeMenu.visible = false
	get_tree().paused = false

func _on_player_died():
	get_tree().paused = true
	$HUD/MessageBox/Label.text = "\n\n\nYOU DIED!!!\n\n\n(There is no restart yet, so just reload or whatever.)"
	$HUD/MessageBox.visible = true
	

func spawn(spawn_list, timer, multiplier):
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
	timer.wait_time = (multiplier * timer_base_time) + randf() * timer_base_time

func _on_MidSpawnTimer_timeout():
	spawn(_mid_spawn_list, $MidSpawnTimer, mid_timer_mult)
