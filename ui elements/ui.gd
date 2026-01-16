extends Control

@onready var player_money: Label = $player_money
@onready var dir_money: Label = $dir_money

func _process(_delta: float) -> void:
	player_money.text = "$" + str(Global.player_money)
	dir_money.text = "$" + str(Global.director_money)
