extends Node2D

signal restart
signal menu

var player_scene = preload("res://Player/Player.tscn")
var asteroid_scene = preload("res://Asteroid.tscn")
var _player

export var timer_base_time = 1.0
export var mid_timer_mult = 15.0
export var heavy_timer_mult = 45.0
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

var Dreadnought = {
			"name": "Dreadnought",
			"scene": "res://Enemies/Dreadnought.tscn",
			"id": 7
		}

var DeathWheel = {
			"name": "DeathWheel",
			"scene": "res://Enemies/DeathWheel.tscn",
			"id": 8
		}

var _spawn_list = [Seeker, Seeker, Seeker, Spreader, Hunter]
var _mid_spawn_list = [Corvette, Corvette, Cruiser, DreadWing]
var _heavy_spawn_list = [Dreadnought, Dreadnought, DeathWheel]

### Upgrades

var SpeedUpgrade3 = {
	"title": "Engine Upgrade III",
	"text": "Further Increase your ship's movement speed.",
	"icon": "res://assets/speedup.png",
	"executor": "res://Player/Upgrades/SpeedUp1.tscn",
	"remove": true,
	"next": []
}
var SpeedUpgrade2 = {
	"title": "Engine Upgrade II",
	"text": "Further Increase your ship's movement speed.",
	"icon": "res://assets/speedup.png",
	"executor": "res://Player/Upgrades/SpeedUp1.tscn",
	"remove": true,
	"next": [SpeedUpgrade3]
}
var SpeedUpgrade1 = {
	"title": "Engine Upgrade I",
	"text": "Increase your ship's movement speed.",
	"icon": "res://assets/speedup.png",
	"executor": "res://Player/Upgrades/SpeedUp1.tscn",
	"remove": true,
	"next": [SpeedUpgrade2]
}
var HPUpgrade3 = {
	"title": "Hull Upgrade III",
	"text": "Further increases your ship's HP. Also fully heals your HP.",
	"icon": "res://assets/hpup.png",
	"executor": "res://Player/Upgrades/HPUp1.tscn",
	"remove": true,
	"next": []
}
var HPUpgrade2 = {
	"title": "Hull Upgrade II",
	"text": "Further increases your ship's HP. Also fully heals your HP.",
	"icon": "res://assets/hpup.png",
	"executor": "res://Player/Upgrades/HPUp1.tscn",
	"remove": true,
	"next": [HPUpgrade3]
}
var HPUpgrade1 = {
	"title": "Hull Upgrade I",
	"text": "Increases your ship's HP. Also fully heals your HP.",
	"icon": "res://assets/hpup.png",
	"executor": "res://Player/Upgrades/HPUp1.tscn",
	"remove": true,
	"next": [HPUpgrade2]
}

var DmgUp3 = {
	"title": "Heavy Ammunition III",
	"text": "Further increases the damage dealt by your cannon bullets.",
	"icon": "res://assets/dmgup.png",
	"executor": "res://Player/Upgrades/DMGUp.tscn",
	"remove": true,
	"next": []
}
var DmgUp2 = {
	"title": "Heavy Ammunition II",
	"text": "Further increases the damage dealt by your cannon bullets.",
	"icon": "res://assets/dmgup.png",
	"executor": "res://Player/Upgrades/DMGUp.tscn",
	"remove": true,
	"next": [DmgUp3]
}
var DmgUp1 = {
	"title": "Heavy Ammunition I",
	"text": "Increases the damage dealt by your cannon bullets.",
	"icon": "res://assets/dmgup.png",
	"executor": "res://Player/Upgrades/DMGUp.tscn",
	"remove": true,
	"next": [DmgUp2]
}

var FireRateUp3 = {
	"title": "Accelerated Reload III",
	"text": "Further increases the fire rate of your cannon.",
	"icon": "res://assets/firerateup.png",
	"executor": "res://Player/Upgrades/FireRateUp.tscn",
	"remove": true,
	"next": []
}
var FireRateUp2 = {
	"title": "Accelerated Reload II",
	"text": "Further increases the fire rate of your cannon.",
	"icon": "res://assets/firerateup.png",
	"executor": "res://Player/Upgrades/FireRateUp.tscn",
	"remove": true,
	"next": [FireRateUp3]
}
var FireRateUp1 = {
	"title": "Accelerated Reload",
	"text": "Increases the fire rate of your cannon.",
	"icon": "res://assets/firerateup.png",
	"executor": "res://Player/Upgrades/FireRateUp.tscn",
	"remove": true,
	"next": [FireRateUp2]
}

var EvenMoreCannons = {
	"title": "Even More Cannons",
	"text": "Even more cannons!",
	"icon": "res://assets/evenmorecannons.png",
	"executor": "res://Player/Upgrades/EvenMoreCannonsUpgrade.tscn",
	"remove": true,
	"next": []
}

var MoreCannons = {
	"title": "More Cannons",
	"text": "More cannons!",
	"icon": "res://assets/morecannons.png",
	"executor": "res://Player/Upgrades/MoreCannonsUpgrade.tscn",
	"remove": true,
	"next": [EvenMoreCannons]
}

var Harvester = {
	"title": "Harvester",
	"text": "Automatically pull pickups towards you for easy harvesting.",
	"icon": "res://assets/morecannons.png",
	"executor": "res://Player/Upgrades/HarvesterUpgrade.tscn",
	"remove": true,
	"next": []
}

var ArmorUp2 = {
	"title": "Hull Plating II",
	"text": "Further reduces incoming damage",
	"icon": "res://assets/shieldup.png",
	"executor": "res://Player/Upgrades/ArmorUp.tscn",
	"remove": true,
	"next": []
}

var ArmorUp1 = {
	"title": "Hull Plating I",
	"text": "Reduces incoming damage",
	"icon": "res://assets/shieldup.png",
	"executor": "res://Player/Upgrades/ArmorUp.tscn",
	"remove": true,
	"next": [ArmorUp2]
}

var RegenUp2 = {
	"title": "Automatic Repair II",
	"text": "Further recovers lost HP over time",
	"icon": "res://assets/regenup.png",
	"executor": "res://Player/Upgrades/RegenUp.tscn",
	"remove": true,
	"next": []
}
var RegenUp1 = {
	"title": "Automatic Repair I",
	"text": "Recovers lost HP over time",
	"icon": "res://assets/regenup.png",
	"executor": "res://Player/Upgrades/RegenUp.tscn",
	"remove": true,
	"next": [RegenUp2]
}
var HPRecovery = {
	"title": "Emergency Repair",
	"text": "Immediately recovers some lost HP",
	"icon": "res://assets/health.png",
	"executor": "res://Player/Upgrades/HPRecovery.tscn",
	"remove": false,
	"next": []
}
var EnergyRecovery = {
	"title": "Emergency Charge",
	"text": "Immediately recovers some energy",
	"icon": "res://assets/energy.png",
	"executor": "res://Player/Upgrades/EnergyRecovery.tscn",
	"remove": false,
	"next": []
}

var available_upgrades = [
	RegenUp1, 
	ArmorUp1, 
	Harvester, 
	MoreCannons, 
	HPUpgrade1, 
	SpeedUpgrade1, 
	FireRateUp1, 
	DmgUp1
	]
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
	add_child(_player)
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
	$MidSpawnTimer.start()
	$HeavySpawnTimer.wait_time = (heavy_timer_mult * timer_base_time) + randf() * timer_base_time
	$HeavySpawnTimer.start()
	


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
	# print(assigned_upgrades)

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
	_player.level = _player.level + 1
	
	if upgrade_deets["remove"]:
		available_upgrades.erase(upgrade_deets)
		
	for next_upgrade in upgrade_deets["next"]:
		available_upgrades.append(next_upgrade)
	if available_upgrades.size() <= 1:
		available_upgrades.append(HPRecovery)
		available_upgrades.append(EnergyRecovery)
	
	$HUD/UpgradeMenu.visible = false
	get_tree().paused = false

func _on_player_died():
	$HUD/MessageBox/TimeSurvived.text = "You survived for " + $TimeCounter.get_time_str() + " !"
	$HUD/MessageBox/ShipsSurvived.text = "You encountered " + str(spawn_count) + " enemy ship(s)."	
	get_tree().paused = true
	$HUD/MessageBox.visible = true
	

func spawn(spawn_list, timer, multiplier):
	var mult = multiplier
	if is_instance_valid(_player):
		# reduce spawn timers for higher level players
		var level = _player.level*2 + 1
		if level >= 50:
			level = 50
		mult = (100-level) * mult / 100
		
		var count_opts = spawn_list.size()
		if count_opts == 0:
			return
		var new_spawn_data = spawn_list[randi() % count_opts]
		var spawn_scene = load(new_spawn_data["scene"])
		var spawn_instance = spawn_scene.instance()
		count_opts = spawn_points.size()
		print("SPAWN PLAYER ", _player)
		spawn_instance._player = _player
		spawn_instance.position = spawn_points[randi() % count_opts]
		spawn_instance.add_to_group("enemy")
		get_tree().get_root().call_deferred("add_child", spawn_instance)
		spawn_count = spawn_count + 1

	# random wait until next drop
	print("mult=", mult)
	timer.wait_time = (mult * timer_base_time) + randf() * timer_base_time

func _on_MidSpawnTimer_timeout():
	spawn(_mid_spawn_list, $MidSpawnTimer, mid_timer_mult)


func _on_HeavySpawnTimer_timeout():
	spawn(_heavy_spawn_list, $HeavySpawnTimer, heavy_timer_mult)


func _on_Button_pressed():
	get_tree().paused = false
	_player.queue_free()
	var root = get_tree().root
	for N in root.get_children():
		N.queue_free()
	get_tree().change_scene("res://MainScene.tscn")

func _on_Button2_pressed():
	get_tree().paused = false
	_player.queue_free()
	var root = get_tree().root
	for N in root.get_children():
		N.queue_free()
	get_tree().change_scene("res://Launcher.tscn")
