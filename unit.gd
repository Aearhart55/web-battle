class_name Unit extends Node

enum TEAM {ALLY, ENEMY}

@export var Team : TEAM

@export_category("Stats")
@export var health : int = 1
@export var speed : float = 1
@export var aoe_value : int = 1

@export_category("External Nodes")
@export var attack_range : RayCast2D
@export var cooldown : Timer
@export var anims : AnimatedSprite2D

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if attack_range.is_colliding():
		attack()
	else:
		move(delta)
		
	
func move(delta : float):
	self.position.x += speed * delta
	
func attack():
	if cooldown.is_stopped():
		if anims.animation != "attack":
			anims.play("attack")
			await anims.animation_finished
			anims.play("default")
		cooldown.start()
	
func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		die()
	
func die():
	queue_free()
