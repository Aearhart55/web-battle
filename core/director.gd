extends Node

@export var interest_timer: Timer
@export var units: Array[String]

var rng = RandomNumberGenerator.new()

var types : Array = [Global.TYPE.TANK, Global.TYPE.DAMAGE, Global.TYPE.SUPPORT, Global.TYPE.SPECIAL, "wait"]
# weights: Tank, Damage, Support, Special, wait for decsion
var base_type_weights : Array[float] = [5.0, 3.0, 0.5, 0.5, 0.0]
var type_weights : Array[float] = [5.0, 3.0, 0.5, 0.5, 0.0]
var type_count : Array[int] = [0, 0, 0, 0]

var avaliable_units : Array = []
var cooldown_units : Array = []

var interest_base_value := 10
var interest_unit_scale_percent : float = 0.1
var interest_value : int

func _ready() -> void:
	interest_timer.connect("timeout", gain_interest)
	Global.director_unit_death_type.connect(update_types)
	Global.player_unit_death_penalty.connect(update_wait_weight)
	
	for key in units:
		var unit_stats = Global.get_stats(key)
		# key, price, type, cooldown
		var unit_card := []
		unit_card.append(unit_stats[4])
		unit_card.append(unit_stats[1])
		unit_card.append(unit_stats[5])
		unit_card.append(unit_stats[2])
		avaliable_units.append(unit_card)
	
	pick_unit()
	
func pick_unit():
	var type = types[rng.rand_weighted(type_weights)]
	var spawn_candidate = ""
	if avaliable_units.is_empty() or type is String:
		wait_protocol()
		return
	for unit in avaliable_units:
		if unit[2] == type and unit[1] <= Global.director_money:
			if spawn_candidate is String:
				spawn_candidate = unit
			elif spawn_candidate[1] < unit[1]:
				spawn_candidate = unit
	
	if spawn_candidate is String:
		type_weights[4] += .01
	else:
		unit_on_cooldown(spawn_candidate)
		update_types(spawn_candidate[2])
		Global.summon(spawn_candidate[0], spawn_candidate[1], Global.TEAM.ENEMY)
	await get_tree().create_timer(0.2).timeout
	pick_unit()
	
func gain_interest():
	Global.director_money += interest_base_value + (Global.player_unit_value * interest_unit_scale_percent)
	print((Global.player_unit_value * interest_unit_scale_percent))

func wait_protocol():
	type_weights[4] = 0.0
	await get_tree().create_timer(type_weights[4]*3).timeout
	pick_unit()

func unit_on_cooldown(unit: Array):
	avaliable_units.erase(unit)
	await get_tree().create_timer(unit[3]).timeout
	avaliable_units.append(unit)

func update_types(type: Global.TYPE, add:= true):
	var count = 1
	if not add:
		count = -1
	type_count[type] += count
	
	# maintain attack and defense units
	if type_count[0] < 3:
		type_weights[0] = base_type_weights[0] * 2
	elif type_count[0] < 10:
		type_weights[0] = base_type_weights[0] / 3
	
	if type_count[1] < 1:
		type_weights[1] = base_type_weights[1] * 2
	elif type_count[1] < 10:
		type_weights[1] = base_type_weights[0] / 1.5
	
func update_wait_weight():
	type_weights[4] += .03
