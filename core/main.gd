extends Node2D

var player_interest_value:= 5
var player_interest_timer: Timer = Timer.new()

func _ready() -> void:
	player_interest_timer.wait_time = 3 / 7.0
	player_interest_timer.one_shot = false
	add_child(player_interest_timer)
	player_interest_timer.autostart = true
	player_interest_timer.start()
	player_interest_timer.timeout.connect(player_interest)

func _process(_delta: float) -> void:
	pass
	
func player_interest():
	Global.player_money += player_interest_value
