class_name RocketTower extends Tower

var rocketTowerScene = preload("res://Towers/RocketTowerScene.tscn")

func _init(_map: Map) -> void:
	super(_map)
	self.add_child(rocketTowerScene.instantiate() as Node3D)

	attack_range = 200
	attack_damage = 50
	attack_speed = 1000

	upgrade_cost = 100
	upgrade_range = 50
	upgrade_damage = 25
	upgrade_attack_speed = 0.5

	cost = 300
	sell_value = 150

var last_fire: float
func attack(unit: Unit) -> Node3D:
	# determine if the tower is ready to attack
	if (last_fire + attack_speed > Time.get_ticks_msec()):
		return null
	last_fire = Time.get_ticks_msec()

	print("Attacking unit: ", unit)

	# create projectile
	var p = LaserProjectile.new(map, Vector3.ZERO, Vector3.ZERO)
	p.position = Vector3(1,2,1)
	p.damage = attack_damage
	map.add_projectile(p)
	return null
