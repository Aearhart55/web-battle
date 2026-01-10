extends HBoxContainer

@export var unit_list: Array[String]
var slots: Array

func _ready() -> void:
	slots = get_children()
	set_slots(unit_list)

func set_slots(units: Array):
	for i in range(5):
		slots[i].set_stats(Global.get_stats(units[i]))
