extends TextureButton

@onready var progress: ProgressBar = $ProgressBar
@onready var cooldown_timer: Timer = $Timer
@onready var cost_label: Label = $Label

var unit : String
var price : int
var cooldown : float
var icon : String

func _process(_delta: float) -> void:
	progress.value = cooldown_timer.time_left / cooldown_timer.wait_time


func _on_pressed() -> void:
	if cooldown_timer.is_stopped() and price <= Global.money:
		Global.summon(unit, Global.TEAM.ALLY)
		Global.money -= price
		cooldown_timer.start()
	
func set_stats(stats: Array):
	unit = stats[0]
	price = stats[1]
	cooldown = stats[2]
	icon = stats[3]
	
	texture_normal = load(icon)
	cost_label.text = "$" + str(price)
	if unit == "empty":
		cost_label.text = ""
	
func update_stats(stats: Array):
	price = stats[1]
	cooldown = stats[2]

	cost_label.text = "$" + str(price)
