extends Node

# name : unit, cost, cooldown, icon
var stats = {
	"empty" : ["empty", 0, 0, "res://blank_icon.png"],
	"basic" : ["res://basic_unit.tscn", 50, 3.0, "res://basic_unit_icon.png"]
}

enum TEAM {ALLY, ENEMY}

var money : int = 100

func summon(unit: NodePath, team: TEAM):
	if team == TEAM.ALLY:
		pass

func get_stats(unit_name: String):
	return stats[unit_name]
