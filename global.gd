extends Node

var basic = preload("res://basic_unit.tscn")

# name : unit, cost, cooldown, icon, key
var stats = {
	"empty" : ["empty", 0, 0, "res://blank_icon.png", "empty"],
	"basic" : [basic, 50, 3.0, "res://basic_unit_icon.png", "basic"]
}

enum TEAM {ALLY, ENEMY}

var player_money : int = 100
var director_money : int = 100
var player_value : int = 0

func summon(key: String, price: int, team: TEAM):
	var new_unit : Unit = stats[key][0].instantiate()
	if team == TEAM.ALLY:
		new_unit.position = Vector2i(53, 356)
		player_money -= price
		new_unit.set_team(Global.TEAM.ALLY)
		
	if team == TEAM.ENEMY:
		director_money -= price
		new_unit.position = Vector2i(1083, 356)
		new_unit.set_team(Global.TEAM.ENEMY)
		
	add_child(new_unit)
	
func get_stats(unit_name: String):
	return stats[unit_name]

func player_unit_death(unit_type):
	pass
