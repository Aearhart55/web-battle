extends Node

signal director_unit_death_type(type: TYPE, add: bool)
signal player_unit_death_penalty

var basic = preload("res://units/basic/basic_unit.tscn")
var skeleton = preload("res://units/skeleton/skeleton.tscn")

# name : unit, cost, cooldown, icon, key
var stats = {
	"" : ["", 0, 0, "res://units/blank_icon.png", "", TYPE.SPECIAL],
	"empty" : ["empty", 0, 0, "res://units/blank_icon.png", "empty", TYPE.SPECIAL],
	"basic" : [basic, 50, 3.0, "res://units/basic/basic_unit_icon.png", "basic", TYPE.DAMAGE],
	"skeleton" : [skeleton, 25, 2, "res://units/skeleton/skeleton-sprites.png", "skeleton", TYPE.TANK]
}

enum TEAM {ALLY, ENEMY}
enum TYPE {TANK, DAMAGE, SUPPORT, SPECIAL}

var player_money : int = 100
var player_kill_bonus := 0.1

var director_money : int = 100
var director_leech_percent := 0.2
var director_kill_penalty := 0.1
var player_unit_value : int = 0

func summon(key: String, price: int, team: TEAM):
	var new_unit : Unit = stats[key][0].instantiate()
	if team == TEAM.ALLY:
		new_unit.position = Vector2i(53, 356)
		player_money -= price
		player_unit_value += price
		director_money += price * director_leech_percent
		
		new_unit.set_team(Global.TEAM.ALLY)
		
	if team == TEAM.ENEMY:
		director_money -= price
		new_unit.position = Vector2i(1083, 356)
		new_unit.set_team(Global.TEAM.ENEMY)
		
	add_child(new_unit)
	
func get_stats(unit_name: String):
	return stats[unit_name]

func player_unit_death(key: String):
	var unit_value = stats[key][1]
	player_unit_value -= unit_value
	
	director_money -= int(unit_value * director_kill_penalty)
	player_unit_death_penalty.emit()

func director_unit_death(key: String, type: TYPE):
	director_unit_death_type.emit(type, false)
	var unit_value = stats[key][1]
	player_money += int(unit_value * player_kill_bonus)
