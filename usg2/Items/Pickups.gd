extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum PICKUP_TYPE {HEALTH, ENERGY, MINERALS}
export(PICKUP_TYPE) var pickuptype = PICKUP_TYPE.HEALTH

export var amount = 10
var pickup_sound
var pickedup = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pickup_sound = AudioStreamPlayer.new()
	pickup_sound.stream = load("res://sounds/pickupCoin.wav")
	pickup_sound.connect("finished", self, "_on_sound_finished")
	add_child(pickup_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HealthPickup_body_entered(body):
	if pickedup:
		return
	if body.is_in_group("player"):
		pickedup = true
		visible = false
		body.emit_signal("pickup", pickuptype, amount)
		pickup_sound.play()
		
func _on_sound_finished():
	queue_free()
