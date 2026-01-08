extends TextureButton

@onready var progress: ProgressBar = $ProgressBar
@onready var cooldown_timer: Timer = $Timer

var unit : String
var price : int
var cooldown : float
var icon : String

func _process(_delta: float) -> void:
	progress.value = cooldown_timer.time_left / cooldown_timer.wait_time


func _on_pressed() -> void:
	if cooldown_timer.is_stopped():
		
		cooldown_timer.start()
	
