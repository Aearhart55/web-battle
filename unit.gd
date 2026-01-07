class_name Unit extends Node

enum TEAM {ALLY, ENEMY}

@export var Team : TEAM

@export_category("Stats")
@export var health : int = 3
@export var speed : float = 1
@export var damage : int = 1
@export var aoe_value : int = 1

@export_category("External Nodes")
@export var attack_range : RayCast2D
@export var cooldown : Timer
@export var anims : AnimatedSprite2D

var units_hit := 0
var dead = false

func _ready() -> void:
	set_team(Team)
	
func _physics_process(delta: float) -> void:
	if attack_range.is_colliding() and not dead:
		attack()
	elif not dead:
		if anims.animation == "idle" or anims.animation == "move" or not anims.is_playing():
			move(delta)
			anims.play("move")
		
func move(delta : float):
	self.position.x += speed * delta
	
func attack():
	if cooldown.is_stopped() and anims.animation != "windup":
		anims.play("windup")
		await anims.animation_finished
		if attack_range.is_colliding():
			attack_range.get_collider().call("take_dmg", damage)
				
		attack_range.clear_exceptions()
		units_hit = 0
		anims.play("recover")
		cooldown.start()
		await anims.animation_finished
		anims.play("idle")
	
func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		die()
	
func die():
	self.collision_layer = 0
	self.collision_mask = 0
	attack_range.enabled = false
	anims.play("die")
	await anims.animation_finished
	queue_free()

func set_team(team : TEAM):
	Team = team
	if Team == TEAM.ENEMY:
		anims.flip_h = true
		speed *= -1
		attack_range.target_position.x *= -1
		attack_range.collision_mask = 1
		self.collision_layer = 2
		self.collision_mask = 2
	elif Team == TEAM.ALLY:
		anims.flip_h = false
		attack_range.collision_mask = 2
		self.collision_layer = 1
		self.collision_mask = 1
