extends Unit

func _ready() -> void:
	set_team(Team)

func _physics_process(_delta: float) -> void:
	pass

func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		die()
	
func die():
	self.collision_layer = 0
	self.collision_mask = 0
	anims.play("die")
	await anims.animation_finished
	queue_free()

func set_team(team : Global.TEAM):
	Team = team
	if Team == Global.TEAM.ENEMY:
		anims.flip_h = true
		speed *= -1
		self.collision_layer = 2
		self.collision_mask = 2
	elif Team == Global.TEAM.ALLY:
		anims.flip_h = false
		self.collision_layer = 1
		self.collision_mask = 1
